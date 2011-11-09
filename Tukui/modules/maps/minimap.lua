local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
--------------------------------------------------------------------
-- Tukui Minimap Script
--------------------------------------------------------------------

local TukuiMinimap = CreateFrame("Frame", "TukuiMinimap", UIParent)
TukuiMinimap:CreatePanel("Default", 1, 1, "CENTER", UIParent, "CENTER", 0, 0)
TukuiMinimap:RegisterEvent("ADDON_LOADED")
TukuiMinimap:Point("TOPRIGHT", UIParent, "TOPRIGHT", -8, -8)
TukuiMinimap:Size(144, 144)
TukuiMinimap:SetClampedToScreen(true)
TukuiMinimap:SetMovable(true)
TukuiMinimap.text = T.SetFontString(TukuiMinimap, unpack(T.Fonts.movers.setfont))
TukuiMinimap.text:SetPoint("CENTER")
TukuiMinimap.text:SetText(L.move_minimap)

-- kill the minimap cluster
MinimapCluster:Kill()

-- Parent Minimap into our Map frame.
Minimap:SetParent(TukuiMinimap)
Minimap:ClearAllPoints()
Minimap:Point("TOPLEFT", 2, -2)
Minimap:Point("BOTTOMRIGHT", -2, 2)

-- Hide Border
MinimapBorder:Hide()
MinimapBorderTop:Hide()

-- Hide Zoom Buttons
MinimapZoomIn:Hide()
MinimapZoomOut:Hide()

-- Hide Voice Chat Frame
MiniMapVoiceChatFrame:Hide()

-- Hide North texture at top
MinimapNorthTag:SetTexture(nil)

-- Hide Zone Frame
MinimapZoneTextButton:Hide()

-- Hide Tracking Button
MiniMapTracking:Hide()

-- Hide Calendar Button
GameTimeFrame:Hide()

-- Hide Mail Button
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:Point("TOPRIGHT", Minimap, 3, 3)
MiniMapMailBorder:Hide()
MiniMapMailIcon:SetTexture("Interface\\AddOns\\Tukui\\media\\textures\\mail")

-- Move battleground icon
MiniMapBattlefieldFrame:ClearAllPoints()
MiniMapBattlefieldFrame:Point("BOTTOMRIGHT", Minimap, 3, 0)
MiniMapBattlefieldBorder:Hide()

-- Ticket Frame
local TukuiTicket = CreateFrame("Frame", "TukuiTicket", TukuiMinimap)
TukuiTicket:CreatePanel("Default", 1, 1, "CENTER", TukuiMinimap, "CENTER", 0, 0)
TukuiTicket:Size(TukuiMinimap:GetWidth() - 4, 24)
TukuiTicket:SetFrameStrata("MEDIUM")
TukuiTicket:SetFrameLevel(20)
TukuiTicket:Point("TOP", 0, -2)
TukuiTicket:FontString("Text", C.media.caith, 12)
TukuiTicket.Text:SetPoint("CENTER")
TukuiTicket.Text:SetText(HELP_TICKET_EDIT)
TukuiTicket:SetBackdropBorderColor(255/255, 243/255,  82/255)
TukuiTicket.Text:SetTextColor(255/255, 243/255,  82/255)
TukuiTicket:SetAlpha(0)

HelpOpenTicketButton:SetParent(TukuiTicket)
HelpOpenTicketButton:SetFrameLevel(TukuiTicket:GetFrameLevel() + 1)
HelpOpenTicketButton:SetFrameStrata(TukuiTicket:GetFrameStrata())
HelpOpenTicketButton:ClearAllPoints()
HelpOpenTicketButton:SetAllPoints()
HelpOpenTicketButton:SetHighlightTexture(nil)
HelpOpenTicketButton:SetAlpha(0)
HelpOpenTicketButton:HookScript("OnShow", function(self) TukuiTicket:SetAlpha(1) end)
HelpOpenTicketButton:HookScript("OnHide", function(self) TukuiTicket:SetAlpha(0) end)

-- Hide world map button
MiniMapWorldMapButton:Hide()

-- shitty 3.3 flag to move
MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetParent(Minimap)
MiniMapInstanceDifficulty:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0)

-- 4.0.6 Guild instance difficulty
GuildInstanceDifficulty:ClearAllPoints()
GuildInstanceDifficulty:SetParent(Minimap)
GuildInstanceDifficulty:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0)

-- Reposition lfg icon at bottom-left
local function UpdateLFG()
	MiniMapLFGFrame:ClearAllPoints()
	MiniMapLFGFrame:Point("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 2, 1)
	MiniMapLFGFrameBorder:Hide()
end
if T.toc < 40300 then
	hooksecurefunc("MiniMapLFG_UpdateIsShown", UpdateLFG)
else
	hooksecurefunc("MiniMapLFG_Update", UpdateLFG)
end

-- reskin LFG dropdown
local status
if T.toc >= 40300 then status = LFGSearchStatus else status = LFDSearchStatus end
status:SetTemplate("Default")

-- for t13+, if we move map we need to point status according to our Minimap position.
local function UpdateLFGTooltip()
	local position = TukuiMinimap:GetPoint()
	status:ClearAllPoints()
	if position:match("BOTTOMRIGHT") then
		status:SetPoint("BOTTOMRIGHT", MiniMapLFGFrame, "BOTTOMLEFT", 0, 0)
	elseif position:match("BOTTOM") then
		status:SetPoint("BOTTOMLEFT", MiniMapLFGFrame, "BOTTOMRIGHT", 4, 0)
	elseif position:match("LEFT") then
		status:SetPoint("TOPLEFT", MiniMapLFGFrame, "TOPRIGHT", 4, 0)
	else
		status:SetPoint("TOPRIGHT", MiniMapLFGFrame, "TOPLEFT", 0, 0)
	end
end
status:HookScript("OnShow", UpdateLFGTooltip)

-- Enable mouse scrolling
Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(self, d)
	if d > 0 then
		_G.MinimapZoomIn:Click()
	elseif d < 0 then
		_G.MinimapZoomOut:Click()
	end
end)

-- Set Square Map Mask
Minimap:SetMaskTexture(C.media.blank)

-- For others mods with a minimap button, set minimap buttons position in square mode.
function GetMinimapShape() return "SQUARE" end

-- do some stuff on addon loaded or player login event
TukuiMinimap:SetScript("OnEvent", function(self, event, addon)
	if addon == "Blizzard_TimeManager" then
		-- Hide Game Time
		TimeManagerClockButton:Kill()
	end
end)

----------------------------------------------------------------------------------------
-- Map menus, right/middle click
----------------------------------------------------------------------------------------

Minimap:SetScript("OnMouseUp", function(self, btn)
	local xoff = 0
	local position = TukuiMinimap:GetPoint()
	
	if btn == "RightButton" then		
		if position:match("RIGHT") then xoff = T.Scale(-8) end
		ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, TukuiMinimap, xoff, T.Scale(-2))
	elseif btn == "MiddleButton" then
		if not TukuiMicroMenu then return end
		if position:match("RIGHT") then xoff = T.Scale(-14) end
		ToggleDropDownMenu(1, nil, TukuiMicroMenu, TukuiMinimap, xoff, T.Scale(-2))
	else
		Minimap_OnClick(self)
	end
end)