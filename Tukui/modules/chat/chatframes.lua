
local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
if C["chat"].enable ~= true then return end

local TukuiChat = CreateFrame("Frame", "TukuiChat")
local _G = _G
local origs = {}
local type = type
local dummy = T.dummy

-- move these to kill.lua when implemented
FriendsMicroButton:Kill()
ChatFrameMenuButton:Kill()

-- function to rename channel and other stuff
local AddMessage = function(self, text, ...)
	if(type(text) == "string") then
		text = text:gsub('|h%[(%d+)%. .-%]|h', '|h[%1]|h')
	end
	return origs[self](self, text, ...)
end

-- Shortcut channel name
_G.CHAT_BATTLEGROUND_GET = "|Hchannel:Battleground|h"..L.chat_BATTLEGROUND_GET.."|h %s:\32"
_G.CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:Battleground|h"..L.chat_BATTLEGROUND_LEADER_GET.."|h %s:\32"
_G.CHAT_BN_WHISPER_GET = L.chat_BN_WHISPER_GET.." %s:\32"
_G.CHAT_GUILD_GET = "|Hchannel:Guild|h"..L.chat_GUILD_GET.."|h %s:\32"
_G.CHAT_OFFICER_GET = "|Hchannel:o|h"..L.chat_OFFICER_GET.."|h %s:\32"
_G.CHAT_PARTY_GET = "|Hchannel:Party|h"..L.chat_PARTY_GET.."|h %s:\32"
_G.CHAT_PARTY_GUIDE_GET = "|Hchannel:party|h"..L.chat_PARTY_GUIDE_GET.."|h %s:\32"
_G.CHAT_PARTY_LEADER_GET = "|Hchannel:party|h"..L.chat_PARTY_LEADER_GET.."|h %s:\32"
_G.CHAT_RAID_GET = "|Hchannel:raid|h"..L.chat_RAID_GET.."|h %s:\32"
_G.CHAT_RAID_LEADER_GET = "|Hchannel:raid|h"..L.chat_RAID_LEADER_GET.."|h %s:\32"
_G.CHAT_RAID_WARNING_GET = L.chat_RAID_WARNING_GET.." %s:\32"
_G.CHAT_SAY_GET = "%s:\32"
_G.CHAT_WHISPER_GET = L.chat_WHISPER_GET.." %s:\32"
_G.CHAT_YELL_GET = "%s:\32"
 
-- color afk, dnd, gm
_G.CHAT_FLAG_AFK = "|cffFF0000"..L.chat_FLAG_AFK.."|r "
_G.CHAT_FLAG_DND = "|cffE7E716"..L.chat_FLAG_DND.."|r "
_G.CHAT_FLAG_GM = "|cff4154F5"..L.chat_FLAG_GM.."|r "

-- customize online/offline msg
_G.ERR_FRIEND_ONLINE_SS = "|Hplayer:%s|h[%s]|h "..L.chat_ERR_FRIEND_ONLINE_SS.."!"
_G.ERR_FRIEND_OFFLINE_S = "%s "..L.chat_ERR_FRIEND_OFFLINE_S.."!"

