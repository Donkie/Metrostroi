include("shared.lua")

--------------------------------------------------------------------------------
surface.CreateFont("Subway81717_Indicator", {
  font = "Arial",
  size = 20,
  weight = 1000,
  blursize = 0,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = false,
  additive = false,
  outline = false
})

surface.CreateFont("Subway81717_LargeText", {
  font = "Trebuchet",
  size = 30,
  weight = 1000,
  blursize = 0,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = false,
  additive = false,
  outline = false
})

surface.CreateFont("Subway81717_ARS", {
  font = "Trebuchet",
  size = 14,
  weight = 1000,
  blursize = 0,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = false,
  additive = false,
  outline = false
})

surface.CreateFont("Subway81717_LCD", {
  font = "Digital-7",
  size = 48,
  antialias = true,
  additive = false,
  outline = false
})

surface.CreateFont("Subway81717_LCDGlow", {
  font = "Digital-7",
  size = 48,
  weight = 500,
  blursize = 7,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = false,
  additive = false,
  outline = false
})



local digit_bitmap = {
  [1] = {
     0,
   0,  1,
     0,
   0,  1,
     0 },
  [2] = {
     1,
   0,  1,
     1,
   1,  0,
     1 },
  [3] = {
     1,
   0,  1,
     1,
   0,  1,
     1 },
  [4] = {
     0,
   1,  1,
     1,
   0,  1,
     0 },
  [5] = {
     1,
   1,  0,
     1,
   0,  1,
     1 },
  [6] = {
     1,
   1,  0,
     1,
   1,  1,
     1 },
  [7] = {
     1,
   0,  1,
     0,
   0,  1,
     0 },
  [8] = {
     1,
   1,  1,
     1,
   1,  1,
     1 },
  [9] = {
     1,
   1,  1,
     1,
   0,  1,
     1 },
  [0] = {
     1,
   1,  1,
     0,
   1,  1,
     1 },
}

ENT.ButtonMap = {}

//General Panel
ENT.ButtonMap[1] = {
	pos = Vector(-455,-10,7),
	ang = Angle(0,90,40),
	width = 440,
	height = 190,
	scale = 0.0625,
	
	buttons = {
		{205,28,20},
		{440,190}
	}
}

//Main panel
ENT.ButtonMap[2] = {
	pos = Vector(-455,-27,15),
	ang = Angle(0,90,60),
	width = 860,
	height = 290,
	scale = 0.0625,
	
	buttons = {
		{860,290},
		{50,100},
		{100,50},
		{100,100}
	}
}


function ENT:DrawSegment(x,y,w,h)
  for z=1,6,1 do
    surface.SetDrawColor(Color(100,255,0,math.max(0,13-1*z*z)))
    surface.DrawRect(x-z, y-z, w+2*z, h+2*z)
  end

  surface.SetDrawColor(Color(100,255,0,255))
  surface.DrawRect(x, y, w, h)
end

function ENT:DrawDigit(cx,cy,digit)
  local bitmap = digit_bitmap[digit]
  if not bitmap then return end

  if bitmap[1] == 1 then self:DrawSegment(cx+3, cy+5,14,3) end
  if bitmap[2] == 1 then self:DrawSegment(cx+0, cy+10,3,10) end
  if bitmap[3] == 1 then self:DrawSegment(cx+17,cy+10,3,10) end
  if bitmap[4] == 1 then self:DrawSegment(cx+3, cy+21,12,3) end
  if bitmap[5] == 1 then self:DrawSegment(cx+0, cy+24,3,10) end
  if bitmap[6] == 1 then self:DrawSegment(cx+17,cy+24,3,10) end
  if bitmap[7] == 1 then self:DrawSegment(cx+3, cy+36,12,3) end
end



--------------------------------------------------------------------------------
function ENT:DrawIndicator(text,x,y,state,color)
  if state and (self.Mode > 0) then
    surface.SetDrawColor(color)
  else
    surface.SetDrawColor(0,0,0,255)
  end
  surface.DrawRect(x,y,10,10)
  draw.DrawText(text,"Subway81717_Indicator",x+16,y-4,Color(0,0,0,255))
end

