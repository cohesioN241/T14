local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

if not C["actionbar"].enable then return end

-- � 2011 Ecl�ps�

local TukuiBar1 = TukuiBar1
local TukuiBar2 = TukuiBar2
local TukuiBar3 = TukuiBar3
local TukuiBar4 = TukuiBar4
local TukuiSplitBarLeft = TukuiSplitBarLeft
local TukuiSplitBarRight = TukuiSplitBarRight
local TukuiTukuiRightBar = TukuiTukuiRightBar
local TukuiPetBar = TukuiPetBar

local Toggle = CreateFrame("Frame", "TukuiToggleActionbar", UIParent)

local ToggleText = function(index, text, plus, neg)
	if plus then
		Toggle[index].Text:SetText(text)
		Toggle[index].Text:SetTextColor(.3, .3, .9)
	elseif neg then
		Toggle[index].Text:SetText(text)
		Toggle[index].Text:SetTextColor(.9, .3, .3)
	end
end

local MainBars = function()
	if TukuiSaved.bottomrows == 1 then
		TukuiBar1:Height((T.buttonsize + T.buttonspacing * 2) + 2)
		TukuiSplitBarLeft:Height(TukuiBar1:GetHeight())
		TukuiSplitBarRight:Height(TukuiBar1:GetHeight())
		
		ToggleText(1, "+", true)
		
		TukuiBar2:Hide()
			
		if TukuiSaved.splitbars == true then
			MultiBarLeft:SetParent(TukuiSplitBarLeft)
			for i = 7, 12 do
				local b = _G["MultiBarLeftButton"..i]
				b:SetAlpha(0)
				b:SetScale(0.000001)
			end
		else
			MultiBarLeft:SetParent(TukuiBar3)
		end

	elseif TukuiSaved.bottomrows == 2 then
		TukuiBar1:Height((T.buttonsize * 2 + T.buttonspacing * 3) + 2)
		TukuiSplitBarLeft:Height(TukuiBar1:GetHeight())
		TukuiSplitBarRight:Height(TukuiBar1:GetHeight())
	
		ToggleText(1, "-", false, true)

		TukuiBar2:Show()
		
		if TukuiSaved.splitbars == true then
			MultiBarLeft:SetParent(TukuiSplitBarLeft)
			for i = 7, 12 do
				local b = _G["MultiBarLeftButton"..i]
				b:SetAlpha(1)
				b:SetScale(1)
			end
		else
			MultiBarLeft:SetParent(TukuiBar3)
		end

	end	
	Toggle[4]:Height(TukuiSplitBarLeft:GetHeight())
	Toggle[5]:Height(TukuiSplitBarRight:GetHeight())
end

