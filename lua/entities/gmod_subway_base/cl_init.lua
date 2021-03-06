include("shared.lua")

--------------------------------------------------------------------------------
-- Console commands and convars
--------------------------------------------------------------------------------
CreateClientConVar("metrostroi_tooltip_delay",0,true)

concommand.Add("metrostroi_train_manual", function(ply, _, args)
	local w = ScrW() * 2/3
	local h = ScrH() * 2/3
	local browserWindow = vgui.Create("DFrame")
	browserWindow:SetTitle("Train Manual")
	browserWindow:SetPos((ScrW() - w)/2, (ScrH() - h)/2)
	browserWindow:SetSize(w,h)
	browserWindow.OnClose = function()
		browser = nil
		browserWindow = nil
	end
	browserWindow:MakePopup()

	local browser = vgui.Create("DHTML",browserWindow)
	browser:SetPos(10, 25)
	browser:SetSize(w - 20, h - 35)

	browser:OpenURL("http://foxworks.wireos.com/metrostroi/manual.html")
end)




--------------------------------------------------------------------------------
-- Buttons layout
--------------------------------------------------------------------------------
--ENT.ButtonMap = {} Leave nil if unused

-- General Panel
--[[table.insert(ENT.ButtonMap,{
	pos = Vector(7,0,0),
	ang = Angle(0,90,90),
	width = 300,
	height = 100,
	scale = 0.0625,
	
	buttons = {
		{ID=1, x=-117,  y=   0,  radius=20, tooltip="Test 1"},
		{ID=2, x= -80,  y=   0,  radius=20, tooltip="Test 2"},
	}
})]]--


--------------------------------------------------------------------------------
-- Decoration props
--------------------------------------------------------------------------------
ENT.ClientProps = {}

--[[table.insert(ENT.ClientProps,{
	model = "models/metrostroi/81-717/cabin.mdl",
	pos = Vector(421,-5,15),
	ang = Angle(0,-90,0)
})]]--





--------------------------------------------------------------------------------
-- Clientside entities support
--------------------------------------------------------------------------------
local lastButton
local drawCrosshair
local toolTipText
local lastAimButtonChange
local lastAimButton

function ENT:ShouldRenderClientEnts()
	return true--self:LocalToWorld(Vector(-450,0,0)):Distance(LocalPlayer():GetPos()) < 512
end

function ENT:CreateCSEnts()
	for k,v in pairs(self.ClientProps) do
		if k ~= "BaseClass" then
			local cent = ClientsideModel(v.model ,RENDERGROUP_OPAQUE)
			cent:SetPos(self:LocalToWorld(v.pos))
			cent:SetAngles(self:LocalToWorldAngles(v.ang))
			cent:SetParent(self)
			self.ClientEnts[k] = cent
		end
	end
end

function ENT:RemoveCSEnts()
	for k,v in pairs(self.ClientEnts) do
		v:Remove()
	end
	self.ClientEnts = {}
end

function ENT:ApplyCSEntRenderMode(render)
	for k,v in pairs(self.ClientEnts) do
		if render then
			v:SetRenderMode(RENDERMODE_NORMAL)
		else
			v:SetRenderMode(RENDERMODE_NONE)
		end
	end
end



--------------------------------------------------------------------------------
-- Clientside initialization
--------------------------------------------------------------------------------
function ENT:Initialize()
	-- Create clientside props
	self.ClientEnts = {}
	self.RenderClientEnts = self:ShouldRenderClientEnts()
	if self.RenderClientEnts then
		self:CreateCSEnts()
	end
	
	-- Systems defined in the train
	self.Systems = {}
	-- Initialize train systems
	self:InitializeSystems()
	
	-- Create sounds
	self:InitializeSounds()
	self.Sounds = {}
	if self.SoundNames then
		for k,v in pairs(self.SoundNames) do
			if type(v) == "string" then
				util.PrecacheSound(v)
				self.Sounds[k] = CreateSound(self, Sound(v))
			end
		end
	end
end

function ENT:OnRemove()
	self:RemoveCSEnts()
	drawCrosshair = false
	toolTipText = nil
	
	for k,v in pairs(self.Sounds) do
		v:Stop()
	end
end