function ENT:DrawArrow(value,min,max,x,y,size)
  local frac = math.min(1,math.max(0,(value-min)/(max-min)))
  local point1 = {x=x,y=y}
  local point2 = {
    x = x + size*math.cos(math.pi*0.8+1.4*frac*math.pi),
    y = y + size*math.sin(math.pi*0.8+1.4*frac*math.pi)
  }

  -- Line drawing parameters
  local cX = (point1.x + point2.x) / 2
  local cY = (point1.y + point2.y) / 2
  local W = size/10

  -- Line length and angle
  local L = math.sqrt((point1.x-point2.x)^2+(point1.y-point2.y)^2) + 1e-7
  local dX = (point2.x-point1.x) / L
  local dY = (point2.y-point1.y) / L
  local A = math.atan2(dY,dX)
  local dA = math.atan2(W,L/2)

  -- Generate vertexes
  local vertexBuffer = { {}, {}, {}, {} }

  vertexBuffer[1].x = cX - 0.5 * L * math.cos(A-dA)
  vertexBuffer[1].y = cY - 0.5 * L * math.sin(A-dA)
  vertexBuffer[1].u = 0
  vertexBuffer[1].v = 0

  vertexBuffer[2].x = cX + 0.5 * L * math.cos(A+0.25*dA)
  vertexBuffer[2].y = cY + 0.5 * L * math.sin(A+0.25*dA)
  vertexBuffer[2].u = 1
  vertexBuffer[2].v = 1

  vertexBuffer[3].x = cX + 0.5 * L * math.cos(A-0.25*dA)
  vertexBuffer[3].y = cY + 0.5 * L * math.sin(A-0.25*dA)
  vertexBuffer[3].u = 0
  vertexBuffer[3].v = 1

  vertexBuffer[4].x = cX - 0.5 * L * math.cos(A+dA)
  vertexBuffer[4].y = cY - 0.5 * L * math.sin(A+dA)
  vertexBuffer[4].u = 1
  vertexBuffer[4].v = 0

  -- Draw vertexes
  surface.DrawPoly(vertexBuffer)
end

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
function ENT:Draw()
  local dT = CurTime() - (self.PrevTime or CurTime())
  self.PrevTime = CurTime()
      
  -- Draw model
  self:DrawModel()
  
  
  
  
  -- UI info
  local speed =   self:GetNWFloat("Speed",0)
  local mode =    self:GetNWFloat("Mode",0)
  local reverse = self:GetNWBool("Reverse",false)
  local ldoor =   self:GetNWBool("LeftDoor",false)
  local rdoor =   self:GetNWBool("RightDoor",false)
  local clight =  self:GetNWBool("CockpitLight",false)
  local ilight =  self:GetNWBool("InteriorLight",false)
  local tswitch = self:GetNWBool("AlternateTrack",false)
  local sswitch = self:GetNWBool("SelectAlternateTrack",false)
  local tblock =  self:GetNWBool("TrackSwitchBlocked",false)
  local nexty =   self:GetNWBool("NextLightYellow",false)
  local nextr =   self:GetNWBool("NextLightRed",false)
  local arsv =    self:GetNWFloat("ARSSpeed",-1)
  self.Mode = mode
  
  -- General panel
  local pos = self:LocalToWorld(Vector(-455,-10,7))
  local ang = self:LocalToWorldAngles(Angle(0,90,40))
  
  cam.Start3D2D(pos, ang, 0.0625)
--    surface.SetDrawColor(0, 0, 0, 255)
--    surface.DrawRect(0, 0, 460, 192)

    -- Draw general indications
    self:DrawIndicator("Reverse", 20,24+20*0,reverse,Color(255,255,0,255))
    self:DrawIndicator("",  20+108*0,24+20*1,ldoor, Color(0,100,255,255))
    self:DrawIndicator("",  20+108*1,24+20*1,rdoor, Color(0,100,255,255))
    draw.DrawText("L Doors R","Subway81717_Indicator",40,20+20*1,Color(0,0,0,255))

    self:DrawIndicator("ARS Error",       20,24+20*2,arsv < 0,Color(255,0,0,255))
    if ((CurTime() % 0.5) > 0.25) and (arsv >= 0) then
      self:DrawIndicator("Overspeed",       20,24+20*3,speed > (arsv+5),Color(255,0,0,255))
    else
      self:DrawIndicator("Overspeed",       20,24+20*3,false,Color(255,0,0,255))
    end
    self:DrawIndicator("Head Lights",    220,24+20*0,clight,Color(255,255,255,255))
    self:DrawIndicator("Interior Lights", 220,24+20*1,ilight,Color(255,255,255,255))
    
    self:DrawIndicator("Track Switch", 220,24+20*3,tswitch or ((sswitch == true) and ((CurTime() % 0.5) > 0.25)),Color(0,255,0,255))
    self:DrawIndicator("", 220-16,24+20*3,tblock,Color(255,0,0,255))

  cam.End3D2D()
  
  
  
  -- Main panel
  pos = self:LocalToWorld(Vector(-455,-27,15))
  ang = self:LocalToWorldAngles(Angle(0,90,60))
  
  cam.Start3D2D(pos, ang, 0.0625)
