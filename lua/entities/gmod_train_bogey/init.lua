AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")




--------------------------------------------------------------------------------
function ENT:Initialize()
	-- Set bogey model
	self:SetModel("models/myproject/81-717_bogey.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	-- Set proper parameters for the bogey
	self:GetPhysicsObject():SetMass(5000)
	
	-- Create wire controls
	if Wire_CreateInputs then
		self.Inputs = Wire_CreateInputs(self,{
			"TrainLinePressure", "DriverValvePosition",
			"MotorPower", "MotorForce", "MotorReversed" })
		self.Outputs = Wire_CreateOutputs(self,{
			"Speed",
			"ReservoirPressure", "TrainLinePressure",
			"BrakeLinePressure", "BrakeCylinderPressure"
		})
	end
	
	-- Setup default motor state
	self.Reversed = false
	self.MotorForce = 30000.0
	self.MotorPower = 0.0
	self.Speed = 0
	

	-- Maximum pneumatic brake force at P = 4.5 atm
	self.PneumaticBrakeForce = 45000.0
	-- Pressure in reservoir
	self.ReservoirPressure = 4.0 -- atm
	-- Pressure in trains feed line
	self.TrainLinePressure = 4.5 -- atm
	-- Pressure in trains brake line
	self.BrakeLinePressure = 4.0 -- atm
	-- Pressure in brake cylinder
	self.BrakeCylinderPressure = 0.0 -- atm
	
	
	-- Position of the train drivers valve
	-- 1 Charge/brake release
	-- 2 Driving
	-- 3 Closed
	-- 4 Service application
	-- 5 Emergency application
	self.DriverValvePosition = 1

	-- Rate of brake line filling from train line
	self.BrakeLineFillRate			= 0.700 -- atm/sec
	-- Rate of equalizing reservoir filling from train line
	self.ReservoirFillRate			= 1.500 -- atm/sec
	-- Replenish rate for brake line
	self.BrakeLineReplenishRate 	= 0.100 -- atm/sec
	-- Replenish rate for reservoir
	self.ReservoirReplenishRate 	= 1.000 -- atm/sec
	-- Release to atmosphere rate
	self.ReservoirReleaseRate	 	= 1.500 -- atm/sec

	-- Rate of pressure leak from reservoir
	self.ReservoirLeakRate			= 1e-3	-- atm/sec
	-- Rate of pressure leak from brake line
	self.BrakeLineLeakRate			= 1e-4	-- atm/sec
	-- Rate of release to reservoir
	self.BrakeLineReleaseRate	 	= 0.350 -- atm/sec

	-- Emergency release rate
	self.BrakeLineEmergencyRate 	= 0.800 -- atm/sec
end

function ENT:InitializeWheels()
	-- Check if wheels are already connected
	local c_ents = constraint.FindConstraints(self,"Weld")
	local wheels = nil
	for k,v in pairs(c_ents) do
		if v.Ent2:GetClass() == "gmod_train_wheels" then
			wheels = v.Ent2
		end
	end

	-- Create missing wheels
	if not wheels then
		wheels = ents.Create("gmod_train_wheels")
		wheels:SetPos(self:LocalToWorld(Vector(0,0.0,-14)))
		wheels:SetAngles(self:GetAngles() + Angle(0,90,0))
		wheels:Spawn()

		constraint.Weld(self,wheels,0,0,0,1,0)
	end
	wheels:SetOwner(self:GetOwner())
	wheels:SetNWEntity("TrainBogey",self)
	self.Wheels = wheels
end

function ENT:OnRemove()
	SafeRemoveEntity(self.Wheels)
end

function ENT:TriggerInput(iname, value)
	if iname == "TrainLinePressure" then
		self.TrainLinePressure = value
	elseif iname == "DriverValvePosition" then
		self.DriverValvePosition = value
		
	elseif iname == "MotorPower" then
		self.MotorPower = value
	elseif iname == "MotorForce" then
		self.MotorForce = value
	elseif iname == "MotorReversed" then
		self.Reversed = value > 0.5
	end
end

function ENT:Think()
	-- Re-initialize wheels
	if (not self.Wheels) or
		(not self.Wheels:IsValid()) or
		(self.Wheels:GetNWEntity("TrainBogey") ~= self) then
		self:InitializeWheels()
	end
 
	-- Update timing
	self.PrevTime = self.PrevTime or CurTime()
	self.DeltaTime = (CurTime() - self.PrevTime)
	self.PrevTime = CurTime()
	

	-- Skip logic
	if not (self.Wheels and self.Wheels:IsValid() and self.Wheels:GetPhysicsObject():IsValid()) then
		return
	end

	-- Get speed of bogey in km/h
	local localSpeed = -self:GetVelocity():Dot(self:GetAngles():Forward()) * 0.06858
	local absSpeed = math.abs(localSpeed)
	if self.Reversed then localSpeed = -localSpeed end

	local sign = 1
	if localSpeed < 0 then sign = -1 end
	self.Speed = absSpeed


	-- Apply specific rate to equalize pressure
	local function equalizePressure(pressure,target,rate,fill_rate)
		if fill_rate and (target > self[pressure]) then rate = fill_rate end
		
		-- Calculate derivative
		local dPdT = rate
		if target < self[pressure] then dPdT = -dPdT end
		local dPdTramp = math.min(1.0,math.abs(target - self[pressure])*1.0)
		dPdT = dPdT*dPdTramp

		-- Update pressure
		self[pressure] = self[pressure] + self.DeltaTime * dPdT
		self[pressure] = math.max(0.0,math.min(7.0,self[pressure]))
		self[pressure.."_dPdT"] = (self[pressure.."_dPdT"] or 0) + dPdT
		return dPdT
	end
	

	-- Accumulate derivatives
	self.BrakeLinePressure_dPdT = 0.0
	self.ReservoirPressure_dPdT = 0.0

	-- Fill reservoir from train line, fill brake line from train line
	if self.DriverValvePosition == 1 then
		equalizePressure("BrakeLinePressure", self.TrainLinePressure, self.BrakeLineFillRate)
		equalizePressure("ReservoirPressure", self.TrainLinePressure, self.ReservoirFillRate)
	end
	-- Brake line, reservoir replenished from train line
	if self.DriverValvePosition == 2 then
		equalizePressure("BrakeLinePressure", self.TrainLinePressure, self.BrakeLineReplenishRate)
		equalizePressure("ReservoirPressure", self.TrainLinePressure, self.ReservoirReplenishRate)
	end
	-- Equalize pressure between reservoir and brake line
	if self.DriverValvePosition == 3 then
		equalizePressure("ReservoirPressure", self.BrakeLinePressure, self.ReservoirReleaseRate,self.ReservoirFillRate)
		equalizePressure("BrakeLinePressure", self.ReservoirPressure, self.BrakeLineReleaseRate,self.BrakeLineFillRate)
	end
	-- Reservoir open to atmosphere, brake line open to reservoir
	if self.DriverValvePosition == 4 then
		equalizePressure("ReservoirPressure", 0.0,										self.ReservoirReleaseRate)
		equalizePressure("BrakeLinePressure", self.ReservoirPressure, self.BrakeLineReleaseRate)
	end
	-- Reservoir and brake line open to atmosphere
	if self.DriverValvePosition == 5 then
		equalizePressure("ReservoirPressure", 0.0, self.ReservoirReleaseRate)
		equalizePressure("BrakeLinePressure", 0.0, self.BrakeLineEmergencyRate)
	end
	
	-- Brake line leaks
	equalizePressure("BrakeLinePressure", 0.0, self.BrakeLineLeakRate)
	-- Reservoir leaks
	equalizePressure("ReservoirPressure", 0.0, self.ReservoirLeakRate)
	
	
	-- Final brake cylinder pressure
	self.BrakeCylinderPressure = math.max(0.0,4.5 - self.BrakeLinePressure)
	if (self.BrakeCylinderPressure > 1.5) and (absSpeed < 0.5) then
		self.Wheels:GetPhysicsObject():SetMaterial("gmod_silent")
	else
		self.Wheels:GetPhysicsObject():SetMaterial("gmod_ice")
	end

	-- Calculate motor power
	local motorPower = 0.0
	if self.MotorPower > 0.0 then
		motorPower = self.MotorPower
	else
		motorPower = self.MotorPower*sign
	end
	motorPower = math.max(-1.0,motorPower)
	motorPower = math.min(1.0,motorPower)
	
	
	-- Calculate forces
	local motorForce = self.MotorForce*motorPower
	local pneumaticForce = -sign*self.PneumaticBrakeForce*(self.BrakeCylinderPressure / 4.5)
	
	-- Apply sideways friction
--	local sideSpeed = -self:GetVelocity():Dot(self:GetAngles():Right()) * 0.06858
--	local sideForce = sideSpeed*100000
	
	-- Apply force
	local dt_scale = 66.6/(1/self.DeltaTime)
	local force = dt_scale*(motorForce + pneumaticForce)
	
	if self.Reversed
	then self:GetPhysicsObject():ApplyForceCenter( self:GetAngles():Forward()*force)-- + self:GetAngles():Forward()*side_force*dt_scale)
	else self:GetPhysicsObject():ApplyForceCenter(-self:GetAngles():Forward()*force)-- + self:GetAngles():Forward()*side_force*dt_scale)
	end
	
	-- Send parameters to client
	self:SetMotorPower(motorPower)
	self:SetSpeed(absSpeed)
	self:SetdPdT(self.BrakeLinePressure_dPdT)
	self:NextThink(CurTime())
	
	-- Trigger outputs
	if Wire_TriggerOutput then
		Wire_TriggerOutput(self, "Speed", absSpeed)
		Wire_TriggerOutput(self, "ReservoirPressure",		 ReservoirPressure)
		Wire_TriggerOutput(self, "TrainLinePressure",		 TrainLinePressure)
		Wire_TriggerOutput(self, "BrakeLinePressure",		 BrakeLinePressure)
		Wire_TriggerOutput(self, "BrakeCylinderPressure", BrakeCylinderPressure)
	end
	return true
end