--------------------------------------------------------------------------------
-- Sound functions (clientside)
--------------------------------------------------------------------------------
function ENT:SetSoundState(sound,volume,pitch)
	if not self.Sounds[sound] then return end
	if (volume <= 0) or (pitch <= 0) then
		self.Sounds[sound]:Stop()
		self.Sounds[sound]:ChangeVolume(0.0,0)
		return
	end

	local pch = math.floor(math.max(0,math.min(255,100*pitch)) + math.random())
	self.Sounds[sound]:Play()
	self.Sounds[sound]:ChangeVolume(math.max(0,math.min(255,2.55*volume)) + (0.001/2.55) + (0.001/2.55)*math.random(),0)
	self.Sounds[sound]:ChangePitch(pch+1,0)
end




--------------------------------------------------------------------------------
-- Default think function
--------------------------------------------------------------------------------
function ENT:Think()
	self.PrevTime = self.PrevTime or CurTime()
	self.DeltaTime = (CurTime() - self.PrevTime)
	self.PrevTime = CurTime()
	
	if self.Systems then
		for k,v in pairs(self.Systems) do
			v:ClientThink()
		end
	end
	
	-- Update CSEnts
	if CurTime() - (self.PrevThinkTime or 0) > .5 then
		self.PrevThinkTime = CurTime()
		
		-- Invalidate entities if needed, for hotloading purposes
		if not self.ClientPropsInitialized then
			self.ClientPropsInitialized = true
			self:RemoveCSEnts()
			self.RenderClientEnts = false
		end
		
		local shouldrender = self:ShouldRenderClientEnts()
		if self.RenderClientEnts ~= shouldrender then
			self.RenderClientEnts = shouldrender
			if self.RenderClientEnts then
				self:CreateCSEnts()
			else
				self:RemoveCSEnts()
			end
		end
		
		--Uncomment for skin disco \o/
		--[[
		for k,v in pairs(self.ClientEnts) do
			if v:SkinCount() > 0 then
				v:SetSkin((v:GetSkin()+1)%(v:SkinCount()-1))
			end
		end
		]]--
	end
	
	--print("Acceleration at (0,0,0)",self:GetTrainAccelerationAtPos(Vector(0,0,0)))
	--print("Acceleration at (400,0,0)",self:GetTrainAccelerationAtPos(Vector(400,0,0)))
	--Example of pose parameter
	--[[for k,v in pairs(self.ClientEnts) do
		if v:GetPoseParameterRange(0) != nil then
			v:SetPoseParameter("position",math.sin(CurTime()*4)/2+0.5)
		end
	end]]--
end



--------------------------------------------------------------------------------
-- Various rendering shortcuts for trains
--------------------------------------------------------------------------------
function ENT:DrawCircle(cx,cy,radius)
	local step = 2*math.pi/12
	local vertexBuffer = { {}, {}, {} }

	for i=1,12 do
		vertexBuffer[1].x = cx + radius*math.sin(step*(i+0))
		vertexBuffer[1].y = cy + radius*math.cos(step*(i+0))
		vertexBuffer[2].x = cx
		vertexBuffer[2].y = cy
		vertexBuffer[3].x = cx + radius*math.sin(step*(i+1))
		vertexBuffer[3].y = cy + radius*math.cos(step*(i+1))
		surface.DrawPoly(vertexBuffer)
	end
end

