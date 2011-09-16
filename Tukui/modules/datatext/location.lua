local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

if not C["datatext"].location == true then return end

-- Location panel from Eclipse edit
local TukuiLocationPanel = CreateFrame("Frame", "TukuiLocationPanel", UIParent)
TukuiLocationPanel:CreatePanel(TukuiLocationPanel, 54, 23, "TOP", UIParent, "TOP", 0, -8)
TukuiLocationPanel:CreateShadow("TukuiLocationPanel")

-- Coord panel from Eclipse edit
if C["datatext"].location_coords == true then
	local coords1 = CreateFrame("Frame", "TukuiXCoordsPanel", UIParent)
	TukuiXCoordsPanel:CreatePanel(coords1, 35, 23, "RIGHT", TukuiLocationPanel, "LEFT", -3, 0)
	TukuiXCoordsPanel:CreateShadow(coords1)
	coords1:SetFrameLevel(2)
	 
	local coords2 = CreateFrame("Frame", "TukuiYCoordsPanel", UIParent)
	TukuiYCoordsPanel:CreatePanel(coords2, 35, 23, "LEFT", TukuiLocationPanel, "RIGHT", 3, 0)
	TukuiYCoordsPanel:CreateShadow(coords2)
	coords2:SetFrameLevel(2)
end

local Text  = TukuiLocationPanel:CreateFontString(nil, "LOW")
Text:SetFont(unpack(T.Fonts.dFont.setfont))
Text:Point("CENTER", 1, 0)
local function OnEvent(self, event)
    local location = GetMinimapZoneText()
    local pvpType, isFFA, zonePVPStatus = GetZonePVPInfo()
    if (pvpType == "sanctuary") then
        location = "|cff69C9EF"..location.."|r" -- light blue
    elseif (pvpType == "friendly") then
        location = "|cff00ff00"..location.."|r" -- green
    elseif (pvpType == "contested") then
        location = "|cffffff00"..location.."|r" -- yellow
    elseif (pvpType == "hostile" or pvpType == "combat" or pvpType == "arena" or not pvpType) then
        location = "|cffff0000"..location.."|r" -- red
    else
        location = location -- white
    end
    Text:SetText(location)
    TukuiLocationPanel:SetWidth(Text:GetWidth() + 24)
end
TukuiLocationPanel:RegisterEvent("PLAYER_ENTERING_WORLD")
TukuiLocationPanel:RegisterEvent("ZONE_CHANGED_NEW_AREA")
TukuiLocationPanel:RegisterEvent("ZONE_CHANGED")
TukuiLocationPanel:RegisterEvent("ZONE_CHANGED_INDOORS")
TukuiLocationPanel:SetScript("OnEvent", OnEvent)

-- Credits to AlleyKatz!
if C["datatext"].location_coords == true then
	local Text2 = TukuiXCoordsPanel:CreateFontString(nil, "LOW")
	Text2:SetFont(unpack(T.Fonts.dFont.setfont))
	Text2:SetPoint("CENTER", T.Scale(1), 0)

	local Text3  = TukuiYCoordsPanel:CreateFontString(nil, "LOW")
	Text3:SetFont(unpack(T.Fonts.dFont.setfont))
	Text3:SetPoint("CENTER", T.Scale(1), 0)

	local ela,go = 0,false

	local cUpdate = function(self,t)
		ela = ela - t
		if ela > 0 then return end
		local x,y = GetPlayerMapPosition("player")
		local xt,yt
		x = math.floor(100 * x)
		y = math.floor(100 * y)
		if x == 0 and y == 0 then
			Text2:SetText("")
			Text3:SetText("")
			TukuiXCoordsPanel:SetAlpha(0)
			TukuiYCoordsPanel:SetAlpha(0)
		else
			if x < 10 then
				xt = "0"..x
			else
				xt = x
			end
			if y < 10 then
				yt = "0"..y
			else
				yt = y
			end
			Text2:SetText(xt)
			Text3:SetText(yt)
			TukuiXCoordsPanel:SetAlpha(1)
			TukuiYCoordsPanel:SetAlpha(1)
		end
		ela = .2
	end

	TukuiXCoordsPanel:SetScript("OnUpdate", cUpdate)
end

-- Coords line (left)
local topp = CreateFrame("Frame", "Tukuitopp", UIParent)
Tukuitopp:CreatePanel(topp, 1, 9, "BOTTOM", TukuiLocationPanel, "TOPLEFT", 8, 0)
Tukuitopp:CreateShadow(topp)
topp:SetFrameLevel(0)

-- Coords line (right)
local topp2 = CreateFrame("Frame", "Tukuitopp2", UIParent)
Tukuitopp2:CreatePanel(topp2, 1, 9, "BOTTOM", TukuiLocationPanel, "TOPRIGHT", -8, 0)
Tukuitopp2:CreateShadow(topp2)
topp2:SetFrameLevel(0)