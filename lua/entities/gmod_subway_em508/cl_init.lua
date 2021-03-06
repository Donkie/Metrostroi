﻿include("shared.lua")


--------------------------------------------------------------------------------
ENT.ClientProps = {}
ENT.ButtonMap = {}


-- Main panel
ENT.ButtonMap["Main"] = {
	pos = Vector(445.5,-35.3,-1.0),
	ang = Angle(0,-97.5,20),
	width = 410,
	height = 145,
	scale = 0.0625,
	
	buttons = {		
		{ID = "DIPonSet",		x=22,  y=19, radius=20, tooltip="Turn DIP and lights on"},
		{ID = "DIPoffSet",		x=66,  y=19, radius=20, tooltip="Turn DIP and lights off"},
		{ID = "VozvratRPSet",	x=192, y=80, radius=20, tooltip="Return overload relay"},
	}
}

-- Front panel
ENT.ButtonMap["Front"] = {
	pos = Vector(447.6,-35.3,5.0),
	ang = Angle(0,-97.4,74),
	width = 410,
	height = 95,
	scale = 0.0625,
	
	buttons = {
		{ID = "VUSToggle",		x=400, y=75, radius=15, tooltip="Ходовые фары (Head lights)"},
		--{ID = "CabinLightsToggle",		x=387, y=28, radius=15, tooltip=""},	
		{x=50,y=50,tooltip="Индикатор скорости (Speed indicator)",radius=35},
	}
}

-- ARS/Speedometer panel
ENT.ButtonMap["ARS"] = {
	pos = Vector(449.1,-37.3,4.9),
	ang = Angle(0,-97.9,69),
	width = 410*10,
	height = 95*10,
	scale = 0.0625/10,

	buttons = {
		{x=2045,y=406,tooltip="Индикатор скорости (Speed indicator)",radius=130},
		{x=2610,y=363,tooltip="Красная лампа реле перегрузки (РП) (Red overload relay light)",radius=120},
		{x=2982,y=363,tooltip="Красная лампа реле перегрузки (РП) (Red overload relay light)",radius=120},
		{x=1070+320*0,y=780,tooltip="Лампа хода реостатного контроллера ЛхРК (Rheostat controller motion light)",radius=120},
		{x=1070+320*1,y=780,tooltip="Контроль тормоза (ARS braking indicator)",radius=120},
		{x=1070+320*2,y=780,tooltip="Контроль выключения двигателей (ARS engine shutdown indicator)",radius=120},
		{x=1070+320*3,y=780,tooltip="Нулевое реле (Zero relay state)",radius=120},
		{x=1070+320*4,y=780,tooltip="",radius=120},
		{x=1070+320*5,y=780,tooltip="Индикатор работы печи (Cabin heating indicator)",radius=120},
		{x=1070+320*6,y=780,tooltip="",radius=120},
		
		{x=1070+380*0,y=570,tooltip="Отсутствие частоты АРС (No ARS frequency)",radius=120},
		{x=1070+380*1,y=570,tooltip="Сигнал АРС остановки (ARS stop signal)",radius=120},
		{x=1070+380*2,y=570,tooltip="Ограничение скорости 40 км/ч (speed limit 40 kph)",radius=120},
		{x=1070+380*3,y=570,tooltip="Ограничение скорости 60 км/ч (speed limit 60 kph)",radius=120},
		{x=1070+380*4,y=570,tooltip="Ограничение скорости 75 км/ч (speed limit 75 kph)",radius=120},
		{x=1070+380*5,y=570,tooltip="Ограничение скорости 80 км/ч (speed limit 80 kph)",radius=120},
		
		{x=1080+380*0,y=363,tooltip="Сигнализация дверей (Door state light)",radius=120},
		{x=1080+380*1,y=363,tooltip="Зелёная лампа реле перегрузки (РП) (Green overload relay light)",radius=120},
	}
}