--------------------------------------------------------------------------------
-- Default rendering function
--------------------------------------------------------------------------------
function ENT:Draw()
	self.dT = CurTime() - (self.PrevTime or CurTime())
	self.PrevTime = CurTime()

	-- Draw model
	self:DrawModel()
	
	-- Debug draw for buttons
	if (GetConVarNumber("metrostroi_drawdebug") > 0) and (self.ButtonMap ~= nil) then
		for kp,panel in pairs(self.ButtonMap) do
			if kp ~= "BaseClass" then
				self:DrawOnPanel(kp,function()
					surface.SetDrawColor(0,0,255)
					surface.DrawOutlinedRect(0,0,panel.width,panel.height)
					
					if panel.aimX and panel.aimY then
						surface.SetTextColor(255,255,255)
						surface.SetFont("BudgetLabel")
						surface.SetTextPos(panel.width/2,5)
						surface.DrawText(string.format("%d %d",panel.aimX,panel.aimY))
					end
					
					
					--surface.SetDrawColor(255,255,255)
					--surface.DrawRect(0,0,panel.width,panel.height)
					if panel.buttons then
						
						surface.SetAlphaMultiplier(0.2) 
						
						for kb,button in pairs(panel.buttons) do
							if not button.ID then
								surface.SetDrawColor(25,40,180)
							elseif button.state then
								surface.SetDrawColor(255,0,0)
							else
								surface.SetDrawColor(0,255,0)
							end
							self:DrawCircle(button.x,button.y,button.radius or 10)
							surface.DrawRect(button.x-8,button.y-8,16,16)
						end
						
						--Gotta reset this otherwise the qmenu draws transparent as well
						surface.SetAlphaMultiplier(1) 
						
					end
					
					
				end)
			end
		end
	end
end


function ENT:DrawOnPanel(index,func)
	local panel = self.ButtonMap[index]
	cam.Start3D2D(self:LocalToWorld(panel.pos),self:LocalToWorldAngles(panel.ang),panel.scale)
		func(panel)
	cam.End3D2D()
end



--------------------------------------------------------------------------------
-- Animation function
--------------------------------------------------------------------------------
function ENT:Animate(clientProp, value, min, max, speed, damping, stickyness)
	if self.ClientEnts[clientProp] then
		local id = clientProp
		if not self["_anim_"..id] then
			self["_anim_"..id] = value
			self["_anim_"..id.."V"] = 0.0
		end
		
		-- Generate sticky value
		if stickyness and damping then
			self["_anim_"..id.."_stuck"] = self["_anim_"..id.."_stuck"] or false
			self["_anim_"..id.."P"] = self["_anim_"..id.."P"] or value
			if (math.abs(self["_anim_"..id.."P"] - value) < stickyness) and (self["_anim_"..id.."_stuck"]) then
				value = self["_anim_"..id.."P"]
				self["_anim_"..id.."_stuck"] = false
			else
				self["_anim_"..id.."P"] = value
			end
		end
			
		if damping == false then
			local dX = speed * self.DeltaTime
			if value > self["_anim_"..id] then
				self["_anim_"..id] = self["_anim_"..id] + dX
			end
			if value < self["_anim_"..id] then
				self["_anim_"..id] = self["_anim_"..id] - dX
			end
			if math.abs(value - self["_anim_"..id]) < dX then
				self["_anim_"..id] = value
			end
		else
			local dX2dT = (speed or 128)*(value - self["_anim_"..id]) - self["_anim_"..id.."V"] * (damping or 8.0)
			self["_anim_"..id.."V"] = self["_anim_"..id.."V"] + dX2dT * self.DeltaTime
			self["_anim_"..id] = math.max(0,math.min(1,self["_anim_"..id] + self["_anim_"..id.."V"] * self.DeltaTime))
			
			-- Check if value got stuck
			if (math.abs(dX2dT) < 0.001) and stickyness and (self.DeltaTime > 0) then
				self["_anim_"..id.."_stuck"] = true
			end
		end
		
		self.ClientEnts[clientProp]:SetPoseParameter("position",min + (max-min)*self["_anim_"..id])
	end
end

function ENT:ShowHide(clientProp, value)
	if self.ClientEnts[clientProp] then
		if value == true then
			self.ClientEnts[clientProp]:SetRenderMode(RENDERMODE_NORMAL)
			self.ClientEnts[clientProp]:SetColor(Color(255,255,255,255))
		else
			self.ClientEnts[clientProp]:SetRenderMode(RENDERMODE_NONE)
			self.ClientEnts[clientProp]:SetColor(Color(0,0,0,0))
		end		
	end
end




local digit_bitmap = {
  [1] = { 0,0,1,0,0,1,0 },
  [2] = { 1,0,1,1,1,0,1 },
  [3] = { 1,0,1,1,0,1,1 },
  [4] = { 0,1,1,1,0,1,0 },
  [5] = { 1,1,0,1,0,1,1 },
  [6] = { 1,1,0,1,1,1,1 },
  [7] = { 1,0,1,0,0,1,0 },
  [8] = { 1,1,1,1,1,1,1 },
  [9] = { 1,1,1,1,0,1,1 },
  [0] = { 1,1,1,0,1,1,1 },
}

