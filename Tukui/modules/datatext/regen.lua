local T, C, L = unpack(select(2, ...))
if not C["datatext"].regen and not C["datatext"].regen > 0 then return end

local regen

local Stat = CreateFrame("Frame", "TukuiStatRegen")
Stat:SetFrameStrata("BACKGROUND")
Stat:SetFrameLevel(3)
Stat.Option = C.datatext.regen

local Text = Stat:CreateFontString("TukuiStatRegenText", "OVERLAY")
Text:SetFont(unpack(T.Fonts.dFont.setfont))
Text:SetShadowColor(0, 0, 0)
Text:SetShadowOffset(1.25, -1.25)
T.PP(C["datatext"].regen, Text)

Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
Stat:RegisterEvent("PLAYER_REGEN_DISABLED")
Stat:RegisterEvent("PLAYER_REGEN_ENABLED")
Stat:RegisterEvent("UNIT_STATS")
Stat:RegisterEvent("UNIT_AURA")
Stat:SetScript("OnEvent", function(self)
	local base, casting = GetManaRegen()

	if InCombatLockdown() then
		regen = floor(casting*5)
	else
		regen = floor(base*5)		
	end
	
	Text:SetText(regen .. " " .. T.cStart .. MANA_REGEN_ABBR)
end)