-- AV panel
ENT.ButtonMap["AV"] = {
	pos = Vector(394.0,-53.5,44.5),
	ang = Angle(0,90,90),
	width = 520,
	height = 550,
	scale = 0.0625,
	
	buttons = {
		{ID = "A61Toggle", x=16+44*0,  y=110+129*0, radius=30, tooltip="A61 Train wire 6 control"},
		{ID = "A55Toggle", x=16+44*1,  y=110+129*0, radius=30, tooltip="A55 Train wire 10AS control"},
		{ID = "A54Toggle", x=16+44*2,  y=110+129*0, radius=30, tooltip="A54 Train wire 10AK control"},
		{ID = "A56Toggle", x=16+44*3,  y=110+129*0, radius=30, tooltip="A56"},
		{ID = "A27Toggle", x=16+44*4,  y=110+129*0, radius=30, tooltip="A27 Turn on DIP and lighting"},
		{ID = "A21Toggle", x=16+44*5,  y=110+129*0, radius=30, tooltip="A21 Door control"},
		{ID = "A10Toggle", x=16+44*6,  y=110+129*0, radius=30, tooltip="A10 Motor-compressor control"},
		{ID = "A53Toggle", x=16+44*7,  y=110+129*0, radius=30, tooltip="A53 KVC power supply"},
		{ID = "A43Toggle", x=16+44*8,  y=110+129*0, radius=30, tooltip="A43 ARS 12V power supply"},
		{ID = "A45Toggle", x=16+44*9,  y=110+129*0, radius=30, tooltip="A45 ARS train wire 10AU"},
		{ID = "A42Toggle", x=16+44*10, y=110+129*0, radius=30, tooltip="A42 ARS 75V power supply"},
		{ID = "A41Toggle", x=16+44*11, y=110+129*0, radius=30, tooltip="A41 ARS braking"},		
		------------------------------------------------------------------------
		{ID = "VUToggle",  x=16+44*0,  y=110+129*1, radius=30, tooltip="VU  Train control"},
		{ID = "A64Toggle", x=16+44*1,  y=110+129*1, radius=30, tooltip="A64 Cabin lighting"},
		{ID = "A63Toggle", x=16+44*2,  y=110+129*1, radius=30, tooltip="A63 IGLA/BIS"},
		{ID = "A50Toggle", x=16+44*3,  y=110+129*1, radius=30, tooltip="A50 Turn on DIP and lighting"},
		{ID = "A51Toggle", x=16+44*4,  y=110+129*1, radius=30, tooltip="A51 Turn off DIP and lighting"},
		{ID = "A23Toggle", x=16+44*5,  y=110+129*1, radius=30, tooltip="A23 Emergency motor-compressor turn on"},
		{ID = "A14Toggle", x=16+44*6,  y=110+129*1, radius=30, tooltip="A14 Train wire 18"},
		{ID = "A75Toggle", x=16+44*7,  y=110+129*1, radius=30, tooltip="A75 Cabin heating"},
		{ID = "A1Toggle",  x=16+44*8,  y=110+129*1, radius=30, tooltip="A1  XOD-1"},
		{ID = "A2Toggle",  x=16+44*9,  y=110+129*1, radius=30, tooltip="A2  XOD-2"},
		{ID = "A3Toggle",  x=16+44*10, y=110+129*1, radius=30, tooltip="A3  XOD-3"},
		{ID = "A17Toggle", x=16+44*11, y=110+129*1, radius=30, tooltip="A17 Reset overload relay"},
		------------------------------------------------------------------------
		{ID = "A62Toggle", x=16+44*0,  y=110+129*2, radius=30, tooltip="A62 Radio communications"},
		{ID = "A29Toggle", x=16+44*1,  y=110+129*2, radius=30, tooltip="A29 Radio broadcasting"},
		{ID = "A5Toggle",  x=16+44*2,  y=110+129*2, radius=30, tooltip="A5  "},
		{ID = "A6Toggle",  x=16+44*3,  y=110+129*2, radius=30, tooltip="A6  T-1"},
		{ID = "A8Toggle",  x=16+44*4,  y=110+129*2, radius=30, tooltip="A8  Pneumatic valves #1, #2"},
		{ID = "A20Toggle", x=16+44*5,  y=110+129*2, radius=30, tooltip="A20 Drive/brake circuit control, train wire 20"},
		{ID = "A25Toggle", x=16+44*6,  y=110+129*2, radius=30, tooltip="A25 Manual electric braking"},
		{ID = "A22Toggle", x=16+44*7,  y=110+129*2, radius=30, tooltip="A22 Turn on KK"},
		{ID = "A30Toggle", x=16+44*8,  y=110+129*2, radius=30, tooltip="A30 Rheostat controller motor power"},
		{ID = "A39Toggle", x=16+44*9,  y=110+129*2, radius=30, tooltip="A39 Emergency control"},
		{ID = "A44Toggle", x=16+44*10, y=110+129*2, radius=30, tooltip="A44 Emergency train control"},
		{ID = "A80Toggle", x=16+44*11, y=110+129*2, radius=30, tooltip="A80 Power circuit mode switch motor power"},
		------------------------------------------------------------------------
		{ID = "A65Toggle", x=16+44*0,  y=110+129*3, radius=30, tooltip="A65 Interior lighting"},
		--{ID = "A00Toggle", x=16+44*1,  y=110+129*3, radius=30, tooltip="A00"},
		{ID = "A24Toggle", x=16+44*2,  y=110+129*3, radius=30, tooltip="A24 Battery charging"},
		{ID = "A32Toggle", x=16+44*3,  y=110+129*3, radius=30, tooltip="A32 Open right doors"},
		{ID = "A31Toggle", x=16+44*4,  y=110+129*3, radius=30, tooltip="A31 Open left doors"},
		{ID = "A16Toggle", x=16+44*5,  y=110+129*3, radius=30, tooltip="A16 Close doors"},
		{ID = "A13Toggle", x=16+44*6,  y=110+129*3, radius=30, tooltip="A13 Door alarm"},
		{ID = "A12Toggle", x=16+44*7,  y=110+129*3, radius=30, tooltip="A12 Emergency door close"},
		{ID = "A7Toggle",  x=16+44*8,  y=110+129*3, radius=30, tooltip="A7  Red lamp"},
		{ID = "A9Toggle",  x=16+44*9,  y=110+129*3, radius=30, tooltip="A9  Red lamp"},
		{ID = "A46Toggle", x=16+44*10, y=110+129*3, radius=30, tooltip="A46 White lamp"},
		{ID = "A47Toggle", x=16+44*11, y=110+129*3, radius=30, tooltip="A47 White lamp"},
	}
}

