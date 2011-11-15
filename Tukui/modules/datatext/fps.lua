local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
--------------------------------------------------------------------
-- FPS
--------------------------------------------------------------------

if C["datatext"].fps_ms and C["datatext"].fps_ms > 0 then
	local Stat = CreateFrame("Frame", "TukuiStatFPS")
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)
	Stat:EnableMouse(true)
	Stat.Option = C.datatext.fps_ms
	
	local Text  = Stat:CreateFontString("TukuiStatFPSText", "OVERLAY")
	Text:SetFont(unpack(T.Fonts.dFont.setfont))
	T.PP(C["datatext"].fps_ms, Text)

	local int = 1
	local function Update(self, t)
		int = int - t
		if int < 0 then
			local fps = floor(GetFramerate()) --.. T.cStart .. L.datatext_fps .. T.cEnd
			local ms = select(3, GetNetStats()) --.. T.cStart .. L.datatext_ms .. T.cEnd
			
			local r1, g1, b1 = ColorGradient(fps/60, .9, .2, .2, .9, .9, .2, .2, .9, .2)
			local r2, g2, b2 = ColorGradient(ms/350, .2, .9, .2, .9, .9, .2, .9, .2, .2)
			Text:SetFormattedText('|cff%02x%02x%s%s|cff%02x%02x%s%s', r1*255, g1*255, b1*255, fps .. T.cStart .. L.datatext_fps .. T.cEnd, r2*255, g2*255, b2*255, ms .. T.cStart .. L.datatext_ms .. T.cEnd)
			
			self:SetAllPoints(Text)
			int = 1
		end	
	end
	Stat:SetScript("OnUpdate", Update)
	
	Stat:SetScript("OnEnter", function(self)
		if not InCombatLockdown() then
			local anchor, panel, xoff, yoff = T.DataTextTooltipAnchor(Text)
			local _, _, latencyHome, latencyWorld = GetNetStats()
			local latency = format(MAINMENUBAR_LATENCY_LABEL, latencyHome, latencyWorld)
			GameTooltip:SetOwner(panel, anchor, xoff, yoff)
			GameTooltip:ClearLines()
			GameTooltip:AddLine(latency)
			GameTooltip:Show()
		end
	end)  
	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end) 
	Update(Stat, 10)
end