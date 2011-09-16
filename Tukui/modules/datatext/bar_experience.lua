local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
if T.level == 85 or not C["datatext"].exprepbars == true then return end

local font = C["media"].pixel_font or C["media"].font
local fontsize = 12
local fontstyle = "MONOCHROMEOUTLINE" or "OUTLINE"

local dtext = C["datatext"].expreptext

if not dtext then
	height = 10
else
	height = 20
end

local xp = CreateFrame("Frame", "TukuiExperience", UIParent)
if C["datatext"].exprepbars then
	xp:CreatePanel("Default", TukuiMinimap:GetWidth(), height, "TOPLEFT", TukuiMinimap, "BOTTOMLEFT", 0, -10)
	xp:HookScript("OnUpdate", function(self) xp:SetPoint("TOPLEFT", TukuiMinimap, "BOTTOMLEFT", 0, -10) end)
else
	xp:CreatePanel("Default", TukuiMinimap:GetWidth(), height, "TOPLEFT", UIParent, "TOPLEFT", 8, -15)
end
xp:EnableMouse(true)

local bar = CreateFrame("StatusBar", "TukuiExperienceBar", xp)
bar:SetPoint("TOPLEFT", xp, 2, -2)
bar:SetPoint("BOTTOMRIGHT", xp, -2, 2)
bar:SetStatusBarTexture(C["media"].normTex)
xp.bar = bar

local text = bar:CreateFontString(nil, "LOW")
text:SetFont(font, fontsize, fontstyle)
text:Point("CENTER", xp, 0, 1)
xp.text = text


local xpcolors = {
	{ r = .6, g = .3, b = .1 }, -- Normal
	{ r = .1, g = .3, b = .6 }, -- Rested
}

local function shortvalue(value)
	if value >= 1e6 then
		return ("%.1fm"):format(value / 1e6):gsub("%.?0+([km])$", "%1")
	elseif value >= 1e4 or value <= -1e4 then
		return ("%.1fk"):format(value / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return value
	end
end

local function event(self, event, ...)
	local currValue = UnitXP("player")
	local maxValue = UnitXPMax("player")
	local restXP = GetXPExhaustion()

	bar:SetMinMaxValues(0, maxValue)
	bar:SetValue(currValue)
	
	currValue = shortvalue(currValue)
	maxValue = shortvalue(maxValue)
	if restXP ~= nil and restXP > 0 then
		restXP = shortvalue(restXP)
	end
	
	if restXP then
    if dtext then
		  text:SetText(currValue .. " / " .. maxValue .. " R: " .. restXP)
    else
		  text:SetText(" ")
    end
		
		bar:SetStatusBarColor(xpcolors[2].r, xpcolors[2].g, xpcolors[2].b, xpcolors[2].a)
	else
    if dtext then
		  text:SetText(currValue .. " / " .. maxValue)
    else
		  text:SetText(" ")
    end
		
		bar:SetStatusBarColor(xpcolors[1].r, xpcolors[1].g, xpcolors[1].b, xpcolors[1].a)
	end
end

xp:HookScript("OnEnter", function()
	local currValue = UnitXP("player")
	local maxValue = UnitXPMax("player")
	local restXP = GetXPExhaustion()
	
	local perMax = maxValue - currValue
	local perGain = format("%.1f%%", (currValue / maxValue) * 100)
	local perRem = format("%.1f%%", (perMax / maxValue) * 100)
	
	local bars = format("%.1f", currValue / maxValue * 20)

	GameTooltip:SetOwner(xp, "ANCHOR_BOTTOM", -T.buttonspacing, -(xp:GetHeight() - height + T.buttonspacing))
	GameTooltip:ClearLines()
	GameTooltip:AddLine("Experience:|r")
	GameTooltip:AddLine" "
	GameTooltip:AddDoubleLine("Bars: |r", bars.." / 20", _, _, _, 1, 1, 1)
	GameTooltip:AddDoubleLine("Gained: |r", shortvalue(currValue).." ("..perGain..")", _, _, _, 1, 1, 1)
	GameTooltip:AddDoubleLine("Remaining: |r", shortvalue(maxValue - currValue).." ("..perRem..")", _, _, _, xpcolors[1].r, xpcolors[1].g, xpcolors[1].b)
	GameTooltip:AddDoubleLine("Total: |r", shortvalue(maxValue), _, _, _, 1, 1, 1)
	if restXP ~= nil and restXP > 0 then
		GameTooltip:AddDoubleLine("Rested: |r", shortvalue(restXP).." ("..format("%.f%%", restXP / maxValue * 100)..")", _, _, _, xpcolors[2].r, xpcolors[2].g, xpcolors[2].b)
	end
	
	GameTooltip:Show()
end)
xp:HookScript("OnLeave", function() GameTooltip:Hide() end)

xp:RegisterEvent("PLAYER_XP_UPDATE")
xp:RegisterEvent("PLAYER_LEVEL_UP")
xp:RegisterEvent("UPDATE_EXHAUSTION")
xp:RegisterEvent("PLAYER_ENTERING_WORLD")
xp:HookScript("OnEvent", event)
