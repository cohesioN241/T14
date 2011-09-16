local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
--------------------------------------------------------------------
-- DURABILITY
--------------------------------------------------------------------
	
if C["datatext"].dur and C["datatext"].dur > 0 then
	local Stat = CreateFrame("Frame")
	Stat:EnableMouse(true)
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)

	local Text  = TukuiInfoLeft:CreateFontString(nil, "OVERLAY")
	Text:SetFont(unpack(T.Fonts.dFont.setfont))
	T.PP(C["datatext"].dur, Text)

	local Total = 0
	local current, max

	local function OnEvent(self)
		for i = 1, 11 do
			if GetInventoryItemLink("player", L.Slots[i][1]) ~= nil then
				current, max = GetInventoryItemDurability(L.Slots[i][1])
				if current then 
					L.Slots[i][3] = current/max
					Total = Total + 1
				end
			end
		end
		table.sort(L.Slots, function(a, b) return a[3] < b[3] end)
		
		if Total > 0 then
			local r, g, b = ColorGradient(floor(L.Slots[1][3]*100)/100, .9, .2, .2, .9, .9, .2, .2, .9, .2)

			Text:SetFormattedText('|cff%02x%02x%02x%s%%|r %s', r*255, g*255, b*255, floor(L.Slots[1][3]*100), T.cStart .. L.datatext_armor)
		else
			Text:SetFormattedText('|cff%02x%02x%02x100%%|r %s', 0.2*255, 0.8*255, 0.2*255, T.cStart .. L.datatext_armor)
		end
		
		self:SetAllPoints(Text)
		Total = 0
	end

	Stat:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	Stat:RegisterEvent("MERCHANT_SHOW")
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:SetScript("OnMouseDown", function() ToggleCharacter("PaperDollFrame") end)
	Stat:SetScript("OnEvent", OnEvent)
	Stat:SetScript("OnEnter", function(self)
		local anchor, panel, xoff, yoff = T.DataTextTooltipAnchor(Text)
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)
		GameTooltip:ClearLines()
		for i = 1, 11 do
			if L.Slots[i][3] ~= 1000 then
				green = L.Slots[i][3]*2
				red = 1 - green
				GameTooltip:AddDoubleLine(L.Slots[i][2], floor(L.Slots[i][3]*100) .. "%",1 ,1 , 1, red + 1, green, 0)
			end
		end
		GameTooltip:Show()
	end)
	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
end