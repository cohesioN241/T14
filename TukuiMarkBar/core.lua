-- Mark Bar created by Smelly
local T, C, L = unpack(Tukui)

local Options = {
	font = C.media.pixel_font or C.media.font,
	fontsize = 12,
	buttonwidth = T.Scale(30),    		
	buttonheight = T.Scale(30),   		
	toplayout = true,					
	datatext = false,
}

-- Default position of toggle button and background
local anchor = {}
if Options.toplayout then
	if C["datatext"].statblock then
		anchor = {"TOPLEFT", TukuiDurStat, "TOPRIGHT", 3, 0}
	else
		anchor = {"TOPLEFT", UIParent, "TOPLEFT", 8, -8}
	end
else
	anchor = {"BOTTOMLEFT", TukuiInfoRight, "TOPLEFT", 0, 3}
end

local function ButtonEnter(self)
	local color = RAID_CLASS_COLORS[T.myclass]
	self:SetBackdropBorderColor(color.r, color.g, color.b)
end
 
local function ButtonLeave(self)
	self:SetBackdropBorderColor(unpack(C["media"].bordercolor))
end

local MarkBarBG = CreateFrame("Frame", "MarkBarBackground", UIParent)
MarkBarBG:CreatePanel("Default", Options.buttonwidth * 4 + T.Scale(15), Options.buttonheight * 3 + T.Scale(2), "BOTTOMLEFT", TukuiInfoRight, "TOPLEFT", 0, T.Scale(3))
MarkBarBG:SetFrameLevel(0)
MarkBarBG:ClearAllPoints()
MarkBarBG:SetPoint(unpack(anchor))
MarkBarBG:Hide()

local icon = CreateFrame("Button", "Icon", MarkBarBG)
local mark = CreateFrame("Button", "Menu", MarkBarBG)
for i = 1, 8 do
	mark[i] = CreateFrame("Button", "mark"..i, MarkBarBG)
	mark[i]:CreatePanel("Default", Options.buttonwidth, Options.buttonheight, "LEFT", MarkBarBG, "LEFT", T.Scale(3), T.Scale(-3))
	if i == 1 then
		mark[i]:SetPoint("TOPLEFT", MarkBarBG, "TOPLEFT",  T.Scale(3), T.Scale(-3))
	elseif i == 5 then
		mark[i]:SetPoint("TOP", mark[1], "BOTTOM", 0, T.Scale(-3))
	else
		mark[i]:SetPoint("LEFT", mark[i-1], "RIGHT", T.Scale(3), 0)
	end
	mark[i]:EnableMouse(true)
	mark[i]:SetScript("OnEnter", ButtonEnter)
	mark[i]:SetScript("OnLeave", ButtonLeave)
	mark[i]:SetScript("OnMouseUp", function() SetRaidTarget("target", i) end)
	
	icon[i] = CreateFrame("Button", "icon"..i, MarkBarBG)
	icon[i]:SetNormalTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
	icon[i]:Size(25, 25)
	icon[i]:Point("CENTER", mark[i])
	
	-- Set up each button
	if i == 1 then 
		icon[i]:GetNormalTexture():SetTexCoord(0,0.25,0,0.25)
	elseif i == 2 then
		icon[i]:GetNormalTexture():SetTexCoord(0.25,0.5,0,0.25)
	elseif i == 3 then
		icon[i]:GetNormalTexture():SetTexCoord(0.5,0.75,0,0.25)
	elseif i == 4 then
		icon[i]:GetNormalTexture():SetTexCoord(0.75,1,0,0.25)
	elseif i == 5 then
		icon[i]:GetNormalTexture():SetTexCoord(0,0.25,0.25,0.5)
	elseif i == 6 then
		icon[i]:GetNormalTexture():SetTexCoord(0.25,0.5,0.25,0.5)
	elseif i == 7 then
		icon[i]:GetNormalTexture():SetTexCoord(0.5,0.75,0.25,0.5)
	elseif i == 8 then
		icon[i]:GetNormalTexture():SetTexCoord(0.75,1,0.25,0.5)
	end
end

-- Create Button for clear target
local ClearTargetButton = CreateFrame("Button", "ClearTargetButton", MarkBarBackground)
ClearTargetButton:CreatePanel("Default", (Options.buttonwidth * 4) + 9, 20, "TOPLEFT", mark[5], "BOTTOMLEFT", 0, T.Scale(-3))
ClearTargetButton:SetScript("OnEnter", ButtonEnter)
ClearTargetButton:SetScript("OnLeave", ButtonLeave)
ClearTargetButton:SetScript("OnMouseUp", function() SetRaidTarget("target", 0) end)
ClearTargetButton:SetFrameStrata("HIGH")