local segment_poly = {
	[1] = { 	
		{ x = 0,    y = 0 },
		{ x = 100,  y = 0 },
		{ x =  80,  y = 20 },
		{ x =  20,  y = 20 },
	},
	[2] = { 	
		{ x =  20,  y = 0 },
		{ x =  80,  y = 0 },
		{ x = 100,  y = 20 },
		{ x =   0,  y = 20 },
	},
	[3] = { 	
		{ x =  0,  y = 0 },
		{ x = 20,  y = 20 },
		{ x = 20,  y = 80 },
		{ x =  0,  y = 100 },
	},
	[4] = { 	
		{ x =  0,  y = 20 },
		{ x = 20,  y = 0 },
		{ x = 20,  y = 100 },
		{ x =  0,  y = 80 },
	},
	[5] = { 	
		{ x = 0,  y = 12 },
		{ x = 20,  y = 0 },
		{ x = 80,  y = 0 },
		{ x = 100,  y = 12 },
		{ x = 80,  y = 24 },
		{ x = 20,  y = 24 },
	},
}

function ENT:DrawSegment(i,x,y,scale_x,scale_y)
	local poly = {}
	for k,v in pairs(segment_poly[i]) do
		poly[k] = {
			x = (v.x*scale_x) + x,
			y = (v.y*scale_y) + y,		
		}
	end
	
	surface.SetDrawColor(Color(100,255,0,255))
	draw.NoTexture()
	surface.DrawPoly(poly)
end

function ENT:DrawDigit(cx,cy,digit,scalex,scaley,thickness)
	scalex = scalex or 1
	scaley = scaley or scalex
	thickness = thickness or 1
	local bitmap = digit_bitmap[digit]
	if not bitmap then return end

	local sx = 0.9*scalex*thickness
	local sy = 0.9*scaley*thickness
	local dx = scalex
	local dy = scaley
	
	if bitmap[1] == 1 then self:DrawSegment(1,cx+5*dx,cy,			sx,sy)	end
	if bitmap[2] == 1 then self:DrawSegment(3,cx,cy+10*dy,			sx,sy)	end
	if bitmap[3] == 1 then self:DrawSegment(4,cx+80*dx,cy+10*dy,	sx,sy)	end
	if bitmap[4] == 1 then self:DrawSegment(5,cx+5*dx,cy+95*dy,		sx,sy)	end
	if bitmap[5] == 1 then self:DrawSegment(3,cx,cy+110*dy,			sx,sy)	end
	if bitmap[6] == 1 then self:DrawSegment(4,cx+80*dx,cy+110*dy,	sx,sy)	end
	if bitmap[7] == 1 then self:DrawSegment(2,cx+5*dx,cy+190*dy,	sx,sy)	end
end



--------------------------------------------------------------------------------
-- Get train acceleration at given position in train
--------------------------------------------------------------------------------
function ENT:GetTrainAccelerationAtPos(pos)
	local localAcceleration = self:GetTrainAcceleration()
	local angularVelocity = self:GetTrainAngularVelocity()
	
	return localAcceleration - angularVelocity:Cross(angularVelocity:Cross(pos*0.01905))
end