local RightBars = function()
	if TukuiSaved.rightbars >= 1 then
		TukuiPetBar:ClearAllPoints()
		if C["actionbar"].vertical_rightbars == true then
			if not C["chat"].background then
				TukuiPetBar:Point("RIGHT", TukuiRightBar, "LEFT", -3, 0)
			else
				TukuiPetBar:Point("BOTTOMRIGHT", TukuiRightBar, "BOTTOMLEFT", -3, 0)
			end
		else
			TukuiPetBar:Point("BOTTOMRIGHT", TukuiRightBar, "TOPRIGHT", 0, 3)
		end
	else
		TukuiPetBar:ClearAllPoints()
		if not C["chat"].background then
			TukuiPetBar:Point("RIGHT", UIParent, "RIGHT", -8, 0)
		else
			TukuiPetBar:Point("BOTTOMRIGHT", TukuiChatRight, "TOPRIGHT", 0, 3)
		end
	end

	if TukuiSaved.rightbars == 1 then
		TukuiRightBar:Show()
		TukuiBar4:Hide()

		if C["actionbar"].vertical_rightbars == true then
			TukuiRightBar:Width((T.buttonsize + T.buttonspacing * 2) + 2)
		else
			TukuiRightBar:Height((T.buttonsize + T.buttonspacing * 2) + 2)
		end
		
		if TukuiSaved.splitbars ~= true and TukuiBar3:IsShown() then
			MultiBarLeft:SetParent(TukuiBar3)
			TukuiBar3:Hide()
		end
	elseif TukuiSaved.rightbars == 2 then
		TukuiRightBar:Show()
		TukuiBar4:Show()

		if C["actionbar"].vertical_rightbars == true then
			TukuiRightBar:Width((T.buttonsize * 2 + T.buttonspacing * 3) + 2)
		else
			TukuiRightBar:Height((T.buttonsize * 2 + T.buttonspacing * 3) + 2)
		end
		
		if TukuiSaved.splitbars ~= true and TukuiBar3:IsShown() then
			MultiBarLeft:SetParent(TukuiBar3)
			TukuiBar3:Hide()
		end
	elseif TukuiSaved.rightbars == 3 then
		TukuiRightBar:Show()
		TukuiBar4:Show()

		if C["actionbar"].vertical_rightbars == true then
			TukuiRightBar:Width((T.buttonsize * 3 + T.buttonspacing * 4) + 2)
		else
			TukuiRightBar:Height((T.buttonsize * 3 + T.buttonspacing * 4) + 2)
		end
		
		if TukuiSaved.splitbars ~= true then
			MultiBarLeft:SetParent(TukuiBar3)
			TukuiBar3:Show()
			for i = 1, 12 do
				local b = _G["MultiBarLeftButton"..i]
				local b2 = _G["MultiBarLeftButton"..i-1]
				b:SetSize(T.buttonsize, T.buttonsize)
				b:ClearAllPoints()
				
				if i == 1 then
					b:Point("TOPLEFT", TukuiRightBar, 5, -5)
				else
					if not TukuiSaved.splitbars and C["actionbar"].vertical_rightbars == true then
						b:Point("TOP", b2, "BOTTOM", 0, -T.buttonspacing)
					else
						b:Point("LEFT", b2, "RIGHT", T.buttonspacing, 0)
					end
				end
			end
		end

	elseif TukuiSaved.rightbars == 0 then
		TukuiRightBar:Hide()
		TukuiBar4:Hide()

		if TukuiSaved.splitbars ~= true then
			MultiBarLeft:SetParent(TukuiBar3)
			TukuiBar3:Hide()
		end			
	end
end