-- Battery panel
ENT.ButtonMap["Battery"] = {
	pos = Vector(394.5,24.0-5,28.0+5),
	ang = Angle(0,90,90),
	width = 210+10/0.0625,
	height = 90+10/0.0625,
	scale = 0.0625,
	
	buttons = {
		{ID = "VBToggle", x=110+70*0, y=130, radius=120, tooltip="Battery on/off"},
		{ID = "VBToggle", x=110+70*1, y=130, radius=120, tooltip="Battery on/off"},
		{ID = "VBToggle", x=110+70*2, y=130, radius=120, tooltip="Battery on/off"},
	}
}

-- Help panel
ENT.ButtonMap["Help"] = {
	pos = Vector(445.0,-36.0,30.0),
	ang = Angle(40+180,0,0),
	width = 20,
	height = 20,
	scale = 1,
	
	buttons = {
		{ID = "ShowHelp", x=10, y=10, radius=15, tooltip="Show help on driving the train"},
	}
}

-- Pneumatic instrument panel
ENT.ButtonMap["PneumaticPanels"] = {
	pos = Vector(448,-30,16.0),
	ang = Angle(0,-77,90),
	width = 140,
	height = 160,
	scale = 0.0625,
	
	buttons = {
		{x=60,y=45,tooltip="Brake cylinder pressure",radius=30},
		{x=80,y=105,tooltip="Red: brake line pressure, black: train line pressure",radius=30},
	}
}
ENT.ButtonMap["DriverValveDisconnect"] = {
	pos = Vector(420,-57.0,-25),
	ang = Angle(0,0,0),
	width = 200,
	height = 90,
	scale = 0.0625,
	
	buttons = {
		{ID = "DriverValveDisconnectToggle", x=50, y=45, radius=50, tooltip="Driver valve disconnect valve"},
		{ID = "DriverValveDisconnectToggle", x=100, y=45, radius=50, tooltip="Driver valve disconnect valve"},
		{ID = "DriverValveDisconnectToggle", x=150, y=45, radius=50, tooltip="Driver valve disconnect valve"},
	}
}


-- Temporary panels (possibly temporary)
ENT.ButtonMap["FrontPneumatic"] = {
	pos = Vector(459.0,-45.0,-50.0),
	ang = Angle(0,90,90),
	width = 900,
	height = 100,
	scale = 0.1,
}
ENT.ButtonMap["RearPneumatic"] = {
	pos = Vector(-481.0,45.0,-50.0),
	ang = Angle(0,270,90),
	width = 900,
	height = 100,
	scale = 0.1,
}




