local ADDON_NAME, ns = ...
local oUF = oUFTukui or oUF
assert(oUF, "Tukui was unable to locate oUF install.")

ns._Objects = {}
ns._Headers = {}

local T, C, L = unpack(Tukui) -- Import: T - functions, constants, variables; C - config; L - locales
if not C["unitframes"].enable == true then return end

local backdrop = {
	bgFile = C["media"].blank,
	insets = {top = -T.mult, left = -T.mult, bottom = -T.mult, right = -T.mult},
}

local function Shared(self, unit)
	self.colors = T.oUF_colors
	self:RegisterForClicks("AnyUp")
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	self.menu = T.SpawnMenu
	
	local health = CreateFrame('StatusBar', "HealthBar", self)
	health:SetPoint("TOPLEFT")
	health:SetPoint("TOPRIGHT")
	if unit:find("partypet") then
		health:Height(17)
	else
		health:Height(30)
	end
	health:SetStatusBarTexture(unpack(T.Textures.statusBars))
	self.Health = health
	
	if C["unitframes"].healthvertical then
		health:SetOrientation('VERTICAL')
	end

	local healthBG = health:CreateTexture(nil, 'BORDER')
	healthBG:SetAllPoints()
	self.Health.bg = healthBG

	health:CreateBorder(false, true)

	-- power
	local power = CreateFrame('StatusBar', nil, self)
	power:Point("TOPLEFT", health, "BOTTOMLEFT", 0, -3)
	power:Point("TOPRIGHT", health, "BOTTOMRIGHT", 0, -3)
	if unit:find("partypet") then
		power:Height(0)
	else
		power:Height(4)
	end
	power:SetStatusBarTexture(unpack(T.Textures.statusBars))
	self.Power = power

	local powerBG = power:CreateTexture(nil, 'BORDER')
	powerBG:SetAllPoints(power)
	powerBG:SetTexture(unpack(T.Textures.statusBars))
	powerBG.multiplier = 0.3
	self.Power.bg = powerBG
	
	power:CreateBorder(false, true)
	
	health.PostUpdate = T.PostUpdateHealthRaid
	
	health.frequentUpdates = true
	power.frequentUpdates = true
	power.colorDisconnected = true

	if C["unitframes"].showsmooth == true then
		health.Smooth = true
		power.Smooth = true
	end

	if C["unitframes"].unicolor == true then
		health.colorDisconnected = false
		health.colorClass = false
		health:SetStatusBarColor(unpack(C["unitframes"].healthColor))
		healthBG:SetTexture(1, 1, 1)
		healthBG:SetVertexColor(unpack(C["unitframes"].healthBgColor))
		
		power.colorClass = true
	else
		healthBG:SetTexture(.1, .1, .1)
		health.colorDisconnected = true	
		health.colorClass = true
		health.colorReaction = true
		
		power.colorPower = true
	end
	
	-- mouseover highlight, credits to Hydra
	if C.unitframes.unicolor and C.unitframes.mouseoverhighlight then
		self:HookScript("OnEnter", function(self)
			if not UnitIsConnected(self.unit) or UnitIsDead(self.unit) or UnitIsGhost(self.unit) or (not UnitInRange(self.unit) and not UnitIsPlayer(self.unit)) then return end
			local hover = RAID_CLASS_COLORS[select(2, UnitClass(self.unit))]
			health:SetStatusBarColor(hover.r, hover.g, hover.b)
			health.classcolored = true
		end)
		
		self:HookScript("OnLeave", function(self)
			if not UnitIsConnected(self.unit) or UnitIsDead(self.unit) or UnitIsGhost(self.unit) then return end
			local r, g, b = oUF.ColorGradient(UnitHealth(self.unit)/UnitHealthMax(self.unit), unpack(C["media"].gradienthealth))
			health:SetStatusBarColor(r, g, b)
			health.classcolored = false
		end)
	end
	
	-- unitframe bg
	local ufbg = CreateFrame("Frame", nil, self)
	ufbg:SetFrameLevel(health:GetFrameLevel() - 1)
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

	if C["unitframes"].healthdeficit and not unit:find("partypet") then
		health.PostUpdate = T.PostUpdateHealthRaid

		health.value = health:CreateFontString(nil, "OVERLAY")
		health.value:SetPoint("CENTER", health, "CENTER", 0, -6)
		health.value:SetFont(unpack(T.Fonts.uHealth.setfont))
		self.Health.value = health.value
	end
	
	local name = health:CreateFontString(nil, "OVERLAY")
	if not C["unitframes"].healthdeficit or unit:find("partypet") then
		name:SetPoint("CENTER", health, "CENTER", 0, 1)
	else
		name:SetPoint("CENTER", health, "CENTER", 0, 6)
	end
	name:SetFont(unpack(T.Fonts.uName.setfont))
	if C["unitframes"].healthdeficit then
		if C["unitframes"].unicolor then
			self:Tag(name, "[Tukui:leader][Tukui:getnamecolor][Tukui:name_short][Tukui:masterlooter]")
		else
			self:Tag(name, "[Tukui:leader][Tukui:nameshort][Tukui:masterlooter]")
		end
	else
		if C["unitframes"].unicolor then
			self:Tag(name, "[Tukui:leader][Tukui:getnamecolor][Tukui:name_short][Tukui:masterlooter][Tukui:dead][Tukui:afk]")
		else
			self:Tag(name, "[Tukui:leader][Tukui:name_short][Tukui:masterlooter][Tukui:dead][Tukui:afk]")
		end
	end
	self.Name = name
	
    local LFDRole = health:CreateTexture(nil, "OVERLAY")
    LFDRole:Height(6)
    LFDRole:Width(6)
	LFDRole:Point("TOPRIGHT", -2, -2)
	LFDRole:SetTexture("Interface\\AddOns\\Tukui\\media\\textures\\lfdicons.blp")
	self.LFDRole = LFDRole
	
	if C["unitframes"].aggro == true then
		table.insert(self.__elements, T.UpdateThreat)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', T.UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', T.UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', T.UpdateThreat)
    end
	
	if C["unitframes"].showsymbols == true then
		local RaidIcon = health.oborder:CreateTexture(nil, 'OVERLAY')
		RaidIcon:Height(18)
		RaidIcon:Width(18)
		RaidIcon:SetPoint('CENTER', self, 'TOP')
		RaidIcon:SetTexture("Interface\\AddOns\\Tukui\\media\\textures\\raidicons.blp") -- thx hankthetank for texture
		self.RaidIcon = RaidIcon
	end
	
	local ReadyCheck = health:CreateTexture(nil, "OVERLAY")
	ReadyCheck:Height(12)
	ReadyCheck:Width(12)
	ReadyCheck:SetPoint("BOTTOMRIGHT", -2, 2)
	self.ReadyCheck = ReadyCheck
	
	if C["unitframes"].debuffHighlightFilter then
		local debuffHighlight = ufbg:CreateTexture(nil, "OVERLAY")
		debuffHighlight:SetAllPoints()
		debuffHighlight:SetTexture(C["media"].blank)
		debuffHighlight:SetBlendMode("DISABLE")
		debuffHighlight:SetVertexColor(0, 0, 0, 0)
		self.DebuffHighlight = debuffHighlight
		self.DebuffHighlightAlpha = 0
		self.DebuffHighlightFilter = C["unitframes"].debuffHighlightFilter
	end
	
	--local picon = self.Health:CreateTexture(nil, 'OVERLAY')
	--picon:SetPoint('CENTER', self.Health)
	--picon:SetSize(16, 16)
	--picon:SetTexture[[Interface\AddOns\Tukui\media\textures\picon]]
	--picon.Override = T.Phasing
	--self.PhaseIcon = picon
	
	if C["unitframes"].showrange == true then
		local range = {insideAlpha = 1, outsideAlpha = C["unitframes"].raidalphaoor}
		self.Range = range
	end
	
	
	if C["unitframes"].healcomm then
		local mhpb = CreateFrame('StatusBar', nil, self.Health)
		mhpb:SetStatusBarTexture(unpack(T.Textures.statusBars))
		mhpb:SetStatusBarColor(0, 1, 0.5, 0.25)

		local ohpb = CreateFrame('StatusBar', nil, self.Health)
		ohpb:SetStatusBarTexture(unpack(T.Textures.statusBars))
		ohpb:SetStatusBarColor(0, 1, 0, 0.25)

		if C["unitframes"].healthvertical == true then
			mhpb:Point('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'TOPLEFT', 0, 0)
			mhpb:Point('BOTTOMRIGHT', self.Health:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)

			ohpb:Point('BOTTOMLEFT', mhpb:GetStatusBarTexture(), 'TOPLEFT', 0, 0)
			ohpb:Point('BOTTOMRIGHT', mhpb:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
			
			mhpb:Height(health:GetHeight())
			ohpb:Height(health:GetHeight())

			ohpb:SetOrientation('VERTICAL')
			mhpb:SetOrientation('VERTICAL')
		
		else
			mhpb:Point('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
			mhpb:Point('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)

			ohpb:Point('TOPLEFT', mhpb:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
			ohpb:Point('BOTTOMLEFT', mhpb:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
			
			mhpb:Width(150)
			ohpb:Width(150)

			ohpb:SetOrientation('HORIZONTAL')
			mhpb:SetOrientation('HORIZONTAL')
		end

		
		self.HealPrediction = {
			myBar = mhpb,
			otherBar = ohpb,
			maxOverflow = 1,
		}
	end
	
	if C["unitframes"].raidunitdebuffwatch == true then
		-- AuraWatch (corner icon)
		T.createAuraWatch(self,unit)
		
		-- Raid Debuffs (big middle icon)
		local RaidDebuffs = CreateFrame('Frame', nil, self)
		RaidDebuffs:Height(22)
		RaidDebuffs:Width(22)
		RaidDebuffs:Point('CENTER', health, 1,0)
		RaidDebuffs:SetFrameStrata(health:GetFrameStrata())
		RaidDebuffs:SetFrameLevel(health:GetFrameLevel() + 2)
		
		RaidDebuffs:SetTemplate("Default")
		
		RaidDebuffs.icon = RaidDebuffs:CreateTexture(nil, 'OVERLAY')
		RaidDebuffs.icon:SetTexCoord(.09, .91, .09, .91)
		RaidDebuffs.icon:Point("TOPLEFT", 2, -2)
		RaidDebuffs.icon:Point("BOTTOMRIGHT", -2, 2)
		
		-- just in case someone want to add this feature, uncomment to enable it
		--[[
		if C["unitframes"].auratimer then
			RaidDebuffs.cd = CreateFrame('Cooldown', nil, RaidDebuffs)
			RaidDebuffs.cd:SetPoint("TOPLEFT", T.Scale(2), T.Scale(-2))
			RaidDebuffs.cd:SetPoint("BOTTOMRIGHT", T.Scale(-2), T.Scale(2))
			RaidDebuffs.cd.noOCC = true -- remove this line if you want cooldown number on it
		end
		--]]
		
		RaidDebuffs.count = RaidDebuffs:CreateFontString(nil, 'OVERLAY')
		RaidDebuffs.count:SetFont(C["media"].pixel_font, 12, "MONOCHROMEOUTLINE")
		RaidDebuffs.count:SetPoint('BOTTOMRIGHT', RaidDebuffs, 'BOTTOMRIGHT', 0, 2)
		RaidDebuffs.count:SetTextColor(1, .9, 0)
		
		if C["unitframes"].raiddebuffstime == true then
			RaidDebuffs:FontString('time', C["media"].pixel_font, 12, "MONOCHROMEOUTLINE")
			RaidDebuffs.time:SetPoint('CENTER', 2, 0)
			RaidDebuffs.time:SetTextColor(1, .9, 0)
		end
		
		self.RaidDebuffs = RaidDebuffs
    end
	
	return self
end

oUF:RegisterStyle('TukuiHealRaid', Shared)
oUF:Factory(function(self)
	oUF:SetActiveStyle("TukuiHealRaid")	

	local raid = self:SpawnHeader("TukuiHealRaid", nil, "raid",
		'oUF-initialConfigFunction', [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute('initial-width'))
			self:SetHeight(header:GetAttribute('initial-height'))
		]],
		'initial-width', T.Scale(70),
		'initial-height', T.Scale(41),
		"showRaid", true, 
		"xoffset", T.Scale(7),
		"point", "LEFT",
		"groupFilter", "1,2,3,4,5,6,7,8",
		"groupingOrder", "1,2,3,4,5,6,7,8",
		"groupBy", "GROUP",
		"maxColumns", 5,
		"unitsPerColumn", 5,
		"columnSpacing", T.Scale(3),
		"columnAnchorPoint", "BOTTOM"
	)
	raid:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, T.Scale(145))
end)

-- only show 5 groups in raid (25 mans raid)
local MaxGroup = CreateFrame("Frame")
MaxGroup:RegisterEvent("PLAYER_ENTERING_WORLD")
MaxGroup:RegisterEvent("ZONE_CHANGED_NEW_AREA")
MaxGroup:SetScript("OnEvent", function(self)
	local inInstance, instanceType = IsInInstance()
	local _, _, _, _, maxPlayers, _, _ = GetInstanceInfo()
	if inInstance and instanceType == "raid" and maxPlayers ~= 40 then
		TukuiHealRaid:SetAttribute("groupFilter", "1,2,3,4,5")
	else
		TukuiHealRaid:SetAttribute("groupFilter", "1,2,3,4,5,6,7,8")
	end
end)