-- set the chat style
local function StyleChat(frame)
	local id = frame:GetID()
	local chat = frame:GetName()
	local tab = _G[chat.."Tab"]
	local tabtext = _G[chat.."TabText"]
	local editbox = _G[chat.."EditBox"]
	
	tab:SetAlpha(1)
	tab.SetAlpha = T.dummy
	tab:HookScript("OnClick", function() editbox:Hide() end)
	
	if C["chat"].background ~= true then
		tabtext:Hide()
		tab:HookScript("OnEnter", function() tabtext:Show() end)
		tab:HookScript("OnLeave", function() tabtext:Hide() end)
	end

	tabtext:SetFont(unpack(T.Fonts.cTab.setfont))
	if id < 11 then
		if C["datatext"].classcolor then
			local c = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
			tabtext:SetTextColor(c.r, c.g, c.b)
		else
			tabtext:SetTextColor(unpack(C["datatext"].color))
		end
		tabtext.SetTextColor = T.dummy
	end
	tabtext:SetShadowOffset(0, 0)
	tabtext:ClearAllPoints()
	tabtext:Point("CENTER", tab, "CENTER", 0, -3)
	
	_G[chat]:SetFont(unpack(T.Fonts.cGeneral.setfont))
	_G[chat]:SetClampRectInsets(0,0,0,0)
	_G[chat]:SetClampedToScreen(false)
	_G[chat]:SetFading(false)

	for j = 1, #CHAT_FRAME_TEXTURES do
		_G[chat..CHAT_FRAME_TEXTURES[j]]:SetTexture(nil)
	end

	local textures = {
		"TabLeft", "TabMiddle", "TabRight", "TabSelectedLeft", "TabSelectedMiddle", "TabSelectedRight", "TabHighlightLeft",	
		"TabHighlightMiddle", "TabHighlightRight", "TabSelectedLeft", "TabSelectedMiddle", "TabSelectedRight", "ButtonFrameUpButton", 
		"ButtonFrameDownButton", "ButtonFrameBottomButton", "ButtonFrameMinimizeButton", "ButtonFrame",
		"EditBoxFocusLeft", "EditBoxFocusMid", "EditBoxFocusRight",
	}
	
	for i = 1, getn(textures) do
		_G[chat..textures[i]]:Kill()
	end
	
	local a, b, c = select(6, editbox:GetRegions()) a:Kill() b:Kill() c:Kill()

	editbox:SetAltArrowKeyMode(false)
	editbox:Hide()
	editbox:HookScript("OnEditFocusLost", function(self) self:Hide() end)
	editbox:ClearAllPoints()
	editbox:Point("TOPLEFT", TukuiInfoLeft, 2, -2)
	editbox:Point("BOTTOMRIGHT", TukuiInfoLeft, -2, 2)	
	
	local EditBoxBackground = CreateFrame("frame", "TukuiChatEditBoxBackground", editbox)
	EditBoxBackground:CreatePanel("Default", 1, 1, "LEFT", editbox, "LEFT", 0, 0)
	EditBoxBackground:ClearAllPoints()
	EditBoxBackground:SetAllPoints(TukuiInfoLeft)
	EditBoxBackground:SetFrameStrata("LOW")
	EditBoxBackground:SetFrameLevel(1)

	local function colorize(r,g,b)
		EditBoxBackground:SetBackdropBorderColor(r, g, b)
	end

	-- update border color according where we talk
	hooksecurefunc("ChatEdit_UpdateHeader", function()
		local type = editbox:GetAttribute("chatType")
		if ( type == "CHANNEL" ) then
		local id = GetChannelName(editbox:GetAttribute("channelTarget"))
			if id == 0 then
				colorize(unpack(C["media"].bordercolor))
			else
				colorize(ChatTypeInfo[type..id].r,ChatTypeInfo[type..id].g,ChatTypeInfo[type..id].b)
			end
		else
			colorize(ChatTypeInfo[type].r,ChatTypeInfo[type].g,ChatTypeInfo[type].b)
		end
	end)
	
	if _G[chat] ~= _G["ChatFrame2"] then
		origs[_G[chat]] = _G[chat].AddMessage
		_G[chat].AddMessage = AddMessage
	else
		CombatLogQuickButtonFrame_Custom:StripTextures()
		CombatLogQuickButtonFrame_Custom:SetTemplate("Default")
		T.SkinCloseButton(CombatLogQuickButtonFrame_CustomAdditionalFilterButton)
		CombatLogQuickButtonFrame_CustomAdditionalFilterButton.t:SetText("V")
		CombatLogQuickButtonFrame_CustomAdditionalFilterButton.t:ClearAllPoints()
		CombatLogQuickButtonFrame_CustomAdditionalFilterButton.t:Point("RIGHT", -8, 4)
		CombatLogQuickButtonFrame_CustomProgressBar:ClearAllPoints()
		CombatLogQuickButtonFrame_CustomProgressBar:SetPoint("TOPLEFT", CombatLogQuickButtonFrame_Custom, 2, -2)
		CombatLogQuickButtonFrame_CustomProgressBar:SetPoint("BOTTOMRIGHT", CombatLogQuickButtonFrame_Custom, -2, 2)
		CombatLogQuickButtonFrame_CustomProgressBar:SetStatusBarTexture(C.media.normTex)
	end

	frame.isSkinned = true
end