--    surface.SetDrawColor(0, 0, 0, 255)
--    surface.DrawRect(0, 0, 860, 288)

    -- Draw spedometer
    local speed = string.format("%02.0f",math.min(speed,99))
    self.SmoothSpeed = self.SmoothSpeed or 0
    self.SmoothSpeed = self.SmoothSpeed + 4*dT*(speed - self.SmoothSpeed)
    if self.SmoothSpeed < 0 then self.SmoothSpeed = 0 end
    if self.SmoothSpeed > 100 then self.SmoothSpeed = 100 end
    speed = self.SmoothSpeed
    
    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawRect(440, 10, 70, 50)
    if mode > 0 then
      local digits = { math.floor(speed / 10), math.floor(speed % 10) }
--      local doffset = { 0, 0 }
--      if digits[1] == 1 then doffset[1] = 15 end
--      if digits[2] == 1 then doffset[2] = 15 end
      
      self:DrawDigit(453+24*0,13,digits[1])
      self:DrawDigit(453+24*1,13,digits[2])
--      draw.DrawText(digits[1],"Subway81717_LCDGlow",453+22*0+doffset[1],12,Color(100,255,0,100))
--      draw.DrawText(digits[2],"Subway81717_LCDGlow",453+22*1+doffset[2],12,Color(100,255,0,100))
      
--      draw.DrawText(digits[1],"Subway81717_LCD",453+22*0+doffset[1],12,Color(100,255,0,255))
--      draw.DrawText(digits[2],"Subway81717_LCD",453+22*1+doffset[2],12,Color(100,255,0,255))
    end
    draw.DrawText("KM/H","Subway81717_LargeText",438,60,Color(10,10,10,255))
    
    
    -- Draw ARS
    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawRect(290, 8+16*0, 40, 14)
    surface.DrawRect(290, 8+16*1, 40, 14)
    surface.DrawRect(290, 8+16*2, 40, 14)
    surface.DrawRect(290, 8+16*3, 40, 14)
    surface.DrawRect(290, 8+16*4, 40, 14)
    if mode > 0 then
      surface.SetDrawColor(255, 0, 0, 200)
      if arsv < 0 then
        surface.DrawRect(290, 8+16*0, 40, 14)
      end
      if (arsv >= 0) and (arsv <= 20) then
        surface.DrawRect(290, 8+16*1, 40, 14)
      end
      surface.SetDrawColor(255, 255, 0, 200)
      if (arsv > 20) and (arsv <= 50) then
        surface.DrawRect(290, 8+16*2, 40, 14)
      end
      surface.SetDrawColor(0, 255, 0, 200)
      if (arsv > 50) and (arsv <= 65) then
        surface.DrawRect(290, 8+16*3, 40, 14)
      end
      if (arsv > 65) then
        surface.DrawRect(290, 8+16*4, 40, 14)
      end
    end
    draw.DrawText("ERR","Subway81717_ARS",    310,8+16*0,Color(0,0,0,255),TEXT_ALIGN_CENTER)
    draw.DrawText("0","Subway81717_ARS",      310,8+16*1,Color(0,0,0,255),TEXT_ALIGN_CENTER)
    draw.DrawText("40","Subway81717_ARS",     310,8+16*2,Color(0,0,0,255),TEXT_ALIGN_CENTER)
    draw.DrawText("60","Subway81717_ARS",     310,8+16*3,Color(0,0,0,255),TEXT_ALIGN_CENTER)
    draw.DrawText("70 80","Subway81717_ARS",  310,8+16*4,Color(0,0,0,255),TEXT_ALIGN_CENTER)
    

    self:DrawIndicator("Restrict", 750,24+20*8,nexty,Color(255,255,0,255))
    self:DrawIndicator("", 750-16,24+20*8,nextr,Color(255,0,0,255))
    
    draw.DrawText(Format("TRAIN #%02d",self:GetNWFloat("TrainID",1)),"Subway81717_Indicator",16,265,Color(0,0,0,255))	
    
    
    -- Draw pressure indicators