local SplitBars = function()
	if TukuiSaved.splitbars == true then
		MultiBarLeft:SetParent(TukuiSplitBarLeft)
		for i = 1, 12 do
			local b = _G["MultiBarLeftButton"..i]
			local b2 = _G["MultiBarLeftButton"..i-1]
			b:ClearAllPoints()
			if i == 1 then
				b:Point("BOTTOMLEFT", TukuiSplitBarLeft, 5, 5)
			else
				if i == 4 then
					b:Point("BOTTOMLEFT", TukuiSplitBarRight, 5, 5)
				elseif i == 7 then
					b:Point("BOTTOMLEFT", _G["MultiBarLeftButton1"], "TOPLEFT", 0, T.buttonspacing)
				elseif i == 10 then
					b:Point("BOTTOMLEFT", _G["MultiBarLeftButton4"], "TOPLEFT", 0, T.buttonspacing)
				else
					b:Point("LEFT", b2, "RIGHT", T.buttonspacing, 0)
				end
			end
		end
		
		if TukuiSaved.rightbars == 3 then
			TukuiRightBar:Show()
			if C["actionbar"].vertical_rightbars == true then
				TukuiRightBar:Width((T.buttonsize * 2 + T.buttonspacing * 3) + 2)
			else
				TukuiRightBar:Height((T.buttonsize * 2 + T.buttonspacing * 3) + 2)
			end
		end

		for i = 7, 12 do
			if TukuiSaved.bottomrows == 1 then
				local b = _G["MultiBarLeftButton"..i]
				b:SetAlpha(0)
				b:SetScale(0.000001)
			elseif TukuiSaved.bottomrows == 2 then
				local b = _G["MultiBarLeftButton"..i]
				b:SetAlpha(1)	
				b:SetScale(1)
			end
		end
		TukuiSplitBarLeft:Show()
		TukuiSplitBarRight:Show()
	
		Toggle[4]:ClearAllPoints(); Toggle[5]:ClearAllPoints()
		Toggle[4]:Point("BOTTOMRIGHT", TukuiSplitBarLeft, "BOTTOMLEFT", -3, 0)
		Toggle[5]:Point("BOTTOMLEFT", TukuiSplitBarRight, "BOTTOMRIGHT", 3, 0)
		
		ToggleText(4, ">", false, true)
		ToggleText(5, "<", false, true)

	elseif TukuiSaved.splitbars == false then
		MultiBarLeft:SetParent(TukuiBar3)

		for i = 1, 12 do
			local b = _G["MultiBarLeftButton"..i]
			local b2 = _G["MultiBarLeftButton"..i-1]
			b:ClearAllPoints()
			if i == 1 then
				b:Point("TOPLEFT", TukuiRightBar, 5, -5)
			else
				b:Point("LEFT", b2, "RIGHT", T.buttonspacing, 0)
			end
		end
		
		Toggle[4]:ClearAllPoints(); Toggle[5]:ClearAllPoints()
		Toggle[4]:Point("BOTTOMRIGHT", TukuiBar1, "BOTTOMLEFT", -3, 0)
		Toggle[5]:Point("BOTTOMLEFT", TukuiBar1, "BOTTOMRIGHT", 3, 0)
		
		ToggleText(4, "<", true)
		ToggleText(5, ">", true)

		RightBars()

		for i = 7, 12 do
			local b = _G["MultiBarLeftButton"..i]
			b:SetAlpha(1)	
			b:SetScale(1)
		end

		TukuiSplitBarLeft:Hide()
		TukuiSplitBarRight:Hide()
	end
end

local function LockCheck(index)
	if TukuiSaved.actionbarsLocked == true then
		Toggle[index].Text:SetText("|cff50e468Unlock")
	elseif TukuiSaved.actionbarsLocked == false then
		Toggle[index].Text:SetText("|cffe45050Lock")
	end
end

