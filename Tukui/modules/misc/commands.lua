local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
-- enable or disable an addon via command
SlashCmdList.DISABLE_ADDON = function(addon) local _, _, _, _, _, reason, _ = GetAddOnInfo(addon) if reason ~= "MISSING" then DisableAddOn(addon) ReloadUI() else print("|cffff0000Error, Addon not found.|r") end end
SLASH_DISABLE_ADDON1 = "/disable"

SlashCmdList.ENABLE_ADDON = function(addon) local _, _, _, _, _, reason, _ = GetAddOnInfo(addon) if reason ~= "MISSING" then EnableAddOn(addon) LoadAddOn(addon) ReloadUI() else print("|cffff0000Error, Addon not found.|r") end end
SLASH_ENABLE_ADDON1 = "/enable"

-- switch to heal layout via a command
SLASH_TUKUIHEAL1 = "/heal"
SlashCmdList.TUKUIHEAL = function()
	DisableAddOn("Tukui_Dps_Layout")
	EnableAddOn("Tukui_Heal_Layout")
	ReloadUI()
end

-- switch to dps layout via a command
SLASH_TUKUIDPS1 = "/dps"
SlashCmdList.TUKUIDPS = function()
	DisableAddOn("Tukui_Heal_Layout")
	EnableAddOn("Tukui_Dps_Layout")
	ReloadUI()
end

-- fix combatlog manually when it broke
SLASH_CLFIX1 = "/clfix"
SlashCmdList.CLFIX = CombatLogClearEntries

-- ready check shortcut
SLASH_RCSLASH1 = "/rc"
SlashCmdList.RCSLASH = DoReadyCheck

SLASH_RAIDDISBAND1 = "/rd"
SlashCmdList["RAIDDISBAND"] = function()
		SendChatMessage(L.disband, "RAID" or "PARTY")
		if UnitInRaid("player") then
			for i = 1, GetNumRaidMembers() do
				local name, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
				if online and name ~= T.myname then
					UninviteUnit(name)
				end
			end
		else
			for i = MAX_PARTY_MEMBERS, 1, -1 do
				if GetPartyMember(i) then
					UninviteUnit(UnitName("party"..i))
				end
			end
		end
		LeaveParty()
end

-- Leave party chat command
SlashCmdList["LEAVEPARTY"] = function()
	LeaveParty()
end
SLASH_LEAVEPARTY1 = '/leaveparty'

-- chat position reset to Tukui default
-- since t14, we do not force position after loading UI.
-- you can execute this command if you made change and want to reset back to default
-- an alternative method is to launch the install and only apply step 2 (chat)
SLASH_TUKUICHATRESET1 = "/chatdefault"
SlashCmdList.TUKUICHATRESET = function()
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
			frame:Point("BOTTOMLEFT", TukuiInfoLeft, "TOPLEFT", 0, 6)
		elseif i == 4 and chatName == LOOT then
			frame:ClearAllPoints()
			frame:Point("BOTTOMRIGHT", TukuiInfoRight, "TOPRIGHT", 0, 6)
		end

		-- save new default position and dimension
		FCF_SavePositionAndDimensions(frame)

		-- lock them if unlocked
		if not frame.isLocked then FCF_SetLocked(frame, 1) end
	end
end