--[[    self.TotalPressure = self.TotalPressure or 0
    if mode > 0 then
      self.TotalPressure = self.TotalPressure + 0.5*(1.0 - self.TotalPressure)*dT
    else
      self.TotalPressure = self.TotalPressure + 0.5*(0.0 - self.TotalPressure)*dT
    end
    self.BrakePressure = self.BrakePressure or 0
    if mode == 1 then
      self.BrakePressure = self.BrakePressure + (1.0 - self.BrakePressure)*dT
    elseif mode == 2 then
      self.BrakePressure = self.BrakePressure + (0.5 - self.BrakePressure)*dT
    else
      self.BrakePressure = self.BrakePressure + (0.0 - self.BrakePressure)*dT
    end
      
    surface.SetTexture(0)
    if mode > 0 then
      surface.SetDrawColor(150,150,150,255)
    else
      surface.SetDrawColor(0,0,0,255)
    end
    self:DrawCircle(580,48,24)
    self:DrawCircle(580+74,48,24)
    if mode > 0 then
      surface.SetDrawColor(210,20,20,255)
      self:DrawArrow(self.TotalPressure*0.7,0,1, 580,48, 22)
      surface.SetDrawColor(20,20,240,255)
      self:DrawArrow(self.TotalPressure*0.5,0,1, 580,48, 22)
      surface.SetDrawColor(0,0,0,255)
      self:DrawArrow(self.BrakePressure,0,1, 580+74,48, 22)
    end
    surface.SetDrawColor(0,0,0,255)
    self:DrawCircle(580,48,4)
    self:DrawCircle(580+74,48,4)]]--
    

    -- Draw control indications
--[[    self:DrawIndicator(" 90 KM/H",    730,16+15*0,(mode == 9),Color(0,255,0,255))
    self:DrawIndicator(" 60 KM/H",    730,16+15*1,(mode == 8),Color(0,255,0,255))
    self:DrawIndicator(" 40 KM/H",    730,16+15*2,(mode == 7),Color(0,255,0,255))
    self:DrawIndicator(" 20 KM/H",    730,16+15*3,(mode == 6),Color(0,255,0,255))
    self:DrawIndicator("       ",     730,16+15*4,(mode == 5),Color(0,255,0,255))
    self:DrawIndicator("E.Brk   50%", 730,16+15*5,(mode == 4),Color(255,255,0,255))
    self:DrawIndicator("E.Brk 100%",  730,16+15*6,(mode == 3),Color(255,255,0,255))
    self:DrawIndicator("Pneumatic",   730,16+15*7,(mode == 2),Color(255,255,0,255))
    self:DrawIndicator("Emergency",   730,16+15*8,(mode == 1),Color(255,0,0,255))]]--
    self:DrawIndicator("X3",          730,16+15*0,(mode == 9),Color(0,255,0,255))
    self:DrawIndicator("X2",          730,16+15*1,(mode == 8),Color(0,255,0,255))
    self:DrawIndicator("X1",          730,16+15*2,(mode == 7),Color(0,255,0,255))
    self:DrawIndicator(" ",           730,16+15*3,(mode == 6),Color(0,255,0,255))
    self:DrawIndicator("T1",          730,16+15*4,(mode == 5),Color(255,255,0,255))
    self:DrawIndicator("T1A",         730,16+15*5,(mode == 4),Color(255,255,0,255))
    self:DrawIndicator("T2",          730,16+15*6,(mode == 3),Color(255,255,0,255))
    self:DrawIndicator("Pneumatic",   730,16+15*7,(mode == 2),Color(255,255,0,255))
    self:DrawIndicator("Emergency",   730,16+15*8,(mode == 1),Color(255,0,0,255))
    
    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawRect(720, 16+15*0, 4, 3*15-4)
    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawRect(720, 16+15*4, 4, 4*15-4)
    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawRect(720, 16+15*8, 4, 1*15-4)
    if mode > 0 then
      surface.SetDrawColor(0, 255, 0, 120)
      surface.DrawRect(720, 16+15*0, 4, 3*15-4)
      surface.SetDrawColor(255, 255, 0, 120)
      surface.DrawRect(720, 16+15*4, 4, 4*15-4)
      surface.SetDrawColor(255, 0, 0, 120)
      surface.DrawRect(720, 16+15*8, 4, 1*15-4)
    end

  cam.End3D2D()

	if GetConVarNumber("metrostroi_drawdebug") > 0 then
		for kp,panel in pairs(self.ButtonMap) do
			cam.Start3D2D(self:LocalToWorld(panel.pos),self:LocalToWorldAngles(panel.ang),panel.scale)
			surface.SetDrawColor(255,255,0)
			
			for kb,button in pairs(panel.buttons) do
				self:DrawCircle(button[1],button[2],button[3] or 10)
			end
			
			cam.End3D2D()
		end
	end
  
  
  -- Front of the train
  if (mode > 0) then
    if reverse then
      pos = self:LocalToWorld(Vector(-460,45,60.5))
      ang = self:LocalToWorldAngles(Angle(180,90,90))
  
      cam.Start3D2D(pos, ang, 0.25)
        surface.SetDrawColor(255,0,0,200)
        self:DrawCircle(0,10,12)
        self:DrawCircle(2*45*4,10,12)
      cam.End3D2D()
    end
    if clight then
       pos = self:LocalToWorld(Vector(-461.8,45,60.5))
      ang = self:LocalToWorldAngles(Angle(180,90,90))

      cam.Start3D2D(pos, ang, 0.25)
        surface.SetDrawColor(255,255,255,200)
        self:DrawCircle(-21,-294,16)
        self:DrawCircle(2*45*4+21,-294,16)
        
        self:DrawCircle(-21+44,-294,16)
        self:DrawCircle(2*45*4+21-44,-294,16)
      cam.End3D2D()
    end
  end