--------------------------------------------------------------------------------
-- Look into mirrors hook
--------------------------------------------------------------------------------
hook.Add("CalcView", "Metrostroi_TrainView", function(ply,pos,ang,fov,znear,zfar)
	local seat = ply:GetVehicle()
	if (not seat) or (not seat:IsValid()) then return end
	local train = seat:GetNWEntity("TrainEntity")
	if (not train) or (not train:IsValid()) then return end
	
	--[[-- Get acceleration in the train
	local headPos = train:WorldToLocal(pos)
	local acceleration = train:GetTrainAccelerationAtPos(headPos)
	train.Acceleration = train.Acceleration or Vector(0,0,0)
	train.Acceleration = train.Acceleration + 0.5*(acceleration - train.Acceleration)*train.DeltaTime
	if train.Acceleration:Length() > 100 then train.Acceleration = Vector(0,0,0) end
	
	-- Calculate direction
	local direction = train.Acceleration:GetNormalized()
	-- Calculate visual offset
	local a = train.Acceleration:Length()
	local factor = a * math.exp(-0.05*a)
	local offset = 4 * direction * factor
	
	print(train.Acceleration)
	-- Apply offset
	return {
		origin = train:LocalToWorld(headPos + 0.1*offset),
		angles = ang + Angle(offset.x,0,0),
	}]]--
	
	
	--[[if seat:GetThirdPersonMode() then
		local trainAng = ang - train:GetAngles()
		if trainAng.y >  180 then trainAng.y = trainAng.y - 360 end
		if trainAng.y < -180 then trainAng.y = trainAng.y + 360 end
		if trainAng.y > 0 then
			return {
				origin = train:LocalToWorld(Vector(-471,70,34)),
				angles = train:GetAngles() + Angle(2,5,0),
				fov = 20,
				znear = znear,
				zfar = zfar
			}
		else --if trainAng.y < 0 then
			return {
				origin = train:LocalToWorld(Vector(-471,-70,34)),
				angles = train:GetAngles() + Angle(2,-5,0),
				fov = 20,
				znear = znear,
				zfar = zfar
			}
		end
	end]]--
end)




--------------------------------------------------------------------------------
-- Buttons/panel clicking
--------------------------------------------------------------------------------
--Thanks old gmod wiki!
--[[
Converts from world coordinates to Draw3D2D screen coordinates.
vWorldPos is a vector in the world nearby a Draw3D2D screen.
vPos is the position you gave Start3D2D. The screen is drawn from this point in the world.
scale is a number you also gave to Start3D2D.
aRot is the angles you gave Start3D2D. The screen is drawn rotated according to these angles.
]]--

local function WorldToScreen(vWorldPos,vPos,vScale,aRot)
    local vWorldPos=vWorldPos-vPos;
    vWorldPos:Rotate(Angle(0,-aRot.y,0));
    vWorldPos:Rotate(Angle(-aRot.p,0,0));
    vWorldPos:Rotate(Angle(0,0,-aRot.r));
    return vWorldPos.x/vScale,(-vWorldPos.y)/vScale;
end

-- Calculates line-plane intersect location
local function LinePlaneIntersect(PlanePos,PlaneNormal,LinePos,LineDir)
	local dot = LineDir:Dot(PlaneNormal)
	local fac = LinePos-PlanePos 
	local dis = -PlaneNormal:Dot(fac) / dot
	return LineDir * dis + LinePos
end

local function IsFacingPanel(ply,ang)
	return ply:GetEyeTrace().Normal:Dot(ang:Up()) < 0
end

-- Checks if the player is driving a train, also returns said train
local function isValidTrainDriver(ply)
	local seat = ply:GetVehicle()
	if (not seat) or (not seat:IsValid()) then return false end
	local train = seat:GetNWEntity("TrainEntity")
	if (not train) or (not train:IsValid()) then return false end
	return train
end

local function findAimButton(ply)
	local train = isValidTrainDriver(ply)
	if IsValid(train) and train.ButtonMap != nil then
		local foundbuttons = {}
		for kp,panel in pairs(train.ButtonMap) do
			
			--If player is looking at this panel
			if panel.aimedAt and panel.buttons then
				
				--Loop trough every button on it
				for kb,button in pairs(panel.buttons) do
					
					--If the aim location is withing button radis
					local dist = math.Dist(button.x,button.y,panel.aimX,panel.aimY)
					if dist < (button.radius or 10) then
						table.insert(foundbuttons,{button,dist})
					end
				end
			end
		end
		
		if #foundbuttons > 0 then
			table.SortByMember(foundbuttons,2,true)
			return foundbuttons[1][1]
		else 
			return false
		end
	end
end