--------------------------------------------------------------------------------
ENT.ClientPropsInitialized = false
ENT.ClientProps["brake"] = {
	model = "models/metrostroi/81-717/brake.mdl",
	pos = Vector(431,-59.5,2.7),
	ang = Angle(0,180,0)
}
ENT.ClientProps["controller"] = {
	model = "models/metrostroi/81-717/controller.mdl",
	pos = Vector(446,-25,2.0),
	ang = Angle(0,-45,90)
}
ENT.ClientProps["reverser"] = {
	model = "models/metrostroi/81-717/reverser.mdl",
	pos = Vector(446,-25,1.2),
	ang = Angle(0,45,90)
}
ENT.ClientProps["brake_disconnect"] = {
	model = "models/metrostroi/81-717/uava.mdl",
	pos = Vector(429.5,-61.0,-25),
	ang = Angle(-30,0,0)
}


ENT.ClientProps["train_line"] = {
	model = "models/metrostroi/81-717/black_arrow.mdl",
	pos = Vector(449.20,-35.00,9.45),
	ang = Angle(90,0,180-14)
}
ENT.ClientProps["brake_line"] = {
	model = "models/metrostroi/81-717/red_arrow.mdl",
	pos = Vector(449.15,-35.05,9.45),
	ang = Angle(90,0,180-14)
}
ENT.ClientProps["brake_cylinder"] = {
	model = "models/metrostroi/81-717/black_arrow.mdl",
	pos = Vector(450.5,-32.9,13.4),
	ang = Angle(90,0,180-18)
}


ENT.ClientProps["ampermeter"] = {
	model = "models/metrostroi/81-717/black_arrow.mdl",
	pos = Vector(445.5,-59.5,23.3),
	ang = Angle(90,0,-45+180+80)
}
ENT.ClientProps["voltmeter"] = {
	model = "models/metrostroi/81-717/black_arrow.mdl",
	pos = Vector(448.1,-55.7,23.3),
	ang = Angle(90,0,-45+180+80)
}
ENT.ClientProps["speedometer"] = {
	model = "models/metrostroi/81-717/black_arrow.mdl",
	pos = Vector(447.10,-38.15,0.4),
	ang = Angle(90-18,180,7)
}
ENT.ClientProps["volt1"] = {
	model = "models/metrostroi/81-717/black_arrow.mdl",
	pos = Vector(452.3,-19.4,18.2),
	ang = Angle(90,0,180)
}


ENT.ClientProps["headlights"] = {
	model = "models/metrostroi/81-717/switch04.mdl",
	pos = Vector(443.1,-60.0,0.5),
	ang = Angle(-90,0,0)
}
ENT.ClientProps["panellights"] = {
	model = "models/metrostroi/81-717/switch04.mdl",
	pos = Vector(444.1,-59.3,3.3),
	ang = Angle(-90,0,0)
}
ENT.ClientProps["dip_on"] = {
	model = "models/metrostroi/81-717/button07.mdl",
	pos = Vector(444.3,-36.4,-1.3),
	ang = Angle(-20,0,0)
}
ENT.ClientProps["dip_off"] = {
	model = "models/metrostroi/81-717/button10.mdl",
	pos = Vector(443.9,-39.2,-1.3),
	ang = Angle(-20,0,0)
}
ENT.ClientProps["rp_vozvrat"] = {
	model = "models/metrostroi/81-717/button07.mdl",
	pos = Vector(439.3,-46.6,-2.6),
	ang = Angle(-20,0,0)
}


ENT.ClientProps["gv"] = {
	model = "models/metrostroi/81-717/gv.mdl",
	pos = Vector(154,62.5,-65),
	ang = Angle(180,0,-90)
}
ENT.ClientProps["gv_wrench"] = {
	model = "models/metrostroi/81-717/reverser.mdl",
	pos = Vector(154,62.5,-65),
	ang = Angle(-50,0,0)
}

for x=0,11 do
	for y=0,3 do
		ENT.ClientProps["a"..(x+12*y)] = {
			model = "models/metrostroi/81-717/circuit_breaker.mdl",
			pos = Vector(393.8,-52.5+x*2.75,37.5-y*8),
			ang = Angle(90,0,0)
		}
	end
end
ENT.ClientProps["bat1"] = {
	model = "models/metrostroi/81-717/switch01.mdl",
	pos = Vector(393.6,26.0+4.6*0,24.9),
	ang = Angle(90,0,0)
}
ENT.ClientProps["bat2"] = {
	model = "models/metrostroi/81-717/switch01.mdl",
	pos = Vector(393.6,26.0+4.6*1,24.9),
	ang = Angle(90,0,0)
}
ENT.ClientProps["bat3"] = {
	model = "models/metrostroi/81-717/switch01.mdl",
	pos = Vector(393.6,26.0+4.6*2,24.9),
	ang = Angle(90,0,0)
}