end



concommand.Add("train_show_manual", function(ply, _, args)
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



hook.Add("CalcView", "Metrostroi_ThirdPersonMirrorView", function(ply,pos,ang,fov,nearz,farz)
  local seat = ply:GetVehicle()
  if (not seat) or (not seat:IsValid()) then return end
  local train = seat:GetNWEntity("TrainEntity")
  if (not train) or (not train:IsValid()) then return end
  
  if seat:GetThirdPersonMode() then
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
  end
end)

//Thanks old gmod wiki!
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

//Calculates line-plane intersect location
local function LinePlaneIntersect(PlanePos,PlaneNormal,LinePos,LineDir)
	local dot = LineDir:Dot(PlaneNormal)
	local fac = LinePos-PlanePos 
	local dis = -PlaneNormal:Dot(fac) / dot
	return LineDir * dis + LinePos
end


//Checks if the player is driving a train, also returns said train
local function isValidTrainDriver(ply)
	local seat = ply:GetVehicle()
	if (not seat) or (not seat:IsValid()) then return false end
	local train = seat:GetNWEntity("TrainEntity")
	if (not train) or (not train:IsValid()) then return false end
	return train
end

hook.Add("Think","metrostroi-cabin-panel",function()
	if !IsValid(LocalPlayer()) then return end
	local train = isValidTrainDriver(LocalPlayer())
	if(IsValid(train)) then
		if(train.ButtonMap != nil) then
			local tr = LocalPlayer():GetEyeTrace()
			for k2,panel in pairs(train.ButtonMap) do
				local wpos = train:LocalToWorld(panel.pos)
				local wang = train:LocalToWorldAngles(panel.ang)
				
				local isectPos = LinePlaneIntersect(wpos,wang:Up(),tr.StartPos,tr.Normal)
				local localx,localy = WorldToScreen(isectPos,wpos,panel.scale,wang)
				
				panel.aimX = localx
				panel.aimY = localy
				panel.aimedAt = (localx > 0 and localx < panel.width and localy > 0 and localy < panel.height)
			end
			LocalPlayer().drawCabinCrosshair = false
			for kp,panel in pairs(train.ButtonMap) do
				if panel.aimedAt then 
					LocalPlayer().drawCabinCrosshair = true
					break
				end
			end
		end
	else
		LocalPlayer().drawCabinCrosshair = false
	end
end)


hook.Add("KeyPress", "metrostroi-cabin-buttons", function(ply, key)
	if !IsFirstTimePredicted() then return end
	if not(key==IN_ATTACK or key==IN_ATTACK2) then return end 
	//Filter out the most common thing the quickest
	
	local train = isValidTrainDriver(ply)
	if !IsValid(train) then return end
	if train.ButtonMap == nil then return end
	for kp,panel in pairs(train.ButtonMap) do
		if panel.aimedAt then
			for kb,button in pairs(panel.buttons) do
				if math.Dist(button[1],button[2],panel.aimX,panel.aimY) < (button[3] or 10) then
					net.Start("metrostroi-cabin-button")
					net.WriteInt(kp,8) //Panel
					net.WriteInt(kb,8) //Button
					
					//print(panel,button,key)
					
					//Key
					if(key==IN_ATTACK) then
						net.WriteInt(1,8)
					elseif (key==IN_ATTACK2) then
						net.WriteInt(2,8)
					else
						net.WriteInt(0,8)
					end
					
					net.SendToServer()
				end
			end
		end
	end
end)

hook.Add( "HUDPaint", "metrostroi-draw-custom-crosshair", function()
	if IsValid(LocalPlayer()) then
		if LocalPlayer().drawCabinCrosshair then
			surface.DrawCircle(surface.ScreenWidth()/2,surface.ScreenHeight()/2,4.1,Color(255,255,150))
		end
	end
end)