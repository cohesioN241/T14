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
	
	local t = CreateFrame("Frame", nil, self)
	t:CreatePanel("Default", 120, 20, "CENTER", self)
	t:SetFrameLevel(0)
	self.t = t		

	local health = CreateFrame('StatusBar', nil, self)
	health:SetFrameLevel(t:GetFrameLevel() + 1)
	health:SetFrameStrata(t:GetFrameStrata())
	health:Point("TOPLEFT", t, 2, -2)
	health:Point("BOTTOMRIGHT", t, -2, 2)
	health:SetStatusBarTexture(C["media"].normTex)
	self.Health = health
	
	local healthBG = health:CreateTexture(nil, 'BORDER')
	healthBG:SetAllPoints()
	self.Health.bg = healthBG
	
	health.PostUpdate = T.PostUpdatePetColor
	health.frequentUpdates = true
	
	if C["unitframes"].showsmooth == true then
		health.Smooth = true
	end

	if C["unitframes"].unicolor == true then
		health.colorDisconnected = false
		health.colorClass = false
		health:SetStatusBarColor(unpack(C["unitframes"].healthColor))
		healthBG:SetTexture(1, 1, 1)
		healthBG:SetVertexColor(unpack(C["unitframes"].healthBgColor))
	else
		healthBG:SetTexture(.1, .1, .1)
		health.colorDisconnected = true	
		health.colorClass = true
		health.colorReaction = true		
	end

	if not C["unitframes"].hidepower then
		local tt = CreateFrame("Frame", nil, self)
		tt:CreatePanel("Default", 60, 7, "LEFT", t, "BOTTOMLEFT", 5, 0)
		tt:SetFrameLevel(health:GetFrameLevel() + 2)
		tt.shadow:SetFrameLevel(0)
		self.tt = tt

		local power = CreateFrame("StatusBar", nil, self)
		power:SetFrameLevel(health:GetFrameLevel() + 1)
		power:Height(3)
		power:Point("TOPLEFT", tt, "TOPLEFT", 2, -2)
		power:Point("BOTTOMRIGHT", tt, "BOTTOMRIGHT", -2, 2)
		power:SetStatusBarTexture(unpack(T.Textures.statusBars))
		self.Power = power
		
		local powerBG = power:CreateTexture(nil, "BORDER")
		powerBG:SetAllPoints()
		powerBG:SetTexture(unpack(T.Textures.statusBars))
		powerBG.multiplier = 0.3
		self.Power.bg = powerBG	
	
		power.frequentUpdates = true
		power.colorDisconnected = true

		if C["unitframes"].showsmooth == true then
			power.Smooth = true
		end

		if C["unitframes"].unicolor == true then
			power.colorClass = true
		else
			power.colorPower = true		
		end
	end
	
	local name = health:CreateFontString(nil, 'OVERLAY')
	name:SetFont(unpack(T.Fonts.uName.setfont))
	name:Point("LEFT", t, "RIGHT", 4, 1)
	self:Tag(name, '[Tukui:leader][Tukui:getnamecolor][Tukui:name_short][Tukui:masterlooter][Tukui:dead][Tukui:afk]')
	self.Name = name
	
	if C["unitframes"].showsymbols == true then
		RaidIcon = health:CreateTexture(nil, 'OVERLAY')
		RaidIcon:Height(16)
		RaidIcon:Width(16)
		RaidIcon:SetPoint("CENTER", t, "TOP")
		RaidIcon:SetTexture("Interface\\AddOns\\Tukui\\media\\textures\\raidicons.blp") -- thx hankthetank for texture
		self.RaidIcon = RaidIcon
	end
	
	if C["unitframes"].aggro == true then
		table.insert(self.__elements, T.UpdateThreat)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', T.UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', T.UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', T.UpdateThreat)
    end
	
	local LFDRole = health:CreateTexture(nil, "OVERLAY")
    LFDRole:Height(6)
    LFDRole:Width(6)
	LFDRole:Point("TOPLEFT", 2, -2)
	LFDRole:SetTexture("Interface\\AddOns\\Tukui\\media\\textures\\lfdicons.blp")
	self.LFDRole = LFDRole
	
	local ReadyCheck = health:CreateTexture(nil, "OVERLAY")
	ReadyCheck:Height(12)
	ReadyCheck:Width(12)
	ReadyCheck:SetPoint('CENTER')
	self.ReadyCheck = ReadyCheck
	
	--local picon = self.Health:CreateTexture(nil, 'OVERLAY')
	--picon:SetPoint('CENTER', self.Health)
	--picon:SetSize(16, 16)
	--picon:SetTexture[[Interface\AddOns\Tukui\media\textures\picon]]
	--picon.Override = T.Phasing
	--self.PhaseIcon = picon
	
	self.DebuffHighlightAlpha = 1
	self.DebuffHighlightBackdrop = true
	self.DebuffHighlightFilter = true
	
	if C["unitframes"].showrange == true then
		local range = {insideAlpha = 1, outsideAlpha = C["unitframes"].raidalphaoor}
		self.Range = range
	end

	-- AuraWatch for DPS layout
	if C["unitframes"].raidunitdebuffwatch and C["unitframes"].dpsunitdebuffwatch then
		-- AuraWatch (corner icon)
		--T.createAuraWatch(self,unit)
		
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

oUF:RegisterStyle("TukuiDpsPR10", Shared)
oUF:Factory(function(self)
	oUF:SetActiveStyle("TukuiDpsPR10")

	local raid = self:SpawnHeader("oUF_TukuiDpsPR10", nil, "custom [@raid16,exists] hide;show", 
		'oUF-initialConfigFunction', [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute('initial-width'))
			self:SetHeight(header:GetAttribute('initial-height'))
		]],
		'initial-width', T.Scale(120),
		'initial-height', T.Scale(22),	
		"showParty", true, 
		"showRaid", true, 
		"showPlayer", C["unitframes"].showplayerinparty, 
		"groupFilter", "1,2,3,4,5,6,7,8", 
		"groupingOrder", "1,2,3,4,5,6,7,8",
		"groupBy", "GROUP",
		"yOffset", T.Scale(-5)
	)
	raid:SetPoint('TOPLEFT', UIParent, 8, -320)
end)