-- Setup chatframes 1 to 10 on login.
local function SetupChat(self)	
	for i = 1, NUM_CHAT_WINDOWS do
		local chat = _G[format("ChatFrame%s", i)]
		local id = chat:GetID()
		local _, fontsize = FCF_GetChatWindowInfo(id)

		FCF_SetChatWindowFontSize(nil, chat, fontsize)

		StyleChat(chat)
	end

	-- Remember last channel
	ChatTypeInfo.WHISPER.sticky = 1
	ChatTypeInfo.BN_WHISPER.sticky = 1
	ChatTypeInfo.OFFICER.sticky = 1
	ChatTypeInfo.RAID_WARNING.sticky = 1
	ChatTypeInfo.CHANNEL.sticky = 1
end

-- default chat position of left and right (1 & 4) windows
T.SetDefaultChatPosition = function()
	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G[format("ChatFrame%s", i)]
		local chatFrameId = frame:GetID()
		local chatName = FCF_GetChatWindowInfo(chatFrameId)

		-- set the size of chat frames
		frame:Size(T.InfoLeftRightWidth + 1, 111)

		-- tell wow that we are using new size
		SetChatWindowSavedDimensions(chatFrameId, T.Scale(T.InfoLeftRightWidth + 1), T.Scale(111))

		-- move general bottom left or Loot (if found) on right
		if i == 1 then
			frame:ClearAllPoints()
			frame:Point("TOPLEFT", TukuiTabsLeft, "BOTTOMLEFT", 0, -4)
			frame:Point("BOTTOMRIGHT", TukuiInfoLeft, "TOPRIGHT", 0, 4)
		elseif i == 4 and chatName == LOOT then
			if not frame.isDocked then
				frame:ClearAllPoints()
				frame:Point("TOPLEFT", TukuiTabsRight, "BOTTOMLEFT", 0, -4)
				frame:Point("BOTTOMRIGHT", TukuiInfoRight, "TOPRIGHT", 0, 4)
			end
		end

		-- save new default position and dimension
		FCF_SavePositionAndDimensions(frame)

		-- lock them if unlocked
		if not frame.isLocked then FCF_SetLocked(frame, 1) end
	end
end

TukuiChat:RegisterEvent("ADDON_LOADED")
TukuiChat:SetScript("OnEvent", function(self, event, addon)
	if addon == "Blizzard_CombatLog" then
		self:UnregisterEvent("ADDON_LOADED")
		SetupChat(self)
	end
end)

-- Setup temp chat (BN, WHISPER) when needed.
local function SetupTempChat(id)
	local frame = FCF_GetCurrentChatFrame()
	
	if frame.isSkinned then return end
	
	frame.temp = true
	StyleChat(frame)
end
hooksecurefunc("FCF_OpenTemporaryWindow", SetupTempChat)

-- reposition battle.net popup
BNToastFrame:HookScript("OnShow", function(self)
	self:ClearAllPoints()
	self:Point("BOTTOMLEFT", TukuiChatLeft, "TOPLEFT", 0, 3)
end)

-- reskin Toast Frame Close Button
T.SkinCloseButton(BNToastFrameCloseButton)

-- kill the default reset button
ChatConfigFrameDefaultButton:Kill()

-- default position of chat #1 (left) and chat #4 (right)
T.SetDefaultChatPosition = function(frame)
	if frame then
		local id = frame:GetID()
		local name = FCF_GetChatWindowInfo(id)

		-- set the size of chat frames
		frame:Size(T.InfoLeftRightWidth + 1, 111)

		-- tell wow that we are using new size
		SetChatWindowSavedDimensions(id, T.Scale(T.InfoLeftRightWidth + 1), T.Scale(111))

		if id == 1 then
			frame:ClearAllPoints()
			frame:Point("TOPLEFT", TukuiTabsLeft, "BOTTOMLEFT", 0, -4)
			frame:Point("BOTTOMRIGHT", TukuiInfoLeft, "TOPRIGHT", 0, 4)
		elseif id == 4 and name == LOOT then
			if not frame.isDocked then
				frame:ClearAllPoints()
				frame:Point("TOPLEFT", TukuiTabsRight, "BOTTOMLEFT", 0, -4)
				frame:Point("BOTTOMRIGHT", TukuiInfoRight, "TOPRIGHT", 0, 4)
				if C.chat.justifyRight then
					frame:SetJustifyH("RIGHT")
				else
					frame:SetJustifyH("LEFT")
				end
			end
		end

		-- save new default position and dimension
		FCF_SavePositionAndDimensions(frame)

		-- lock them if unlocked
		if not frame.isLocked then FCF_SetLocked(frame, 1) end
	end
end
hooksecurefunc("FCF_RestorePositionAndDimensions", T.SetDefaultChatPosition)