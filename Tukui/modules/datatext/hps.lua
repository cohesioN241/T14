local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
--------------------------------------------------------------------
-- SUPPORT FOR HPS Feed... 
--------------------------------------------------------------------

if C["datatext"].hps_text and C["datatext"].hps_text > 0 then
	local events = {SPELL_HEAL = true, SPELL_PERIODIC_HEAL = true}
	local HPS_FEED = CreateFrame("Frame", "TukuiStatHeal")
	HPS_FEED.Option = C.datatext.hps_text
	
	local player_id = UnitGUID("player")
	local actual_heals_total, cmbt_time = 0
	local amount_healed, amount_over_healed = 0
 
	local Text = HPS_FEED:CreateFontString("TukuiStatHealText", "OVERLAY")
	Text:SetFont(unpack(T.Fonts.dFont.setfont))
	Text:SetText("0.0 ", T.cStart .. L.datatext_hps)
 
	T.PP(C["datatext"].hps_text, Text)
 
	HPS_FEED:EnableMouse(true)
	HPS_FEED:SetFrameStrata("BACKGROUND")
	HPS_FEED:SetFrameLevel(3)
	HPS_FEED:Height(20)
	HPS_FEED:Width(100)
	HPS_FEED:SetAllPoints(Text)
 
	HPS_FEED:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
	HPS_FEED:RegisterEvent("PLAYER_LOGIN")
 
	local elapsed = 1
	HPS_FEED:SetScript("OnUpdate", function(self, elap)
		if UnitAffectingCombat("player") then
			HPS_FEED:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			cmbt_time = cmbt_time + elap
		else
			HPS_FEED:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		end
		
		elapsed = elapsed + elap
		if elapsed >= 1 then
			elapsed = 0
			hText:SetText(get_hps())
		end
	end)
 
	function HPS_FEED:PLAYER_LOGIN()
		HPS_FEED:RegisterEvent("PLAYER_REGEN_ENABLED")
		HPS_FEED:RegisterEvent("PLAYER_REGEN_DISABLED")
 
		player_id = UnitGUID("player")
     
		HPS_FEED:UnregisterEvent("PLAYER_LOGIN")
	end
 
	-- handler for the combat log. used http://www.wowwiki.com/API_COMBAT_LOG_EVENT for api
	function HPS_FEED:COMBAT_LOG_EVENT_UNFILTERED(...)         
		-- filter for events we only care about. i.e heals
		if not events[select(2, ...)] then return end
		if event == "PLAYER_REGEN_DISABLED" then return end

		-- only use events from the player
		local id = select(4, ...)
		if id == player_id then
			if T.toc < 40200 then
				amount_healed = select(13, ...)
				amount_over_healed = select(14, ...)
			else
				amount_healed = select(15, ...)
				amount_over_healed = select(16, ...)
			end
			-- add to the total the healed amount subtracting the overhealed amount
			actual_heals_total = actual_heals_total + math.max(0, amount_healed - amount_over_healed)
		end
	end
 
	function HPS_FEED:PLAYER_REGEN_ENABLED()
		Text:SetText(get_hps)
	end
   
	function HPS_FEED:PLAYER_REGEN_DISABLED()
		cmbt_time = 0
		actual_heals_total = 0
	end
     
	HPS_FEED:SetScript("OnMouseDown", function (self, button, down)
		cmbt_time = 0
		actual_heals_total = 0
	end)
 
	function get_hps()
		if (actual_heals_total == 0) then
			return ("0.0 " .. T.cStart .. L.datatext_hps)
		else
			return string.format("%.1f " .. T.cStart .. L.datatext_hps, (actual_heals_total or 0) / (cmbt_time or 1))
		end
	end

end