ClearTargetButtonText = T.SetFontString(ClearTargetButton, Options.font, Options.fontsize, "MONOCHROMEOUTLINE")
ClearTargetButtonText:SetText(MarkBarLocal.button_Clear)
ClearTargetButtonText:SetPoint("CENTER")
ClearTargetButtonText:SetJustifyH("CENTER", 1, 0)

if Options.datatext == false then
--Create toggle button
	local ToggleButton = CreateFrame("Frame", "ToggleButton", UIParent)
	ToggleButton:CreatePanel("Default", 100, 23, "CENTER", UIParent, "CENTER", 0, 0)
	ToggleButton:ClearAllPoints()
	ToggleButton:SetPoint(unpack(anchor))
	ToggleButton:EnableMouse(true)
	ToggleButton:SetFrameStrata("HIGH")
	ToggleButton:SetScript("OnEnter", ButtonEnter)
	ToggleButton:SetScript("OnLeave", ButtonLeave)

	local ToggleButtonText = T.SetFontString(ToggleButton, Options.font, Options.fontsize, "MONOCHROMEOUTLINE")
	ToggleButtonText:SetText(MarkBarLocal.button_MarkBar)
	ToggleButtonText:SetPoint("CENTER", ToggleButton, "CENTER")
	
	--Create close button
	local CloseButton = CreateFrame("Frame", "CloseButton", MarkBarBackground)
	CloseButton:CreatePanel("Default", 25, Options.buttonheight * 3 + T.Scale(2), "TOPLEFT", MarkBarBackground, "TOPRIGHT", T.Scale(2), 0)
	CloseButton:EnableMouse(true)
	CloseButton:SetScript("OnEnter", ButtonEnter)
	CloseButton:SetScript("OnLeave", ButtonLeave)
	
	local CloseButtonText = T.SetFontString(CloseButton, C["media"].pixel_font, 12, "MONOCHROME")
	CloseButtonText:SetText("X")
	CloseButtonText:SetPoint("CENTER", CloseButton, "CENTER")

	ToggleButton:SetScript("OnMouseDown", function()
		if MarkBarBackground:IsShown() then
			MarkBarBackground:Hide()
		else
			MarkBarBackground:Show()
			ToggleButton:Hide()
		end
	end)
	
	CloseButton:SetScript("OnMouseDown", function()
		if MarkBarBackground:IsShown() then
			MarkBarBackground:Hide()
			ToggleButton:Show()
		else
			ToggleButton:Show()
		end
	end)
end

--Setup datatext position and function
if Options.datatext then
	if C["datatext"].raidmarks and C["datatext"].raidmarks > 0 then
		local dToggleButton = CreateFrame("Frame", "dToggleButton", UIParent)
		dToggleButton:EnableMouse(true)
		dToggleButton:SetWidth(80)
		T.PP(C["datatext"].raidmarks, dToggleButton)
		
		local dToggleButtonText = T.SetFontString(TukuiInfoLeft, Options.font, Options.fontsize)
		dToggleButtonText:SetText(MarkBarLocal.button_MarkBar)
		dToggleButtonText:SetPoint("CENTER", dToggleButton, "CENTER")

		dToggleButton:SetScript("OnMouseDown", function()
			if MarkBarBackground:IsShown() then
				MarkBarBackground:Hide()
			else
				MarkBarBackground:Show()
			end
		end)
	end
end

--Check if we are Raid Leader or Raid Officer / Party
local function CheckRaidStatus()
	local inInstance, instanceType = IsInInstance()
	local partyMembers = GetNumPartyMembers()
 
	if not UnitInRaid("player") and partyMembers >= 1 then return true
	elseif UnitIsRaidOfficer("player") then return true
	elseif not inInstance or instanceType == "pvp" or instanceType == "arena" then return false
	end
end

--Automatically show/hide the frame if we have Raid Leader or Raid Officer or in Party
local LeadershipCheck = CreateFrame("Frame")
LeadershipCheck:RegisterEvent("RAID_ROSTER_UPDATE")
LeadershipCheck:RegisterEvent("PARTY_MEMBERS_CHANGED")
LeadershipCheck:RegisterEvent("PLAYER_ENTERING_WORLD")
LeadershipCheck:SetScript("OnEvent", function(self, event)
	if CheckRaidStatus() then
		if Options.datatext then
			dToggleButton:Show()
			MarkBarBackground:Hide()
		else
			ToggleButton:Show()
			MarkBarBackground:Hide()
		end
	else
		if Options.datatext then
			dToggleButton:Hide()
			MarkBarBackground:Hide()
		else
			ToggleButton:Hide()
			MarkBarBackground:Hide()
		end
	end
end)