-- Checks what button/panel is being looked at and check for custom crosshair
hook.Add("Think","metrostroi-cabin-panel",function()
	local ply = LocalPlayer()
	if !IsValid(ply) then return end
	
	toolTipText = nil
	drawCrosshair = false
	
	local train = isValidTrainDriver(ply)
	if(IsValid(train) and not ply:GetVehicle():GetThirdPersonMode() and train.ButtonMap != nil) then
		
		local tr = ply:GetEyeTrace()
		
		-- Loop trough every panel
		for k2,panel in pairs(train.ButtonMap) do
			local wang = train:LocalToWorldAngles(panel.ang)
			if IsFacingPanel(ply,wang) then
				local wpos = train:LocalToWorld(panel.pos)
				
				local isectPos = LinePlaneIntersect(wpos,wang:Up(),tr.StartPos,tr.Normal)
				local localx,localy = WorldToScreen(isectPos,wpos,panel.scale,wang)
				
				panel.aimX = localx
				panel.aimY = localy
				panel.aimedAt = (localx > 0 and localx < panel.width and localy > 0 and localy < panel.height)
			else
				panel.aimedAt = false
			end
		end
		
		-- Check if we should draw the crosshair
		for kp,panel in pairs(train.ButtonMap) do
			if panel.aimedAt then 
				drawCrosshair = true
				break
			end
		end
		
		-- Tooltips
		local ttdelay = GetConVarNumber("metrostroi_tooltip_delay")
		if ttdelay and ttdelay >= 0 then
			local button = findAimButton(ply)
			
			if button != lastAimButton then
				lastAimButtonChange = CurTime()
				lastAimButton = button
			end
			
			
			if button then
				if ttdelay == 0 or CurTime() - lastAimButtonChange > ttdelay then
					toolTipText = findAimButton(ply).tooltip
				end
			end
		end
	end
end)


-- Takes button table, sends current status
local function sendButtonMessage(button)
	if not button.ID then return end
	net.Start("metrostroi-cabin-button")
	net.WriteString(button.ID) 
	net.WriteBit(button.state)
	net.SendToServer()
end

-- Goes over a train's buttons and clears them, sending a message if needed
function ENT:ClearButtons()
	if self.ButtonMap == nil then return end
	for kp,panel in pairs(self.ButtonMap) do
		if panel.buttons then
			for kb,button in pairs(panel.buttons) do
				if button.state == true then
					button.state = false
					sendButtonMessage(button)
				end
			end
		end
	end
end


-- Args are player, IN_ enum and bool for press/release
local function handleKeyEvent(ply,key,pressed)
	if not IsFirstTimePredicted() then return end
	-- if !IsFirstTimePredicted() then return end
	if key ~= IN_ATTACK then return end
	if not IsValid(ply) then return end
	local train = isValidTrainDriver(ply)
	if not IsValid(train) then return end
	if train.ButtonMap == nil then return end

	if pressed then
		local button = findAimButton(ply)
		if button and !button.state then
			button.state = true
			sendButtonMessage(button)
			lastButton = button

			if train.OnButtonPressed then
				train:OnButtonPressed(button.ID)
			end
		end
	else 
		-- Reset the last button pressed
		if lastButton != nil then
			if lastButton.state == true then
				lastButton.state = false
				sendButtonMessage(lastButton)
			end

			if train.OnButtonReleased then
				train:OnButtonReleased(button.ID)
			end
		end
	end
end

-- Hook for clearing the buttons when player exits
net.Receive("metrostroi-cabin-reset",function(len,_)
	local ent = net.ReadEntity()
	if IsValid(ent) and ent.ClearButtons ~= nil then
		ent:ClearButtons()
	end
end)

hook.Add("KeyPress", "metrostroi-cabin-buttons", function(ply,key) handleKeyEvent(ply, key,true) end)
hook.Add("KeyRelease", "metrostroi-cabin-buttons", function(ply,key) handleKeyEvent(ply, key,false) end)

hook.Add( "HUDPaint", "metrostroi-draw-crosshair-tooltip", function()
	if IsValid(LocalPlayer()) then
		local scrX,scrY = surface.ScreenWidth(),surface.ScreenHeight()
		
		if drawCrosshair then
			surface.DrawCircle(scrX/2,scrY/2,4.1,Color(255,255,150))
		end
		
		if toolTipText != nil then
			surface.SetFont("BudgetLabel")
			local w = surface.GetTextSize(toolTipText)
			surface.SetTextPos((scrX-w)/2,scrY/2+10)
			surface.SetTextColor(255,255,255)
			surface.DrawText(toolTipText)
		end
		
		
	end
end)
