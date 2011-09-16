--------------------------------------------------------------------------------
--  Credit to Dajova
--------------------------------------------------------------------------------
local T, C, L = unpack(select(2, ...)) -- Import Functions/Constants/Variables, Config, Locales

if not C["combo"].display == true then return end
--------------------------------------------------------------------------------
--  Class Combo Points
--------------------------------------------------------------------------------
local font, fsize, fflag = C["media"].dmgfont, 35, "OUTLINE"

Combo = CreateFrame("Frame", "CCP")
local count = Combo:CreateFontString(nil, "OVERLAY")
count:SetFont(font, fsize, fflag)

local onEvent = function(self, event, ...)
	self[event](self, event, ...)
end

function Combo:Colorize(points) 
	if(points==1)then return .5,.7,1,1 end
	if(points==2)then return 0,1,0,1 end
	if(points==3)then return 1,1,0,1 end
	if(points==4)then return 1,.5,.2,1 end
	if(points==5)then return 1,0,0,1 end
	if(points==6)then return 1,0,1,1 end
	return 1, 1, 1, 1
end

function Combo:UpdateComboPoints()
	if not UnitIsDead("target") then
		local points = GetComboPoints(UnitHasVehicleUI("player") and "vehicle" or "player", "target")
		count:SetText(points > 0 and points or "")
		count:SetVertexColor(Combo:Colorize(points))
	end
end

function Combo:PLAYER_ENTERING_WORLD(event)

	-- change position depending on layout
	if IsAddOnLoaded("Tukui_Dps") then 
		self:SetPoint("CENTER",UIParent,"CENTER",0,T.Scale(-150))
	elseif IsAddOnLoaded("Tukui_Heal") then
		self:SetPoint("CENTER",UIParent,"CENTER",0,T.Scale(-80))
	else
		self:SetPoint("CENTER",UIParent,"CENTER",0,T.Scale(-100))
	end
	
	count:SetAllPoints(Combo)
	count:SetShadowColor(0,0,0,.8)
	count:SetShadowOffset(2.5,-2.5)
end

function Combo:PLAYER_TARGET_CHANGED(event)
	self:UpdateComboPoints()
end

function Combo:UNIT_COMBO_POINTS(event, unit)
	if unit == "player" or unit == "vehicle" or unit == "target" then
		self:UpdateComboPoints()
	end
end

function Combo:UNIT_EXITED_VEHICLE(event, unit)
	if unit == "player" then
		self:UpdateComboPoints()
	end
end

Combo:SetWidth(fsize*2)
Combo:SetHeight(fsize*2)
Combo:SetScript("OnEvent", onEvent)
Combo:RegisterEvent("PLAYER_ENTERING_WORLD")
Combo:RegisterEvent("PLAYER_TARGET_CHANGED")
Combo:RegisterEvent("UNIT_COMBO_POINTS")
Combo:RegisterEvent("UNIT_EXITED_VEHICLE")

-- Hide Blizzards's Combo Frame
ComboFrame:UnregisterEvent("PLAYER_TARGET_CHANGED")
ComboFrame:UnregisterEvent("UNIT_COMBO_POINTS")