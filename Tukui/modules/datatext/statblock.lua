local T, C, L = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

if not C["datatext"].statblock then return end

--------------------------------------------------------------------
-- MEM
--------------------------------------------------------------------

local TukuiMemoryStat = CreateFrame("Frame", "TukuiMemoryStat", UIParent)
TukuiMemoryStat:CreatePanel(TukuiMemoryStat, 70, 23, "TOPLEFT", UIParent, "TOPLEFT", 8, -8)
TukuiMemoryStat:RegisterEvent("PLAYER_ENTERING_WORLD")
TukuiMemoryStat:SetFrameStrata("BACKGROUND")
TukuiMemoryStat:SetFrameLevel(3)
TukuiMemoryStat:EnableMouse(true)
TukuiMemoryStat.tooltip = false

local MemText  = TukuiMemoryStat:CreateFontString(nil, "OVERLAY")
MemText:SetFont(unpack(T.Fonts.dFont.setfont))
MemText:SetPoint("CENTER")

local bandwidthString = "%.2f Mbps"
local percentageString = "%.2f%%"

local kiloByteString = "%d " .. T.cStart .. "kb"
local megaByteString = "%.2f " .. T.cStart .. "mb"

local function formatMem(memory)
	local mult = 10^1
	if memory > 999 then
		local mem = ((memory/1024) * mult) / mult
		return string.format(megaByteString, mem)
	else
		local mem = (memory * mult) / mult
		return string.format(kiloByteString, mem)
	end
end

local memoryTable = {}

