local T, C, L = unpack(select(2, ...))
if not C["actionbar"].enable == true then return end

---------------------------------------------------------------------------
-- Manage all others stuff for actionbars
---------------------------------------------------------------------------

local TukuiOnLogon = CreateFrame("Frame")
TukuiOnLogon:RegisterEvent("PLAYER_ENTERING_WORLD")
TukuiOnLogon:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")	
	
	-- look if our 4 bars are enabled because some people disable them with others UI
	-- even if Tukui have been already installed and they don't know how to restore them.
	local installed = TukuiDataPerChar.install
	if installed then
		local b1, b2, b3, b4 = GetActionBarToggles()
		if (not b1 or not b2 or not b3 or not b4) then
			SetActionBarToggles(1, 1, 1, 1)
			StaticPopup_Show("TUKUI_FIX_AB")
		end
	end

	SetActionBarToggles(1, 1, 1, 1, 0)
	SetCVar("alwaysShowActionBars", 0)	
	
	-- enable or disable grid display
	if C["actionbar"].showgrid == true then
		ActionButton_HideGrid = T.dummy
		for i = 1, 12 do
			local button = _G[format("ActionButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)

			button = _G[format("BonusActionButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
			
			button = _G[format("MultiBarRightButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)

			button = _G[format("MultiBarBottomRightButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
			
			button = _G[format("MultiBarLeftButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
			
			button = _G[format("MultiBarBottomLeftButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
		end
	end
end)


local vehicle = CreateFrame("Button", "TukuiExitVehicleButton", UIParent, "SecureHandlerClickTemplate")
vehicle:CreatePanel("Default", T.buttonsize * 2, T.buttonsize + 1, "BOTTOMRIGHT", TukuiChatRight, "BOTTOMLEFT", -3, 0)
--vehicle:CreatePanel("Default", T.buttonsize * 2, T.buttonsize + 1, "TOPLEFT", TukuiMinimap, "BOTTOMLEFT", 0, -3)
vehicle:RegisterForClicks("AnyUp")
vehicle:SetScript("OnClick", function() VehicleExit() end)
vehicle.text = T.SetFontString(vehicle, unpack(T.Fonts.movers.setfont))
vehicle.text:Point("CENTER", 1, 1)
vehicle.text:SetText(T.cStart .. "Exit")
RegisterStateDriver(vehicle, "visibility", "[target=vehicle,exists] show;hide")