for i = 1, 6 do
	Toggle[i] = CreateFrame("Frame", "TukuiToggle"..i, Toggle)
	Toggle[i]:EnableMouse(true)
	Toggle[i]:SetAlpha(0)
	Toggle[i]:CreateBorder(true, false)
	
	Toggle[i].Text = Toggle[i]:CreateFontString(nil, "OVERLAY")
	Toggle[i].Text:SetFont(C["media"].pixel_font, 12, "MONOCHROMEOUTLINE")
	Toggle[i].Text:Point("CENTER", 2, 1)
		
	if i == 1 then
		Toggle[i]:CreatePanel("Default", TukuiBar1:GetWidth(), T.buttonsize / 2, "BOTTOM", TukuiBar1, "TOP", 0, 3)

		Toggle[i]:SetScript("OnMouseDown", function()
			if InCombatLockdown() then return end

			TukuiSaved.bottomrows = TukuiSaved.bottomrows + 1

			if TukuiSaved.bottomrows > 2 then
				TukuiSaved.bottomrows = 1
			end
			
			MainBars()
		end)
		Toggle[i]:SetScript("OnEvent", MainBars)
	elseif i == 2 then
		Toggle[i]:CreatePanel("Default", T.buttonsize, TukuiTabsRight:GetHeight() - 6, "RIGHT", TukuiTabsRight, "RIGHT", -3, 0)
		Toggle[i]:SetFrameLevel(TukuiTabsRight:GetFrameLevel() + 1)
		
		if C["actionbar"].vertical_rightbars then
			ToggleText(i, ">", false, true)
		else
			ToggleText(i, "-", false, true)
		end

		Toggle[i]:SetScript("OnMouseDown", function()
			if InCombatLockdown() then return end

			TukuiSaved.rightbars = TukuiSaved.rightbars - 1

			if TukuiSaved.splitbars == true and TukuiSaved.rightbars > 2 then
				TukuiSaved.rightbars = 1
			elseif TukuiSaved.rightbars < 0 then
				if TukuiSaved.splitbars == true then
					TukuiSaved.rightbars = 2
				else
					TukuiSaved.rightbars = 3
				end
			end
			RightBars()
		end)
		Toggle[i]:SetScript("OnEvent", RightBars)	
	elseif i == 3 then
		Toggle[i]:CreatePanel("Default", Toggle[i-1]:GetWidth(), Toggle[i-1]:GetHeight(), "TOPRIGHT", Toggle[i-1], "TOPLEFT", -3, 0)
		Toggle[i]:SetFrameLevel(Toggle[i-1]:GetFrameLevel())
		
		if C["actionbar"].vertical_rightbars then
			ToggleText(i, "<", true, false)
		else
			ToggleText(i, "+", true, false)
		end

		Toggle[i]:SetScript("OnMouseDown", function()
			if InCombatLockdown() then return end

			TukuiSaved.rightbars = TukuiSaved.rightbars + 1
			
			if TukuiSaved.splitbars == true and TukuiSaved.rightbars > 2 then
				TukuiSaved.rightbars = 0
			elseif TukuiSaved.rightbars > 3 then
				TukuiSaved.rightbars = 0
			end

			RightBars()
		end)
		Toggle[i]:SetScript("OnEvent", RightBars)
	elseif i == 4 then
		Toggle[i]:CreatePanel("Default", T.buttonsize / 2, TukuiSplitBarLeft:GetHeight(), "BOTTOMRIGHT", TukuiSplitBarLeft, "BOTTOMLEFT", -3, 0)
	elseif i == 5 then
		Toggle[i]:CreatePanel("Default", T.buttonsize / 2, TukuiSplitBarRight:GetHeight(), "BOTTOMLEFT", TukuiSplitBarRight, "BOTTOMRIGHT", 3, 0)
	elseif i == 6 then
		Toggle[i]:CreatePanel("Default", 50, TukuiInfoLeft:GetHeight(), "BOTTOMRIGHT", TukuiInfoRight, "TOPRIGHT", 0, 3)
	
		Toggle[i]:SetScript("OnMouseDown", function()	
			if InCombatLockdown() then return end
			
			if TukuiSaved.actionbarsLocked == true then
				TukuiSaved.actionbarsLocked = false
				print(L.actionbars_unlocked)
			elseif TukuiSaved.actionbarsLocked == false then
				TukuiSaved.actionbarsLocked = true
				print(L.actionbars_locked)
			end

			LockCheck(i)
		end)

		Toggle[i]:SetScript("OnEvent", function()
			LockCheck(i)
		end)
	end
	
	if i == 4 or i == 5 then
		Toggle[i]:SetScript("OnMouseDown", function()
			if InCombatLockdown() then return end

			if TukuiSaved.splitbars == false then
				TukuiSaved.splitbars = true
			elseif TukuiSaved.splitbars == true then
				TukuiSaved.splitbars = false
			end
			SplitBars()
		end)
		Toggle[i]:SetScript("OnEvent", SplitBars)
	end
	Toggle[i]:RegisterEvent("PLAYER_ENTERING_WORLD")
	Toggle[i]:RegisterEvent("PLAYER_REGEN_DISABLED")
	Toggle[i]:RegisterEvent("PLAYER_REGEN_ENABLED")
	
	Toggle[i]:SetScript("OnEnter", function()
		if InCombatLockdown() then return end
		Toggle[i]:FadeIn()
	end)

	Toggle[i]:SetScript("OnLeave", function()
		Toggle[i]:FadeOut()
	end)
	
	Toggle[i]:SetScript("OnUpdate", function() 
		if TukuiSaved.actionbarsLocked == true then
			for i = 1, 5 do
				Toggle[i]:EnableMouse(false)
			end
		elseif TukuiSaved.actionbarsLocked == false then
			for i = 1, 5 do
				Toggle[i]:EnableMouse(true)
			end
		end
	end)		
end