local function RebuildAddonList(self)
	local addOnCount = GetNumAddOns()
	if (addOnCount == #memoryTable) or self.tooltip == true then return end

	-- Number of loaded addons changed, create new memoryTable for all addons
	memoryTable = {}
	for i = 1, addOnCount do
		memoryTable[i] = { i, select(2, GetAddOnInfo(i)), 0, IsAddOnLoaded(i) }
	end
	MemText:SetAllPoints(TukuiMemoryStat)
end

local function UpdateMemory()
	-- Update the memory usages of the addons
	UpdateAddOnMemoryUsage()
	-- Load memory usage in table
	local addOnMem = 0
	local totalMemory = 0
	for i = 1, #memoryTable do
		addOnMem = GetAddOnMemoryUsage(memoryTable[i][1])
		memoryTable[i][3] = addOnMem
		totalMemory = totalMemory + addOnMem
	end
	-- Sort the table to put the largest addon on top
	table.sort(memoryTable, function(a, b)
		if a and b then
			return a[3] > b[3]
		end
	end)
	
	return totalMemory
end

local int = 10

local function MemUpdate(self, t)
	int = int - t
	
	if int < 0 then
		RebuildAddonList(self)
		local total = UpdateMemory()
		
		local r, g, b = ColorGradient(total/7000, .2, .9, .2, .9, .9, .2, .9, .2, .2)
		MemText:SetFormattedText('|cff%02x%02x%s %s', r*255, g*255, b*255, formatMem(total))
		
		int = 10
	end
end

TukuiMemoryStat:SetScript("OnMouseDown", function () collectgarbage("collect") MemUpdate(TukuiMemoryStat, 10) end)
TukuiMemoryStat:SetScript("OnEnter", function(self)
	self.tooltip = true
	local bandwidth = GetAvailableBandwidth()
	local anchor, panel, xoff, yoff = T.DataTextTooltipAnchor(MemText)
	GameTooltip:SetOwner(panel, anchor, xoff, yoff)
	GameTooltip:ClearLines()
	if bandwidth ~= 0 then
		-- GetAvailableBandwidth() func is bugged as always, commenting for now
		-- GameTooltip:AddDoubleLine(L.datatext_bandwidth , string.format(bandwidthString, bandwidth),0.69, 0.31, 0.31,0.84, 0.75, 0.65)
		GameTooltip:AddDoubleLine(L.datatext_download , string.format(percentageString, GetDownloadedPercentage() *100),0.69, 0.31, 0.31, 0.84, 0.75, 0.65)
		GameTooltip:AddLine(" ")
	end
	local totalMemory = UpdateMemory()
	GameTooltip:AddDoubleLine(L.datatext_totalmemusage, formatMem(totalMemory), 0.69, 0.31, 0.31,0.84, 0.75, 0.65)
	GameTooltip:AddLine(" ")
	for i = 1, #memoryTable do
		if (memoryTable[i][4]) then
			local red = memoryTable[i][3] / totalMemory
			local green = 1 - red
			GameTooltip:AddDoubleLine(memoryTable[i][2], formatMem(memoryTable[i][3]), 1, 1, 1, red, green + .5, 0)
		end						
	end
	GameTooltip:Show()
end)
TukuiMemoryStat:SetScript("OnLeave", function(self) self.tooltip = false GameTooltip:Hide() end)
TukuiMemoryStat:SetScript("OnUpdate", MemUpdate)
TukuiMemoryStat:SetScript("OnEvent", function(self, event) collectgarbage("collect") end)
MemUpdate(TukuiMemoryStat, 10)


--------------------------------------------------------------------
-- FPS
--------------------------------------------------------------------

local TukuiFpsStat = CreateFrame("Frame", "TukuiFpsStat", UIParent)
TukuiFpsStat:CreatePanel(TukuiFpsStat, 115, 23, "LEFT", TukuiMemoryStat, "RIGHT", 3, 0)
TukuiFpsStat:RegisterEvent("PLAYER_ENTERING_WORLD")
TukuiFpsStat:SetFrameStrata("BACKGROUND")
TukuiFpsStat:SetFrameLevel(3)
TukuiFpsStat:EnableMouse(true)

local FpsText  = TukuiFpsStat:CreateFontString(nil, "OVERLAY")
FpsText:SetFont(unpack(T.Fonts.dFont.setfont))
FpsText:SetPoint("CENTER")

local int = 1
local function FpsUpdate(self, t)
	int = int - t
	if int < 0 then
		local fps = floor(GetFramerate()) --.. T.cStart .. L.datatext_fps .. T.cEnd
		local ms = select(3, GetNetStats()) --.. T.cStart .. L.datatext_ms .. T.cEnd
		
		local r1, g1, b1 = ColorGradient(fps/60, .9, .2, .2, .9, .9, .2, .2, .9, .2)
		local r2, g2, b2 = ColorGradient(ms/350, .2, .9, .2, .9, .9, .2, .9, .2, .2)
		FpsText:SetFormattedText('|cff%02x%02x%s%s|cff%02x%02x%s%s', r1*255, g1*255, b1*255, fps .. T.cStart .. L.datatext_fps .. T.cEnd, r2*255, g2*255, b2*255, ms .. T.cStart .. L.datatext_ms .. T.cEnd)
		
		FpsText:SetAllPoints(TukuiFpsStat)
		int = 1
	end	
end
TukuiFpsStat:SetScript("OnUpdate", FpsUpdate)

TukuiFpsStat:SetScript("OnEnter", function(self)
	if not InCombatLockdown() then
		local anchor, panel, xoff, yoff = T.DataTextTooltipAnchor(FpsText)
		local _, _, latencyHome, latencyWorld = GetNetStats()
		local latency = format(MAINMENUBAR_LATENCY_LABEL, latencyHome, latencyWorld)
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(latency)
		GameTooltip:Show()
	end
end)  
TukuiFpsStat:SetScript("OnLeave", function() GameTooltip:Hide() end) 
FpsUpdate(TukuiFpsStat, 10)


--------------------------------------------------------------------
-- DURABILITY
--------------------------------------------------------------------

local TukuiDurStat = CreateFrame("Frame", "TukuiDurStat", UIParent)
TukuiDurStat:CreatePanel(TukuiDurStat, 85, 23, "LEFT", TukuiFpsStat, "RIGHT", 3, 0)
TukuiDurStat:SetFrameStrata("BACKGROUND")
TukuiDurStat:SetFrameLevel(3)
TukuiDurStat:EnableMouse(true)

local DurText  = TukuiDurStat:CreateFontString(nil, "OVERLAY")
DurText:SetFont(unpack(T.Fonts.dFont.setfont))
DurText:SetPoint("CENTER")

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

		DurText:SetFormattedText('|cff%02x%02x%02x%s%%|r %s', r*255, g*255, b*255, floor(L.Slots[1][3]*100), T.cStart .. L.datatext_armor)
	else
		DurText:SetFormattedText('|cff%02x%02x%02x100%%|r %s', 0.2*255, 0.8*255, 0.2*255, T.cStart .. L.datatext_armor)
	end
	
	DurText:SetAllPoints(TukuiDurStat)
	Total = 0
end

TukuiDurStat:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
TukuiDurStat:RegisterEvent("MERCHANT_SHOW")
TukuiDurStat:RegisterEvent("PLAYER_ENTERING_WORLD")
TukuiDurStat:SetScript("OnMouseDown", function() ToggleCharacter("PaperDollFrame") end)
TukuiDurStat:SetScript("OnEvent", OnEvent)
TukuiDurStat:SetScript("OnEnter", function(self)
	local anchor, panel, xoff, yoff = T.DataTextTooltipAnchor(DurText)
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
TukuiDurStat:SetScript("OnLeave", function() GameTooltip:Hide() end)