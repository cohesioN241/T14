local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "Tukui was unable to locate oUF install.")

ns._Objects = {}
ns._Headers = {}

local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

if not C["unitframes"].enable == true then return end
if C["unitframes"].style ~= "Eclipse" then return end

if T.lowversion then
	T.Player, T.Target, T.ToT, T.Pet, T.Focus, T.Boss = 182, 182, 182, 182, 130, 200
else
	T.Player, T.Target, T.ToT, T.Pet, T.Focus, T.Boss = 225, 225, 130, 130, 115, 200
end

------------------------------------------------------------------------
--	Layout
------------------------------------------------------------------------

local function Shared(self, unit)
	-- set our own colors
	self.colors = T.UnitColor
	
	-- register click
	self:RegisterForClicks("AnyUp")
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	-- menu? lol
	self.menu = T.SpawnMenu
	
	------------------------------------------------------------------------
	--	Features we want for all units at the same time
	------------------------------------------------------------------------
	
	-- here we create an invisible frame for all element we want to show over health/power.
	local InvFrame = CreateFrame("Frame", nil, self)
	InvFrame:SetFrameStrata("HIGH")
	InvFrame:SetFrameLevel(5)
	InvFrame:SetAllPoints()
	
	-- symbols, now put the symbol on the frame we created above.
	local RaidIcon = InvFrame:CreateTexture(nil, "OVERLAY")
	RaidIcon:SetTexture("Interface\\AddOns\\Tukui\\media\\textures\\raidicons.blp") -- thx hankthetank for texture
	RaidIcon:SetHeight(20)
	RaidIcon:SetWidth(20)
	RaidIcon:SetPoint("TOP", 0, 11)
	self.RaidIcon = RaidIcon
	
	
	-- health
	local health = CreateFrame('StatusBar', nil, self)
	health:SetPoint("TOPLEFT")
	health:SetPoint("TOPRIGHT")
	health:SetStatusBarTexture(unpack(T.Textures.statusBars))
	health:SetFrameLevel(2)
	health:SetFrameStrata("LOW")
	self.Health = health

	local healthBG = health:CreateTexture(nil, 'BORDER')
	healthBG:SetAllPoints()
	self.Health.bg = healthBG

	health:CreateBorder(false, true)
	
	-- power
	local power = CreateFrame('StatusBar', nil, self)
	power:Point("TOPLEFT", health, "BOTTOMLEFT", 0, -3)
	power:Point("TOPRIGHT", health, "BOTTOMRIGHT", 0, -3)
	power:SetStatusBarTexture(unpack(T.Textures.statusBars))
	self.Power = power

	local powerBG = power:CreateTexture(nil, 'BORDER')
	powerBG:SetAllPoints(power)
	powerBG:SetTexture(unpack(T.Textures.statusBars))
	powerBG.multiplier = 0.3
	self.Power.bg = powerBG
	
	power:CreateBorder(false, true)

	-- colors
		health.frequentUpdates = true
		power.frequentUpdates = true
		power.colorDisconnected = true

		if C["unitframes"].showsmooth == true then
			health.Smooth = true
			power.Smooth = true
		end
		
		if C["unitframes"].unicolor == true then
			health.colorTapping = false
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(unpack(C["unitframes"].healthColor))
			healthBG:SetTexture(1, 1, 1)
			healthBG:SetVertexColor(unpack(C["unitframes"].healthBgColor))	
			
			power.colorTapping = true
			power.colorDisconnected = true
			power.colorClass = true
			power.colorReaction = true
		else
			healthBG:SetTexture(.1, .1, .1)

			health.colorTapping = true
			health.colorDisconnected = true
			health.colorReaction = true
			health.colorClass = true
			if T.myclass == "HUNTER" then
				health.colorHappiness = true
			end
		
			power.colorPower = true
		end

	-- unitframe bg
	local ufbg = CreateFrame("Frame", nil, self)
	ufbg:SetFrameLevel(health:GetFrameLevel() - 1)
	ufbg:SetFrameStrata(health:GetFrameStrata())
	ufbg:Point("TOPLEFT", health, -2, 2)
	ufbg:Point("BOTTOMRIGHT", power, 2, -2)
	ufbg:SetBackdrop({
		bgFile = C["media"].blank,
		insets = { left = -T.mult, right = -T.mult, top = -T.mult, bottom = -T.mult }
	})
	ufbg:SetBackdropColor(unpack(C["media"].bordercolor))
	ufbg:CreateBorder(false, true)
	ufbg:CreateShadow("Default")
	self.ufbg = ufbg		

	-- create a panel
	local panel = CreateFrame("Frame", nil, self)
	if (unit == "player" or unit == "target") or (not T.lowversion and unit == "pet" or not T.lowversion and unit == "targettarget") then
		panel:CreatePanel("Default", 1, 19, "TOPLEFT", ufbg, "BOTTOMLEFT", 0, -3)
		if T.lowversion then
			panel:Height(17)
		end
		panel:Point("TOPRIGHT", ufbg, "BOTTOMRIGHT", 0, -3)
		panel:SetBackdropBorderColor(unpack(C["media"].bordercolor))
		self.panel = panel
	end
		
	-- castbar of player and target
	local castbar = CreateFrame("StatusBar", self:GetName().."CastBar", self)
	castbar:SetStatusBarTexture(unpack(T.Textures.statusBars))

	local castbarBG = CreateFrame("Frame", nil, castbar)
	castbarBG:CreatePanel("Default", 1, 1, "CENTER")
	castbarBG:ClearAllPoints()
	castbarBG:SetPoint("TOPLEFT", -2, 2)
	castbarBG:SetPoint("BOTTOMRIGHT", 2, -2)
	
	castbar.CustomTimeText = T.CustomCastTimeText
	castbar.CustomDelayText = T.CustomCastDelayText
	castbar.PostCastStart = T.CheckCast
	castbar.PostChannelStart = T.CheckChannel

	castbar.time = T.SetFontString(castbar, unpack(T.Fonts.uGeneral.setfont))
	castbar.time:SetTextColor(1, 1, 1)

	castbar.Text = T.SetFontString(castbar, unpack(T.Fonts.uGeneral.setfont))
	castbar.Text:SetTextColor(1, 1, 1)

	if C["unitframes"].cbicons == true then
		castbar.button = CreateFrame("Frame", nil, castbar)
		if (unit == "player") then
			castbar.button:Size(T.buttonsize, T.buttonsize)
		elseif (unit == "target") then
			if T.lowversion then
				castbar.button:Size(T.buttonsize + 4, T.buttonsize + 4)
			else
				castbar.button:Size(T.buttonsize + 11, T.buttonsize + 11)
			end
		end
		castbar.button:SetTemplate("Default")
		castbar.button:CreateShadow("Default")

		castbar.icon = castbar.button:CreateTexture(nil, "ARTWORK")
		castbar.icon:Point("TOPLEFT", castbar.button, 2, -2)
		castbar.icon:Point("BOTTOMRIGHT", castbar.button, -2, 2)
		castbar.icon:SetTexCoord(.09, .91, .09, .91)
	end
	self.Castbar = castbar
	self.Castbar.Time = castbar.time
	self.Castbar.Icon = castbar.icon
	
	-- spark
	castbar.Spark = castbar:CreateTexture(nil, 'OVERLAY')
	castbar.Spark:SetWidth(15)
	castbar.Spark:SetBlendMode('ADD')

	------------------------------------------------------------------------
	--	Player and Target units layout (mostly mirror'd)
	------------------------------------------------------------------------
	
	if (unit == "player" or unit == "target") then

		-- health bar
		if T.lowversion then
			health:Height(22)
		else
			health:Height(29)
		end
		power:Height(5)
	
		health.value = T.SetFontString(panel, unpack(T.Fonts.uHealth.setfont))
		health.value:Point("RIGHT", panel, "RIGHT", -4, 1)
		health.PostUpdate = T.PostUpdateHealth

		power.value = T.SetFontString(panel, unpack(T.Fonts.uPower.setfont))
		power.value:Point("LEFT", panel, "LEFT", 7, 1)
		power.PreUpdate = T.PreUpdatePower
		power.PostUpdate = T.PostUpdatePower
	
		-- portraits
		if (C["unitframes"].charportrait == true) then
			local portrait = CreateFrame("PlayerModel", self:GetName().."_Portrait", self)
			portrait:Height( ((health:GetHeight()) + (power:GetHeight() + 4) + (panel:GetHeight()) + 6))
			portrait:SetWidth(portrait:GetHeight())
			portrait:SetAlpha(1)
			portrait:SetFrameLevel(0)
			portrait:SetFrameStrata("BACKGROUND")
			portrait:SetTemplate("Transparent")

			if unit == "player" then
				if T.myclass == "DRUID" then
					portrait:Point("BOTTOMRIGHT", panel, "BOTTOMLEFT", -3, 0)
				else
					portrait:Point("TOPRIGHT", ufbg, "TOPLEFT", -3, 0)
				end
			elseif unit == "target" then
				portrait:Point("TOPLEFT", ufbg, "TOPRIGHT", 3, 0)
			end

			table.insert(self.__elements, T.HidePortrait)
			portrait.PostUpdate = T.PortraitUpdate --Worgen Fix (Hydra)
			self.Portrait = portrait
			
			local portraitBG = CreateFrame("Frame", nil, portrait)
			portraitBG:CreatePanel("Transparent", 1, 1, "CENTER")
			portraitBG:SetAllPoints()
			portraitBG:SetBackdropColor(0, 0, 0, 0)
			self.Portrait.bg = portraitBG
		end
		
		--[[ leaving here just in case someone want to use it, we now use our own Alt Power Bar.
		-- alt power bar
		local AltPowerBar = CreateFrame("StatusBar", self:GetName().."_AltPowerBar", self.Health)
		AltPowerBar:SetFrameLevel(0)
		AltPowerBar:SetFrameStrata("LOW")
		AltPowerBar:SetHeight(5)
		AltPowerBar:SetStatusBarTexture(C.media.unpack(T.Textures.statusBars))
		AltPowerBar:GetStatusBarTexture():SetHorizTile(false)
		AltPowerBar:SetStatusBarColor(163/255,  24/255,  24/255)
		AltPowerBar:EnableMouse(true)

		AltPowerBar:Point("LEFT", TukuiInfoLeft, 2, -2)
		AltPowerBar:Point("RIGHT", TukuiInfoLeft, -2, 2)
		AltPowerBar:Point("TOP", TukuiInfoLeft, 2, -2)
		AltPowerBar:Point("BOTTOM", TukuiInfoLeft, -2, 2)
		
		AltPowerBar:SetBackdrop({
			bgFile = C["media"].blank, 
			edgeFile = C["media"].blank, 
			tile = false, tileSize = 0, edgeSize = 1, 
			insets = { left = 0, right = 0, top = 0, bottom = T.Scale(-1)}
		})
		AltPowerBar:SetBackdropColor(0, 0, 0)

		self.AltPowerBar = AltPowerBar
		--]]
		
		if (unit == "player") then
			-- combat icon
			local Combat = health:CreateTexture(nil, "OVERLAY")
			Combat:Height(19)
			Combat:Width(19)
			Combat:SetPoint("LEFT",0,1)
			Combat:SetVertexColor(0.69, 0.31, 0.31)
			self.Combat = Combat

			-- custom info (low mana warning)
			FlashInfo = CreateFrame("Frame", "TukuiFlashInfo", self)
			FlashInfo:SetScript("OnUpdate", T.UpdateManaLevel)
			FlashInfo.parent = self
			FlashInfo:SetAllPoints(panel)
			FlashInfo.ManaLevel = T.SetFontString(FlashInfo, unpack(T.Fonts.uGeneral.setfont))
			FlashInfo.ManaLevel:SetPoint("CENTER", panel, "CENTER", 0, 1)
			self.FlashInfo = FlashInfo
			
			-- pvp status text
			local status = T.SetFontString(panel, unpack(T.Fonts.uGeneral.setfont))
			status:SetPoint("CENTER", panel, "CENTER", 0, 1)
			status:SetTextColor(0.69, 0.31, 0.31)
			status:Hide()
			self.Status = status
			
			-- show druid mana when shapeshifted in bear, cat or whatever
			if T.myclass == "DRUID" then
				ufbg:Point("TOPLEFT", health, -2, 10)
				ufbg:Point("BOTTOMRIGHT", power, 2, -2)
				local DruidManaUpdate = CreateFrame("Frame")
				DruidManaUpdate:SetScript("OnUpdate", function() T.UpdateDruidManaText(self) end)
				local DruidManaText = T.SetFontString(health, unpack(T.Fonts.uPower.setfont))
				DruidManaText:SetTextColor(1, 0.49, 0.04)
				self.DruidManaText = DruidManaText

				local DruidManaBackground = CreateFrame("Frame", nil, self)
				DruidManaBackground:Point("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
				if T.lowversion then
					DruidManaBackground:Width(T.Player)
				else
					DruidManaBackground:Width(T.Player)
				end
				DruidManaBackground:Height(5)
				DruidManaBackground:SetFrameLevel(8)
				DruidManaBackground:SetFrameStrata("MEDIUM")
				DruidManaBackground:SetTemplate("Default")
				DruidManaBackground:SetBackdropBorderColor(0,0,0,0)

				local DruidManaBarStatus = CreateFrame('StatusBar', nil, DruidManaBackground)
				DruidManaBarStatus:SetPoint('LEFT', DruidManaBackground, 'LEFT', 0, 0)
				DruidManaBarStatus:SetSize(DruidManaBackground:GetWidth(), DruidManaBackground:GetHeight())
				DruidManaBarStatus:SetStatusBarTexture(normTex)
				DruidManaBarStatus:SetStatusBarColor(.30, .52, .90)

				DruidManaBarStatus:SetScript("OnShow", function() T.DruidBarDisplay(self, false) end)
				DruidManaBarStatus:SetScript("OnUpdate", function() T.DruidBarDisplay(self, true) end) -- just forcing 1 update on login for buffs/shadow/etc.
				DruidManaBarStatus:SetScript("OnHide", function() T.DruidBarDisplay(self, false) end)

				self.DruidManaBackground = DruidManaBackground
				self.DruidMana = DruidManaBarStatus
			end
			
			if C["unitframes"].classbar then
				if T.myclass == "DRUID" and C["unitframes"].druid then
					-- DRUID MANA BAR
					local DruidManaBackground = CreateFrame("Frame", nil, self)
					--DruidManaBackground:Point("BOTTOMLEFT", self, "TOPLEFT", 0, 1)
					DruidManaBackground:Point("BOTTOMLEFT", health, "TOPLEFT", 0, 3)
					DruidManaBackground:Point("BOTTOMRIGHT", health, "TOPRIGHT", 0, 3)
					if T.lowversion then
						DruidManaBackground:Width(T.Player)
					else
						DruidManaBackground:Width(T.Player)
					end
					DruidManaBackground:Height(5)
					DruidManaBackground:SetFrameLevel(8)
					DruidManaBackground:SetFrameStrata("MEDIUM")
					DruidManaBackground:SetTemplate("Default")
					DruidManaBackground:SetBackdropBorderColor(0,0,0,0)

					local DruidManaBarStatus = CreateFrame('StatusBar', nil, DruidManaBackground)
					DruidManaBarStatus:SetPoint('LEFT', DruidManaBackground, 'LEFT', 0, 0)
					DruidManaBarStatus:SetSize(DruidManaBackground:GetWidth(), DruidManaBackground:GetHeight())
					DruidManaBarStatus:SetStatusBarTexture(C["media"].blank)
					DruidManaBarStatus:SetStatusBarColor(.30, .52, .90)

					DruidManaBarStatus:SetScript("OnShow", function() T.DruidBarDisplay(self, false) end)
					DruidManaBackground:SetScript("OnUpdate", function() T.DruidBarDisplay(self, true) end) -- just forcing 1 update on login for buffs/shadow/etc.
					DruidManaBarStatus:SetScript("OnHide", function() T.DruidBarDisplay(self, false) end)

					self.DruidManaBackground = DruidManaBackground
					self.DruidMana = DruidManaBarStatus
					
					-- ECLIPSE BAR
					local eclipseBar = CreateFrame('Frame', nil, self)
					eclipseBar:Point("LEFT", health, "TOPLEFT", 10, 1)
					if T.lowversion then
						eclipseBar:Size(102, 6)
					else
						eclipseBar:Size(150, 6)
					end
					eclipseBar:SetBackdropBorderColor(0,0,0,0)
					eclipseBar:SetScript("OnShow", function() T.DruidBarDisplay(self, false) end)
					eclipseBar:SetScript("OnHide", function() T.DruidBarDisplay(self, false) end)
					eclipseBar:SetFrameLevel(health: GetFrameLevel() + 2)
					eclipseBar:SetFrameStrata(health:GetFrameStrata())

					local eclipseBarBG = CreateFrame("Frame", nil, eclipseBar)
					eclipseBarBG:CreatePanel("Default", 1, 1, "TOPLEFT", -2, 2)
					eclipseBarBG:Point("BOTTOMRIGHT", 2, -2)
					eclipseBarBG:SetFrameLevel(eclipseBar: GetFrameLevel())
					eclipseBarBG:SetFrameStrata(eclipseBar:GetFrameStrata())
					eclipseBarBG.shadow:SetFrameStrata("BACKGROUND")

					local lunarBar = CreateFrame('StatusBar', nil, eclipseBar)
					lunarBar:SetPoint('LEFT', eclipseBar, 'LEFT', 0, 0)
					lunarBar:SetSize(eclipseBar:GetWidth(), eclipseBar:GetHeight())
					lunarBar:SetStatusBarTexture(unpack(T.Textures.statusBars))
					lunarBar:SetStatusBarColor(.50, .52, .70)
					eclipseBar.LunarBar = lunarBar

					local solarBar = CreateFrame('StatusBar', nil, eclipseBar)
					solarBar:SetPoint('LEFT', lunarBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
					solarBar:SetSize(eclipseBar:GetWidth(), eclipseBar:GetHeight())
					solarBar:SetStatusBarTexture(unpack(T.Textures.statusBars))
					solarBar:SetStatusBarColor(.80, .82,  .60)
					eclipseBar.SolarBar = solarBar

					local eclipseBarText = eclipseBar:CreateFontString(nil, 'OVERLAY')
					eclipseBarText:SetPoint('TOP', panel)
					eclipseBarText:SetPoint('BOTTOM', panel)
					eclipseBarText:SetFont(unpack(T.Fonts.uGeneral.setfont))
					eclipseBar.PostUpdatePower = T.EclipseDirection
					
					-- hide "low mana" text on load if eclipseBar is show
					if eclipseBar and eclipseBar:IsShown() then FlashInfo.ManaLevel:SetAlpha(0) end

					self.EclipseBar = eclipseBar
					self.EclipseBar.Text = eclipseBarText
				end

				-- set holy power bar or shard bar
				if (T.myclass == "WARLOCK" and C["unitframes"].warlock) or (T.myclass == "PALADIN" and C["unitframes"].paladin) then		
					local bars = CreateFrame("Frame", nil, self)
					bars:CreatePanel("Default", 150, 9, "LEFT", health, "TOPLEFT", 10, 1)
					if T.lowversion then
						bars:Width(102)
					end
					bars:SetFrameLevel(health: GetFrameLevel() + 2)
					bars:SetFrameStrata(health:GetFrameStrata())
					bars.shadow:SetFrameStrata("BACKGROUND")
					
					for i = 1, 3 do					
						bars[i]=CreateFrame("StatusBar", self:GetName().."_Shard"..i, self)
						bars[i]:Height(bars:GetHeight() - 4)
						bars[i]:Width(bars:GetWidth() / 3 - 2)
						
						bars[i]:SetStatusBarTexture(unpack(T.Textures.statusBars))
						bars[i]:GetStatusBarTexture():SetHorizTile(false)
						bars[i]:SetFrameLevel(bars:GetFrameLevel())
						bars[i]:SetFrameStrata(bars:GetFrameStrata())
						
						bars[i].bg = bars[i]:CreateTexture(nil, 'BORDER')
						bars[i].bg:SetAllPoints(bars[i])
						bars[i].bg:SetTexture(unpack(T.Textures.statusBars))					
						bars[i].bg:SetAlpha(.15)

						if T.myclass == "WARLOCK" then
							bars[i]:SetStatusBarColor(255/255,163/255,255/255)
							bars[i].bg:SetTexture(255/255,163/255,255/255)
						elseif T.myclass == "PALADIN" then
							bars[i]:SetStatusBarColor(255/255,253/255,173/255)
							bars[i].bg:SetTexture(255/255,253/255,173/255)
						end
						
						if i == 1 then
							bars[i]:SetPoint("TOPLEFT", bars, 2, -2)
						else
							bars[i]:Point("LEFT", bars[i-1], "RIGHT", 1, 0)
						end
					end
					
					if T.myclass == "WARLOCK" then
						bars.Override = T.UpdateShards				
						self.SoulShards = bars
					elseif T.myclass == "PALADIN" then
						bars.Override = T.UpdateHoly
						self.HolyPower = bars
					end
				end

				-- deathknight runes
				if T.myclass == "DEATHKNIGHT" and C["unitframes"].deathknight then
					
					local Runes = CreateFrame("Frame", nil, self)
					Runes:CreatePanel("Default", T.Player - 18, 9, "LEFT", health, "TOPLEFT", 9, 1)
					if T.lowversion then
						Runes:SetWidth(T.Player - 23)
						Runes:Point("LEFT", health, "TOPLEFT", 11, 1)
					end
					Runes:SetFrameLevel(health: GetFrameLevel() + 2)
					Runes:SetFrameStrata(health:GetFrameStrata())
					Runes.shadow:SetFrameStrata("BACKGROUND")
					

					for i = 1, 6 do
						Runes[i] = CreateFrame("StatusBar", self:GetName().."_Runes"..i, health)
						Runes[i]:Height(Runes:GetHeight() - 4)
						Runes[i]:Width((T.Player / 6) - 5)
						Runes[i]:SetFrameLevel(Runes:GetFrameLevel())
						Runes[i]:SetFrameStrata(Runes:GetFrameStrata())

						if (i == 1) then
							Runes[i]:Point("TOPLEFT", Runes, 2, -2)
						else
							Runes[i]:Point("LEFT", Runes[i-1], "RIGHT", 1, 0)
						end
						Runes[i]:SetStatusBarTexture(unpack(T.Textures.statusBars))
						Runes[i]:GetStatusBarTexture():SetHorizTile(false)
					end

					self.Runes = Runes
				end
				
				-- shaman totem bar
				if T.myclass == "SHAMAN" and C["unitframes"].shaman then				
					local TotemBar = {}
					TotemBar.Destroy = true
					
					local TotemBarBG = CreateFrame("Frame", "TotemBarBG", self)
					TotemBarBG:CreatePanel("Default", T.Player - 15, 9, "LEFT", health, "TOPLEFT", 7, 1)
					if T.lowversion then
						TotemBarBG:SetWidth(T.Player - 20)
						TotemBarBG:Point("LEFT", health, "TOPLEFT", 10, 1)
					end
					TotemBarBG:SetFrameLevel(health: GetFrameLevel() + 2)
					TotemBarBG:SetFrameStrata(health:GetFrameStrata())
					TotemBarBG.shadow:SetFrameStrata("BACKGROUND")
					
					for i = 1, 4 do
						TotemBar[i] = CreateFrame("StatusBar", self:GetName().."_TotemBar"..i, health)
						TotemBar[i]:Height(TotemBarBG:GetHeight() -4)
						if T.lowversion then
							TotemBar[i]:SetWidth((T.Player / 4) - 6.8)
						else
							TotemBar[i]:SetWidth((T.Player / 4) - 5.5)
						end
						TotemBar[i]:SetFrameLevel(TotemBarBG:GetFrameLevel() + 1)
						TotemBar[i]:SetFrameStrata(TotemBarBG:GetFrameStrata())
						
						if (i == 1) then
						   TotemBar[i]:Point("TOPLEFT", TotemBarBG, 2, -2)
						else
						   TotemBar[i]:Point("LEFT", TotemBar[i-1], "RIGHT", 1, 0)
						end
						TotemBar[i]:SetStatusBarTexture(unpack(T.Textures.statusBars))
						TotemBar[i]:SetMinMaxValues(0, 1)

						TotemBar[i].bg = TotemBar[i]:CreateTexture(nil, "BORDER")
						TotemBar[i].bg:SetAllPoints(TotemBar[i])
						TotemBar[i].bg:SetTexture(unpack(T.Textures.statusBars))
						TotemBar[i].bg.multiplier = 0.3
					end
					self.TotemBar = TotemBar
				end
			end
			
			-- script for pvp status and low mana
			self:SetScript("OnEnter", function(self)
				if self.EclipseBar and self.EclipseBar:IsShown() then 
					self.EclipseBar.Text:Hide()
				end
				FlashInfo.ManaLevel:Hide()
				status:Show()
				UnitFrame_OnEnter(self)
				if UnitIsPVP("Player") then
					status:SetText("PvP")
				else
					status:SetText("")
				end
			end)
			self:SetScript("OnLeave", function(self) 
				if self.EclipseBar and self.EclipseBar:IsShown() then 
					self.EclipseBar.Text:Show()
				end
				FlashInfo.ManaLevel:Show()
				status:Hide()
				UnitFrame_OnLeave(self) 
			end)
		end
		
		if (unit == "target") then			
			-- Unit name on target
			local Name = health:CreateFontString(nil, "OVERLAY")
			Name:Point("LEFT", panel, "LEFT", 4, 1)
			Name:SetJustifyH("LEFT")
			Name:SetFont(unpack(T.Fonts.uName.setfont))

			self:Tag(Name, '[Tukui:getnamecolor][Tukui:name_medium] [Tukui:diffcolor][level] [shortclassification]')
			self.Name = Name
			
			-- standard combo points on target if classbar is disabled
			if C["unitframes"].classiccombo then
				local CPoints = {}
				CPoints.unit = PlayerFrame.unit
				for i = 1, 5 do
					CPoints[i] = self:CreateTexture(nil, "OVERLAY")
					CPoints[i]:Height(12)
					CPoints[i]:Width(12)
					CPoints[i]:SetTexture(bubbleTex)
					if i == 1 then
						if T.lowversion then
							CPoints[i]:Point("TOPRIGHT", 15, 1.5)
						else
							CPoints[i]:Point("TOPLEFT", -15, 1.5)
						end
						CPoints[i]:SetVertexColor(0.69, 0.31, 0.31)
					else
						CPoints[i]:Point("TOP", CPoints[i-1], "BOTTOM", 1)
					end
				end
				CPoints[2]:SetVertexColor(0.69, 0.31, 0.31)
				CPoints[3]:SetVertexColor(0.65, 0.63, 0.35)
				CPoints[4]:SetVertexColor(0.65, 0.63, 0.35)
				CPoints[5]:SetVertexColor(0.33, 0.59, 0.33)
				self.CPoints = CPoints
 			end
		end

		if (unit == "target" and C["unitframes"].targetauras) then
			local buffs = CreateFrame("Frame", nil, self)
			local debuffs = CreateFrame("Frame", nil, self)
			
			buffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
			
			local bs = 26
			local bh = 0
			local bn = 0
			if C["unitframes"].buffrows == 1 then
				bh = bs
				bn = 7
			else
				bh = bs * 2 + 3
				bn = 14
			end
			
			local ds = bs
			local dh = ds
			local dn = 0
			if C["unitframes"].debuffrows == 3 then
				dh = ds * 3 + 6
				dn = 21
			elseif C["unitframes"].debuffrows == 2 then
				dh = ds * 2 + 3
				dn = 14
			elseif C["unitframes"].debuffrows == 1 then
				dh = ds
				dn = 7
			end

			if T.lowversion then
				buffs:SetHeight(bh)
				buffs:SetWidth(186)
				buffs.size = bs - 2
				buffs.num = bn

				debuffs:SetHeight(dh)
				debuffs:SetWidth(186)
				debuffs:Point("BOTTOMRIGHT", buffs, "TOPRIGHT", 0, -1)
				debuffs.size = ds - 2
				debuffs.num = dn
			else				
				buffs:SetHeight(bh)
				buffs:SetWidth(220)
				buffs.size = bs
				buffs.num = bn + 2
				
				debuffs:SetHeight(dh)
				debuffs:SetWidth(220)
				debuffs:Point("BOTTOMRIGHT", buffs, "TOPRIGHT", 9, 3)
				debuffs.size = ds
				debuffs.num = dn + 2
			end

			buffs.spacing = 3
			buffs.initialAnchor = "BOTTOMLEFT"
			buffs.PostCreateIcon = T.PostCreateAura
			buffs.PostUpdateIcon = T.PostUpdateAura
			self.Buffs = buffs	

			debuffs.spacing = 3
			debuffs.initialAnchor = "BOTTOMRIGHT"
			debuffs["growth-y"] = "UP"
			debuffs["growth-x"] = "LEFT"
			debuffs.PostCreateIcon = T.PostCreateAura
			debuffs.PostUpdateIcon = T.PostUpdateAura
			
			-- an option to show only our debuffs on target
			if unit == "target" then
				debuffs.onlyShowPlayer = C.unitframes.onlyselfdebuffs
				buffs.onlyShowPlayer = C.unitframes.onlyselfbuffs
			end
			
			self.Debuffs = debuffs
		end
		
		-- cast bar for player and target
		if (C["unitframes"].unitcastbar) then			
			if unit == "player" then
				if C["actionbar"].enable then
					castbar:Height(T.buttonsize - 4)
					if C["unitframes"].cbicons then
						castbar:SetPoint("BOTTOMLEFT", TukuiBar1, "TOPLEFT", T.buttonsize + 5, 5)
					else
						castbar:SetPoint("BOTTOMLEFT", TukuiBar1, "TOPLEFT", 2, 5)
					end
					castbar:SetPoint("BOTTOMRIGHT", TukuiBar1, "TOPRIGHT", -2, 5)
				else
					castbar:Height(T.buttonsize - 4)
					castbar:Width(350)
					castbar:Point("BOTTOM", UIParent, "BOTTOM", 0, 80)
				end
				castbar.Spark:SetHeight(T.buttonsize + 14)
			elseif unit == "target" then
				if T.lowversion then
					castbar:Height(T.buttonsize - 4)
					castbar:Width(245)

					castbar:SetPoint("CENTER", UIParent, "CENTER", -((T.buttonsize+5)/2), -97)
					castbar.Spark:SetHeight(T.buttonsize + 14)
				else
					castbar:Height(30)
					castbar:Width(375)
					
					castbar:SetPoint("CENTER", UIParent, "CENTER", -((T.buttonsize+14)/2), -97)
					castbar.Spark:SetHeight(T.buttonsize + 24)
				end
			end
			
			castbar.time:Point("RIGHT", castbar, "RIGHT", -4, 1)
			castbar.time:SetJustifyH("RIGHT")

			castbar.Text:Point("LEFT", castbar, "LEFT", 4, 1)
			
			if unit == "target" then
				if T.lowversion then
					castbar.Text:SetWidth(110)
				else
					castbar.Text:SetWidth(150)
				end
				castbar.Text:SetHeight(20)
			end			

			if C["unitframes"].cbicons == true then
				if unit == "player" then
					castbar.button:SetPoint("RIGHT", castbarBG, "LEFT", -3, 0)
				elseif unit == "target" then
					castbar.button:SetPoint("LEFT", castbarBG, "RIGHT", 3, 0)
				end
			end
			
			-- cast bar latency on player
			if unit == "player" and C["unitframes"].cblatency == true then
				castbar.safezone = castbar:CreateTexture(nil, "ARTWORK")
				castbar.safezone:SetTexture(unpack(T.Textures.statusBars))
				castbar.safezone:SetVertexColor(0.69, 0.31, 0.31, 0.75)
				castbar.SafeZone = castbar.safezone
			end
		end
		
		-- add combat feedback support
		if C["unitframes"].combatfeedback == true then
			local CombatFeedbackText 
			CombatFeedbackText = T.SetFontString(health, unpack(T.Fonts.uCombat.setfont))
			CombatFeedbackText:SetShadowColor(0, 0, 0)
			CombatFeedbackText:SetShadowOffset(1.25, -1.25)
			CombatFeedbackText:SetPoint("CENTER", 0, 1)
			CombatFeedbackText.colors = {
				DAMAGE = {0.69, 0.31, 0.31},
				CRUSHING = {0.69, 0.31, 0.31},
				CRITICAL = {0.69, 0.31, 0.31},
				GLANCING = {0.69, 0.31, 0.31},
				STANDARD = {0.84, 0.75, 0.65},
				IMMUNE = {0.84, 0.75, 0.65},
				ABSORB = {0.84, 0.75, 0.65},
				BLOCK = {0.84, 0.75, 0.65},
				RESIST = {0.84, 0.75, 0.65},
				MISS = {0.84, 0.75, 0.65},
				HEAL = {0.33, 0.59, 0.33},
				CRITHEAL = {0.33, 0.59, 0.33},
				ENERGIZE = {0.31, 0.45, 0.63},
				CRITENERGIZE = {0.31, 0.45, 0.63},
			}
			self.CombatFeedbackText = CombatFeedbackText
		end
		
		if C["unitframes"].healcomm then
			local mhpb = CreateFrame('StatusBar', nil, self.Health)
			mhpb:SetPoint('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
			mhpb:SetPoint('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
			if T.lowversion then
				mhpb:SetWidth(T.Player)
			else
				mhpb:SetWidth(T.Player)
			end
			mhpb:SetStatusBarTexture(unpack(T.Textures.statusBars))
			mhpb:SetStatusBarColor(0, 1, 0.5, 0.25)
			mhpb:SetMinMaxValues(0,1)

			local ohpb = CreateFrame('StatusBar', nil, self.Health)
			ohpb:SetPoint('TOPLEFT', mhpb:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
			ohpb:SetPoint('BOTTOMLEFT', mhpb:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
			ohpb:SetWidth(T.Player)
			ohpb:SetStatusBarTexture(unpack(T.Textures.statusBars))
			ohpb:SetStatusBarColor(0, 1, 0, 0.25)

			self.HealPrediction = {
				myBar = mhpb,
				otherBar = ohpb,
				maxOverflow = 1,
			}
		end
		
		-- player aggro
		if C["unitframes"].playeraggro == true then
			table.insert(self.__elements, T.UpdateThreat)
			self:RegisterEvent('PLAYER_TARGET_CHANGED', T.UpdateThreat)
			self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', T.UpdateThreat)
			self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', T.UpdateThreat)
		end
		
		-- player/target debuff hightlight
		if C["unitframes"].playerHighlight then
			local debuffHighlight = ufbg:CreateTexture(nil, "OVERLAY")
			debuffHighlight:SetAllPoints()
			debuffHighlight:SetTexture(C["media"].blank)
			debuffHighlight:SetBlendMode("DISABLE")
			debuffHighlight:SetVertexColor(0, 0, 0, 0)
			self.DebuffHighlight = debuffHighlight
			self.DebuffHighlightAlpha = 1
			self.DebuffHighlightFilter = C["unitframes"].debuffHighlightFilter
		end
	end
	
	------------------------------------------------------------------------
	--	Target of Target unit layout
	------------------------------------------------------------------------
	
	if (unit == "targettarget") then
		if not T.lowversion then
			self.panel:Height(17)
		end
		
		if T.lowversion then
			health:Height(14)
		else
			health:Height(18)
		end
		power:Height(3)
		
		local Name = health:CreateFontString(nil, "OVERLAY")
		if T.lowversion then
			Name:SetPoint("CENTER", health, "CENTER", 0, 0)
			Name:SetFont(unpack(T.Fonts.uName.setfont))
		else
			Name:SetPoint("CENTER", panel, "CENTER", 0, 1)
			Name:SetFont(unpack(T.Fonts.uName.setfont))
		end
		Name:SetJustifyH("CENTER")

		self:Tag(Name, '[Tukui:getnamecolor][Tukui:name_medium][Tukui:dead][Tukui:afk]')
		self.Name = Name
		
		if C["unitframes"].totdebuffs == true and T.lowversion ~= true then
			local debuffs = CreateFrame("Frame", nil, health)
			debuffs:SetHeight(health:GetHeight() + power:GetHeight() + 7)
			debuffs:SetWidth(130)
			debuffs.size = debuffs:GetHeight()
			debuffs.spacing = 3
			debuffs.num = 3

			debuffs:SetPoint("TOPRIGHT", ufbg, "TOPLEFT", -3, 0)
			debuffs.initialAnchor = "TOPRIGHT"
			debuffs["growth-x"] = "LEFT"
			debuffs.PostCreateIcon = T.PostCreateAura
			debuffs.PostUpdateIcon = T.PostUpdateAura
			self.Debuffs = debuffs
		end
	end
	
	------------------------------------------------------------------------
	--	Pet unit layout
	------------------------------------------------------------------------
	
	if (unit == "pet") then
		if not T.lowversion then
			self.panel:Height(17)
		end
		
		if T.lowversion then
			health:Height(14)
		else
			health:Height(18)
		end
		power:SetHeight(3)

		health.PostUpdate = T.PostUpdatePetColor

		-- Unit name
		local Name = health:CreateFontString(nil, "OVERLAY")
		if T.lowversion then
			Name:SetPoint("CENTER", health, "CENTER", 0, 0)
			Name:SetFont(unpack(T.Fonts.uName.setfont))
		else
			Name:SetPoint("CENTER", panel, "CENTER", 0, 1)
			Name:SetFont(unpack(T.Fonts.uName.setfont))
		end
		Name:SetJustifyH("CENTER")

		self:Tag(Name, '[Tukui:getnamecolor][Tukui:name_medium] [Tukui:diffcolor][level] [Tukui:dead]')
		self.Name = Name
		
		if (C["unitframes"].unitcastbar == true) then
			castbar:SetFrameStrata("HIGH")
			castbar:SetPoint("TOPLEFT", health)
			castbar:SetPoint("BOTTOMRIGHT", health)
			castbarBG.shadow:Kill()
			
			castbar.time:Point("RIGHT", castbar, "RIGHT", -4, 1)
			castbar.time:SetJustifyH("RIGHT")

			castbar.Text:Point("LEFT", castbar, "LEFT", 4, 1)
		end
		
		-- update pet name, this should fix "UNKNOWN" pet names on pet unit, health and bar color sometime being "grayish".
		self:RegisterEvent("UNIT_PET", T.updateAllElements)
	end


	------------------------------------------------------------------------
	--	Focus unit layout
	------------------------------------------------------------------------
	
	if (unit == "focus") then
		if T.lowversion then
			health:Height(14)
		else
			health:Height(21)
		end
		power:SetHeight(3)
		
		-- names
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("CENTER", health, "CENTER", 0, 1)
		Name:SetJustifyH("CENTER")
		Name:SetFont(unpack(T.Fonts.uName.setfont))
		
		self:Tag(Name, '[Tukui:getnamecolor][Tukui:name_medium][Tukui:dead][Tukui:afk]')
		self.Name = Name

		if C["unitframes"].focusdebuffs then
			local debuffs = CreateFrame("Frame", nil, self)
			if T.lowversion then
				debuffs:SetHeight(health:GetHeight() + power:GetHeight() + 7)
				debuffs:SetWidth(T.Focus)
				debuffs.size = debuffs:GetHeight()
				debuffs.num = 3
				debuffs.spacing = 3
				
				debuffs:Point('TOPLEFT', ufbg, "TOPRIGHT", 3, 0)
				debuffs.initialAnchor = "LEFT"
				debuffs["growth-x"] = "RIGHT"
				debuffs["growth-y"] = "DOWN"
			else
				debuffs:SetHeight(26)
				debuffs:SetWidth(T.Focus)
				debuffs.size = debuffs:GetHeight()
				debuffs.num = 4
				debuffs.spacing = 3
				
				debuffs:Point("BOTTOMLEFT", ufbg, "TOPLEFT", 2, 3)
				debuffs.initialAnchor = "LEFT"
				debuffs["growth-x"] = "RIGHT"
				debuffs["growth-y"] = "UP"
			end
			debuffs.PostCreateIcon = T.PostCreateAura
			debuffs.PostUpdateIcon = T.PostUpdateAura
			self.Debuffs = debuffs
		end
		
		if C["unitframes"].focusbuffs then
			local buffs = CreateFrame("Frame", nil, self)
			if T.lowversion then
				buffs:SetHeight(health:GetHeight() + power:GetHeight() + 7)
				buffs:SetWidth(T.Focus)
				buffs.size = buffs:GetHeight()
				buffs.spacing = 3
				buffs.num = 3

				buffs:SetPoint("TOPRIGHT", ufbg, "TOPLEFT", -3, 0)
				buffs.initialAnchor = "RIGHT"
				buffs["growth-x"] = "LEFT"
				buffs["growth-y"] = "DOWN"
			else
				buffs:SetHeight(26)
				buffs:SetWidth(T.Focus)
				buffs.size = buffs:GetHeight()
				buffs.spacing = 3
				buffs.num = 4

				buffs:SetPoint("TOPLEFT", ufbg, "BOTTOMLEFT", 2, -3)
				buffs.initialAnchor = "LEFT"
				buffs["growth-x"] = "RIGHT"
				buffs["growth-y"] = "DOWN"
			end
			buffs.PostCreateIcon = T.PostCreateAura
			buffs.PostUpdateIcon = T.PostUpdateAura
			self.Buffs = buffs
		end
		
		if C["unitframes"].unitcastbar then
			if T.lowversion then
				castbar:SetHeight(T.Scale(T.buttonsize - 4))
				castbar:SetWidth(T.Scale(280))
				castbar:SetPoint("TOP", UIParent, "TOP", ((T.buttonsize+8)/2), -150)	
				
				castbar.Spark:SetHeight(T.buttonsize + 14)
			else
				castbar:SetHeight(T.Scale(35))
				castbar:SetWidth(T.Scale(490))
				castbar:SetPoint("TOP", UIParent, "TOP", ((T.buttonsize+19)/2), -190)
				
				castbar.Spark:SetHeight(T.buttonsize + 32)
			end
			castbar:SetFrameLevel(6)
			castbar.time:SetPoint("RIGHT", castbar, "RIGHT", T.Scale(-4), T.Scale(1))
			castbar.time:SetJustifyH("RIGHT")
			castbar.Text:SetPoint("LEFT", castbar, "LEFT", T.Scale(4), T.Scale(1))
			
			if C["unitframes"].cbicons == true then
				if T.lowversion then
					castbar.button:Size(T.buttonsize + 4, T.buttonsize + 4)
					castbar.button:SetPoint("RIGHT", castbar, "LEFT", -5, 0)
				else
					castbar.button:Size(T.buttonsize + 16, T.buttonsize + 16)
					castbar.button:SetPoint("RIGHT", castbar, "LEFT", -5, 0)
				end
			end

			castbar:RegisterEvent("PLAYER_TARGET_CHANGED")
			castbar:RegisterEvent("PLAYER_FOCUS_CHANGED")
			castbar:SetScript("OnEvent", function(self)
				-- Only show focus castbar if target is not our focus
				if not UnitIsUnit("focus", "target") then
					self:SetAlpha(1)
				else
					self:SetAlpha(0)
				end
			end)
		end
	end
	
	------------------------------------------------------------------------
	--	Focus target unit layout
	------------------------------------------------------------------------

	if (unit == "focustarget") then
		if T.lowversion then
			health:Height(14)
		else
			health:Height(21)
		end
		power:SetHeight(3)
		
		-- names
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("CENTER", health, "CENTER", 0, 1)
		Name:SetJustifyH("CENTER")
		Name:SetFont(unpack(T.Fonts.uName.setfont))
		
		self:Tag(Name, '[Tukui:getnamecolor][Tukui:name_medium][Tukui:dead][Tukui:afk]')
		self.Name = Name
	end

	------------------------------------------------------------------------
	--	Arena or boss units layout (both mirror'd)
	------------------------------------------------------------------------
	
	if (unit and unit:find("arena%d") and C["arena"].unitframes == true) or (unit and unit:find("boss%d") and C["unitframes"].showboss == true) then
		-- Right-click focus on arena or boss units
		self:SetAttribute("type2", "focus")
		
		if T.lowversion then
			health:Height(22)
		else
			health:Height(26)
		end
		power:SetHeight(4)

		health.value = T.SetFontString(health, unpack(T.Fonts.uHealth.setfont))
		health.value:Point("LEFT", health, "LEFT", 7, 1)
		health.PostUpdate = T.PostUpdateHealth

		-- names
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("RIGHT", health, "RIGHT", -4, 0)
		Name:SetJustifyH("CENTER")
		Name:SetFont(unpack(T.Fonts.uName.setfont))
		Name.frequentUpdates = 0.2
		
		self:Tag(Name, '[Tukui:getnamecolor][Tukui:name_medium][Tukui:dead]')
		self.Name = Name
		
		if (unit and unit:find("boss%d")) then
			-- alt power bar
			local AltPowerBar = CreateFrame("StatusBar", nil, self.Health)
			AltPowerBar:SetFrameLevel(self.Health:GetFrameLevel() + 4)
			AltPowerBar:Height(5)
			AltPowerBar:SetStatusBarTexture(unpack(T.Textures.statusBars))
			AltPowerBar:GetStatusBarTexture():SetHorizTile(false)
			AltPowerBar:SetStatusBarColor(1, 0, 0)
			AltPowerBar:SetPoint("LEFT", self.Health, "TOPLEFT", 5, 1)
			AltPowerBar:SetPoint("RIGHT", self.Health, "TOPRIGHT", -5, 1)
			self.AltPowerBar = AltPowerBar

			local AltPowerBarBG = CreateFrame("Frame", nil, AltPowerBar)
			AltPowerBarBG:CreatePanel("Default", 1, 1, "CENTER")
			AltPowerBarBG:Point("TOPLEFT", -2, 2)
			AltPowerBarBG:Point("BOTTOMRIGHT", 2, -2)
			AltPowerBarBG:SetFrameLevel(AltPowerBar:GetFrameLevel())
			AltPowerBarBG:SetFrameStrata(AltPowerBar:GetFrameStrata())
			AltPowerBarBG.shadow:SetFrameStrata("BACKGROUND")
			
			-- create buff at left of unit if they are boss units
			local buffs = CreateFrame("Frame", nil, self)
			buffs:SetHeight(health:GetHeight() + power:GetHeight() + 7)
			buffs:SetWidth(252)
			buffs:Point("TOPRIGHT", ufbg, "TOPLEFT", -3, 0)
			buffs.size = buffs:GetHeight()
			buffs.num = 3
			buffs.spacing = 3
			buffs.initialAnchor = "TOPRIGHT"
			buffs["growth-x"] = "LEFT"
			buffs.PostCreateIcon = T.PostCreateAura
			buffs.PostUpdateIcon = T.PostUpdateAura
			self.Buffs = buffs
			
			-- because it appear that sometime elements are not correct.
			self:HookScript("OnShow", T.updateAllElements)
		end

		-- create debuff for arena units
		local debuffs = CreateFrame("Frame", nil, self)
		debuffs:SetHeight(health:GetHeight() + power:GetHeight() + 7)
		debuffs:SetWidth(200)
		debuffs:SetPoint("TOPLEFT", ufbg, "TOPRIGHT", 3, 0)
		debuffs.size = debuffs:GetHeight()
		debuffs.num = 3
		debuffs.spacing = 3
		debuffs.initialAnchor = "TOPLEFT"
		debuffs["growth-x"] = "RIGHT"
		debuffs.PostCreateIcon = T.PostCreateAura
		debuffs.PostUpdateIcon = T.PostUpdateAura
		self.Debuffs = debuffs

		-- trinket feature via trinket plugin
		if (C.arena.unitframes) and (unit and unit:find('arena%d')) then
			local Trinketbg = CreateFrame("Frame", nil, self)
			Trinketbg:SetHeight(health:GetHeight() + power:GetHeight() + 7)
			Trinketbg:SetWidth(Trinketbg:GetHeight())
			Trinketbg:SetPoint("TOPRIGHT", ufbg, "TOPLEFT", -3, 0)				
			Trinketbg:SetTemplate("Default")
			Trinketbg:CreateShadow("Default")
			Trinketbg:SetFrameLevel(0)
			self.Trinketbg = Trinketbg
			
			local Trinket = CreateFrame("Frame", nil, Trinketbg)
			Trinket:SetAllPoints(Trinketbg)
			Trinket:Point("TOPLEFT", Trinketbg, 2, -2)
			Trinket:Point("BOTTOMRIGHT", Trinketbg, -2, 2)
			Trinket:SetFrameLevel(1)
			Trinket.trinketUseAnnounce = true
			self.Trinket = Trinket
		end
		
		-- boss & arena frames cast bar!
		castbar:SetPoint("TOPLEFT", ufbg, "BOTTOMLEFT", 2, -5)
		castbar:SetPoint("TOPRIGHT", ufbg, "BOTTOMRIGHT", -2, -5)
		castbar:SetHeight(13)
		castbarBG.shadow:Hide()
		
		castbar.time:SetPoint("RIGHT", castbar, "RIGHT", -4, 1)
		castbar.time:SetJustifyH("RIGHT")

		castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, 1)
	end

	------------------------------------------------------------------------
	--	Main tanks and Main Assists layout (both mirror'd)
	------------------------------------------------------------------------
	
	if(self:GetParent():GetName():match"TukuiMainTank" or self:GetParent():GetName():match"TukuiMainAssist") then
		if T.lowversion then
			health:Height(14)
		else
			health:Height(21)
		end
		
		ufbg:Point("TOPLEFT", health, -2, 2)
		ufbg:Point("BOTTOMRIGHT", health, 2, -2)
		
		-- names
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("CENTER", health, "CENTER", 0, 1)
		Name:SetJustifyH("CENTER")
		Name:SetFont(unpack(T.Fonts.uName.setfont))
		
		self:Tag(Name, '[Tukui:getnamecolor][Tukui:nameshort]')
		self.Name = Name
	end
	
	return self
end

------------------------------------------------------------------------
--	Default position of Tukui unitframes
------------------------------------------------------------------------

oUF:RegisterStyle('Tukui', Shared)

-- spawn
local player = oUF:Spawn('player', "TukuiPlayer")
local target = oUF:Spawn('target', "TukuiTarget")
local tot = oUF:Spawn('targettarget', "TukuiTargetTarget")
local pet = oUF:Spawn('pet', "TukuiPet")
local focus = oUF:Spawn('focus', "TukuiFocus")

-- sizes
player:Size(T.Player, player.Health:GetHeight() + player.Power:GetHeight() + player.panel:GetHeight() + 6)
target:Size(T.Target, target.Health:GetHeight() + target.Power:GetHeight() + target.panel:GetHeight() + 6)

if T.lowversion then
	tot:Size(T.ToT, tot.Health:GetHeight() + tot.Power:GetHeight() + 3)
	pet:Size(T.Pet, pet.Health:GetHeight() + pet.Power:GetHeight() + 3)
else
	tot:SetSize(T.ToT, tot.Health:GetHeight() + tot.Power:GetHeight() + tot.panel:GetHeight() + 6)
	pet:SetSize(T.Pet, pet.Health:GetHeight() + pet.Power:GetHeight() + pet.panel:GetHeight() + 6)	
end

focus:SetSize(T.Focus, focus.Health:GetHeight() + focus.Power:GetHeight() + 3)

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)

	if addon == "Tukui_Dps_Layout" then
		--[ DPS ]--
		-- points
		if T.lowversion then
			player:Point("TOP", UIParent, "BOTTOM", -96 , 220)
			target:Point("TOP", UIParent, "BOTTOM", 96, 220)
			tot:Point("TOPRIGHT", TukuiTarget, "BOTTOMRIGHT", 0, -7)
			pet:Point("TOPLEFT", TukuiPlayer, "BOTTOMLEFT", 0, -7)

			focus:Point("TOP", UIParent, "BOTTOM", 0, 133)
		else
			player:Point("TOP", UIParent, "BOTTOM", -179 , 230)
			target:Point("TOP", UIParent, "BOTTOM", 179, 230)
			tot:Point("TOPRIGHT", TukuiTarget, "BOTTOMRIGHT", 0, -7)
			pet:Point("TOPLEFT", TukuiPlayer, "BOTTOMLEFT", 0, -7)

			focus:Point("TOP", UIParent, "BOTTOM", 0, 230)
		end
	elseif addon == "Tukui_Heal_Layout" then
		--[ HEAL ]--
		-- points
		if T.lowversion then
			player:Point("TOP", UIParent, "BOTTOM", -300 , 230)
			target:Point("TOP", UIParent, "BOTTOM", 300, 230)
			tot:Point("TOPRIGHT", TukuiTarget, "BOTTOMRIGHT", 0, -7)
			pet:Point("TOPLEFT", TukuiPlayer, "BOTTOMLEFT", 0, -7)
			
			focus:Point("TOP", UIParent, "BOTTOM", 0, 230)
		else
			player:Point("TOP", UIParent, "BOTTOM", -310 , 230)
			target:Point("TOP", UIParent, "BOTTOM", 310, 230)
			tot:Point("TOPRIGHT", TukuiTarget, "BOTTOMRIGHT", 0, -7)
			pet:Point("TOPLEFT", TukuiPlayer, "BOTTOMLEFT", 0, -7)

			focus:Point("TOP", UIParent, "BOTTOM", -400, 400)
		end
	end
end)

if C["unitframes"].showfocustarget then
	local focustarget = oUF:Spawn('focustarget', "TukuiFocusTarget")
	focustarget:Point("TOP", TukuiFocus, "BOTTOM", 0, -7)
	focustarget:SetSize(T.Focus, focustarget.Health:GetHeight() + focustarget.Power:GetHeight() + 3)
end

if C.arena.unitframes then
	local arena = {}
	for i = 1, 5 do
		arena[i] = oUF:Spawn("arena"..i, "TukuiArena"..i)
		if i == 1 then
			arena[i]:Point("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -300, 520)
		else
			arena[i]:Point("BOTTOM", arena[i-1], "TOP", 0, 23)
		end
		arena[i]:Size(T.Boss, arena[i].Health:GetHeight() + arena[i].Power:GetHeight() + 7)
	end
end

if C["unitframes"].showboss then
	for i = 1,MAX_BOSS_FRAMES do
		local t_boss = _G["Boss"..i.."TargetFrame"]
		t_boss:UnregisterAllEvents()
		t_boss.Show = T.dummy
		t_boss:Hide()
		_G["Boss"..i.."TargetFrame".."HealthBar"]:UnregisterAllEvents()
		_G["Boss"..i.."TargetFrame".."ManaBar"]:UnregisterAllEvents()
	end

	local boss = {}
	for i = 1, MAX_BOSS_FRAMES do
		boss[i] = oUF:Spawn("boss"..i, "TukuiBoss"..i)
		if i == 1 then
			boss[i]:Point("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -300, 520)
		else
			boss[i]:Point('BOTTOM', boss[i-1], 'TOP', 0, 23)             
		end
		boss[i]:Size(T.Boss, boss[i].Health:GetHeight() + boss[i].Power:GetHeight() + 7)
	end
end

local assisttank_width = 90
local assisttank_height  = 20
if C["unitframes"].maintank then
	local tank = oUF:SpawnHeader('TukuiMainTank', nil, 'raid',
		'oUF-initialConfigFunction', ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
		]]):format(assisttank_width, assisttank_height),
		'showRaid', true,
		'groupFilter', 'MAINTANK',
		'yOffset', 7,
		'point' , 'BOTTOM',
		'template', 'oUF_TukuiMtt'
	)
	tank:Point("BOTTOMLEFT", TukuiPetBar, "TOPLEFT", -60, 6)
end
 
if C["unitframes"].mainassist then
	local assist = oUF:SpawnHeader("TukuiMainAssist", nil, 'raid',
		'oUF-initialConfigFunction', ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
		]]):format(assisttank_width, assisttank_height),
		'showRaid', true,
		'groupFilter', 'MAINASSIST',
		'yOffset', 7,
		'point' , 'BOTTOM',
		'template', 'oUF_TukuiMtt'
	)
	if C["unitframes"].maintank then
		assist:Point("BOTTOMLEFT", TukuiMainTank, "TOPLEFT", 0, 8)
	else
		assist:Point("BOTTOMLEFT", TukuiPetBar, "TOPLEFT", -60, 6)
	end
end

-- this is just a fake party to hide Blizzard frame if no Tukui raid layout are loaded.
local party = oUF:SpawnHeader("oUF_noParty", nil, "party", "showParty", true)

------------------------------------------------------------------------
-- Right-Click on unit frames menu. 
-- Doing this to remove SET_FOCUS eveywhere.
-- SET_FOCUS work only on default unitframes.
-- Main Tank and Main Assist, use /maintank and /mainassist commands.
------------------------------------------------------------------------

local testui = TestUI or function() end
TestUI = function()
	testui()
	UnitAura = function()
		-- name, rank, texture, count, dtype, duration, timeLeft, caster
		return 'penancelol', 'Rank 2', 'Interface\\Icons\\Spell_Holy_Penance', random(5), 'Magic', 0, 0, "player"
	end
	if(oUF) then
		for i, v in pairs(oUF.units) do
			if(v.UNIT_AURA) then
				v:UNIT_AURA("UNIT_AURA", v.unit)
			end
		end
	end
end
SlashCmdList.TestUI = TestUI
SLASH_TestUI1 = "/testui"

-- Hunter Dismiss Pet Taint (Blizzard issue)
local PET_DISMISS = "PET_DISMISS"
if T.myclass == "HUNTER" then PET_DISMISS = nil end

do
	UnitPopupMenus["SELF"] = { "PVP_FLAG", "LOOT_METHOD", "LOOT_THRESHOLD", "OPT_OUT_LOOT_TITLE", "LOOT_PROMOTE", "DUNGEON_DIFFICULTY", "RAID_DIFFICULTY", "RESET_INSTANCES", "RAID_TARGET_ICON", "SELECT_ROLE", "CONVERT_TO_PARTY", "CONVERT_TO_RAID", "LEAVE", "CANCEL" };
	UnitPopupMenus["PET"] = { "PET_PAPERDOLL", "PET_RENAME", "PET_ABANDON", "PET_DISMISS", "CANCEL" };
	UnitPopupMenus["PARTY"] = { "MUTE", "UNMUTE", "PARTY_SILENCE", "PARTY_UNSILENCE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "WHISPER", "PROMOTE", "PROMOTE_GUIDE", "LOOT_PROMOTE", "VOTE_TO_KICK", "UNINVITE", "INSPECT", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "SELECT_ROLE", "PVP_REPORT_AFK", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" }
	UnitPopupMenus["PLAYER"] = { "WHISPER", "INSPECT", "INVITE", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" }
	if T.toc < 40300 then
		UnitPopupMenus["RAID_PLAYER"] = {"MUTE", "UNMUTE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "WHISPER", "INSPECT", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "SELECT_ROLE", "RAID_LEADER", "RAID_PROMOTE", "RAID_DEMOTE", "LOOT_PROMOTE", "RAID_REMOVE", "PVP_REPORT_AFK", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL"}
		UnitPopupMenus["RAID"] = {"MUTE", "UNMUTE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "RAID_LEADER", "RAID_PROMOTE", "RAID_MAINTANK", "RAID_MAINASSIST", "LOOT_PROMOTE", "RAID_DEMOTE", "RAID_REMOVE", "PVP_REPORT_AFK", "CANCEL"}
	else
		UnitPopupMenus["RAID_PLAYER"] = {"MUTE", "UNMUTE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "WHISPER", "INSPECT", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "SELECT_ROLE", "RAID_LEADER", "RAID_PROMOTE", "RAID_DEMOTE", "LOOT_PROMOTE", "VOTE_TO_KICK", "RAID_REMOVE", "PVP_REPORT_AFK", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL"}
		UnitPopupMenus["RAID"] = {"MUTE", "UNMUTE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "RAID_LEADER", "RAID_PROMOTE", "RAID_MAINTANK", "RAID_MAINASSIST", "LOOT_PROMOTE", "RAID_DEMOTE", "VOTE_TO_KICK", "RAID_REMOVE", "PVP_REPORT_AFK", "CANCEL"}
	end
	UnitPopupMenus["VEHICLE"] = { "RAID_TARGET_ICON", "VEHICLE_LEAVE", "CANCEL" }
	UnitPopupMenus["TARGET"] = { "RAID_TARGET_ICON", "CANCEL" }
	UnitPopupMenus["ARENAENEMY"] = { "CANCEL" }
	UnitPopupMenus["FOCUS"] = { "RAID_TARGET_ICON", "CANCEL" }
	UnitPopupMenus["BOSS"] = { "RAID_TARGET_ICON", "CANCEL" }
end