ENT.ClientProps["book"] = {
	model = "models/props_lab/binderredlabel.mdl",
	pos = Vector(449.0,-40.0,45.0),
	ang = Angle(-135,0,85)
}




--------------------------------------------------------------------------------
-- Add doors
for i=0,3 do
	for k=0,1 do
		table.insert(ENT.ClientProps,{
			model = "models/metrostroi/e/em508_door1.mdl",
			pos = Vector(353.0 - 35*k - 231*i,-65*(1-2*k),-1.8),
			ang = Angle(0,180*k,0)
		})
		table.insert(ENT.ClientProps,{
			model = "models/metrostroi/e/em508_door2.mdl",
			pos = Vector(353.0 - 35*(1-k) - 231*i,-65*(1-2*k),-1.8),
			ang = Angle(0,180*k,0)
		})
	end
end
table.insert(ENT.ClientProps,{
	model = "models/metrostroi/e/em508_door5.mdl",
	pos = Vector(456.5,0.4,-3.8),
	ang = Angle(0,0,0)
})
table.insert(ENT.ClientProps,{
	model = "models/metrostroi/e/em508_door5.mdl",
	pos = Vector(-479.5,-0.5,-3.8),
	ang = Angle(0,180,0)
})
table.insert(ENT.ClientProps,{
	model = "models/metrostroi/e/em508_door4.mdl",
	pos = Vector(386.5,0.4,5.2),
	ang = Angle(0,0,0)
})
table.insert(ENT.ClientProps,{
	model = "models/metrostroi/e/em508_door3.mdl",
	pos = Vector(425.6,65.2,-2.2),
	ang = Angle(0,0,0)
})




--------------------------------------------------------------------------------
function ENT:Think()
	self.BaseClass.Think(self)
	if CurTime() - (self.ASD or 0) > 10 then
		self.ASD = CurTime()
		self:RemoveCSEnts()
		self:CreateCSEnts()
	end
	
	-- Simulate pressure gauges getting stuck a little
	self:Animate("brake", 			self:GetPackedRatio(0)^0.5, 		0.00, 0.65,  256,24)
	self:Animate("controller",		self:GetPackedRatio(1),				0.30, 0.70,  384,24)
	self:Animate("reverser",		self:GetPackedRatio(2),				0.20, 0.55,  4,false)
	self:Animate("speedometer", 	self:GetPackedRatio(3),				0.38,0.64)
	self:ShowHide("reverser",		self:GetPackedBool(0))

	self:Animate("brake_line",		self:GetPackedRatio(4),				0.16, 0.84,  256,2,0.01)
	self:Animate("train_line",		self:GetPackedRatio(5),				0.16, 0.84,  256,2,0.01)
	self:Animate("brake_cylinder",	self:GetPackedRatio(6),	 			0.17, 0.86,  256,2,0.03)
	self:Animate("voltmeter",		self:GetPackedRatio(7),				0.38, 0.63)
	self:Animate("ampermeter",		self:GetPackedRatio(8),				0.38, 0.63)
	self:Animate("volt1",			self:GetPackedRatio(10), 			0.38, 0.63)
	
	self:Animate("headlights",		self:GetPackedBool(1) and 1 or 0, 	0,1, 8, false)
	self:Animate("rp_vozvrat",		self:GetPackedBool(2) and 1 or 0, 	0,1, 16, false)
	self:Animate("dip_on",			self:GetPackedBool(3) and 1 or 0, 	0,1, 16, false)
	self:Animate("dip_off",			self:GetPackedBool(4) and 1 or 0, 	0,1, 16, false)	
	self:Animate("brake_disconnect",self:GetPackedBool(6) and 1 or 0, 	0,0.7, 3, false)	
	self:Animate("bat1",			self:GetPackedBool(7) and 1 or 0, 	0,1, 16, false)
	self:Animate("bat2",			self:GetPackedBool(7) and 1 or 0, 	0,1, 16, false)
	self:Animate("bat3",			self:GetPackedBool(7) and 1 or 0, 	0,1, 16, false)
	
	
	-- Main switch
	if self.LastValue ~= self:GetPackedBool(5) then
		self.ResetTime = CurTime()+2.0
		self.LastValue = self:GetPackedBool(5)
	end	
	self:Animate("gv_wrench",	1-(self:GetPackedBool(5) and 1 or 0), 	0,0.35, 32,  4,false)
	self:ShowHide("gv_wrench",	CurTime() < self.ResetTime)
	
	
	-- Brake-related sounds
	local brakeLinedPdT = self:GetPackedRatio(9)
	if brakeLinedPdT > -0.001 
	then self:SetSoundState("release2",0,0)
	else self:SetSoundState("release2",-1.0*brakeLinedPdT,1.0)
	end
	
	
	-- Animate AV switches
	for i,v in ipairs(self.Panel.AVMap) do
		local value = self:GetPackedBool(64+(i-1)) and 1 or 0
		self:Animate("a"..(i-1),value,0,1,8,false)
	end
	
	
	-- DIP sound
	--self:SetSoundState("bpsn2",self:GetPackedBool(32) and 1 or 0,1.0)
