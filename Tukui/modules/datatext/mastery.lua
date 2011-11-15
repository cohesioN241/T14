local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
--------------------------------------------------------------------
-- Mastery
----------------------------------------------------------------

if not C["datatext"].mastery == nil or C["datatext"].mastery > 0 then
	local Stat = CreateFrame("Frame", "TukuiStatMastery")
	Stat.Option = C.datatext.talent

	local Text  = TukuiInfoLeft:CreateFontString("TukuiStatMasteryText", "OVERLAY")
	Text:SetFont(unpack(T.Fonts.dFont.setfont))
	T.PP(C["datatext"].mastery, Text)

	local int = 1
	
	local function Update(self, t)
		int = int - t
		if int < 0 then
			Text:SetText(T.cStart .. "Mastery: " .. T.cEnd .. GetCombatRating(26))
			int = 1
		end
	end

	Stat:SetScript("OnUpdate", Update)
	Update(Stat, 10)
end