end

surface.CreateFont("MetrostroiSubway_LargeText", {
  font = "Arial",
  size = 100,
  weight = 500,
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
surface.CreateFont("MetrostroiSubway_SmallText", {
  font = "Arial",
  size = 70,
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

function ENT:Draw()
	self.BaseClass.Draw(self)
	self:DrawOnPanel("ARS",function()
		if not self:GetPackedBool(32) then return end
	
		local speed = self:GetPackedRatio(3)*100.0
		local d1 = math.floor(speed) % 10
		local d2 = math.floor(speed / 10) % 10
		self:DrawDigit((196+0) *10,	35*10, d2, 0.75, 0.55)
		self:DrawDigit((196+10)*10,	35*10, d1, 0.75, 0.55)
		
		if self:GetPackedBool(35) then
			surface.SetDrawColor(255,50,0)
			surface.DrawRect(253*10,33*10,16*10,7*10)
			draw.DrawText("РП","MetrostroiSubway_LargeText",253*10+30,33*10-19,Color(0,0,0,255))
			surface.SetDrawColor(255,50,0)
			surface.DrawRect(290*10,33*10,16*10,7*10)
			draw.DrawText("РП","MetrostroiSubway_LargeText",290*10+30,33*10-19,Color(0,0,0,255))
		end
		if self:GetPackedBool(36) then
			surface.SetDrawColor(50,255,50)
			surface.DrawRect(140*10,33*10,16*10,7*10)
			draw.DrawText("РП","MetrostroiSubway_LargeText",140*10+30,33*10-19,Color(0,0,0,255))
		end
		
		--[[if self:GetNWBool("LKT") then
			surface.SetDrawColor(50,255,50)
			surface.DrawRect(133*10,73*10,16*10,7*10)
			draw.DrawText("КТ","MetrostroiSubway_LargeText",133*10+30,73*10-20,Color(0,0,0,255))
		end			
		if self:GetNWBool("KVD") then
			surface.SetDrawColor(50,255,50)
			surface.DrawRect(165*10,73*10,16*10,7*10)
			draw.DrawText("КВД","MetrostroiSubway_LargeText",165*10,73*10-20,Color(0,0,0,255))
		end]]--	
		if self:GetPackedBool(33) then
			surface.SetDrawColor(255,50,0)
			surface.DrawRect(101*10,73*10,16*10,7*10)
		end
		if self:GetPackedBool(34) then
			surface.SetDrawColor(50,255,50)
			surface.DrawRect(196*10,73*10,16*10,7*10)
			draw.DrawText("НР1","MetrostroiSubway_LargeText",196*10,73*10-20,Color(0,0,0,255))
		end
		if self:GetPackedBool(37) then
			surface.SetDrawColor(255,50,0)
			surface.DrawRect(260*10,73*10,16*10,7*10)
			draw.DrawText("ПЕЧЬ","MetrostroiSubway_SmallText",260*10,73*10-5,Color(0,0,0,255))
		end
	end)
	
	self:DrawOnPanel("FrontPneumatic",function()
		draw.DrawText(self:GetNWBool("FI") and "Isolated" or "Open","Trebuchet24",150,30,Color(0,0,0,255))
	end)
	self:DrawOnPanel("RearPneumatic",function()
		draw.DrawText(self:GetNWBool("RI") and "Isolated" or "Open","Trebuchet24",150,30,Color(0,0,0,255))
	end)
end

function ENT:OnButtonPressed(button)
	if button == "ShowHelp" then
		RunConsoleCommand("train_show_manual")
	end
end