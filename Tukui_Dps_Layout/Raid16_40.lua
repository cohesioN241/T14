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

local rwidth = T.InfoLeftRightWidth / 5 - 2.5

local function Shared(self, unit)
	self.colors = T.oUF_colors
	self:RegisterForClicks("AnyUp")
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	self.menu = T.SpawnMenu
	
	local t = CreateFrame("Frame", nil, self)
	t:CreatePanel("Default", rwidth, 20, "CENTER", self)
	t:SetFrameLevel(0)
	self.t = t		
	
	local health = CreateFrame('StatusBar', nil, self)
	health:SetFrameLevel(t:GetFrameLevel() + 1)
	health:SetFrameStrata(t:GetFrameStrata())
	health:Point("TOPLEFT", t, 2, -2)
	health:Point("BOTTOMRIGHT", t, -2, 2)
	health:SetStatusBarTexture(unpack(T.Textures.statusBars))
	self.Health = health

	local healthBG = health:CreateTexture(nil, 'BORDER')
	healthBG:SetAllPoints()
	self.Health.bg = healthBG
	
	self.Health.bg = health.bg
	
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
	
	local name = health:CreateFontString(nil, 'OVERLAY')
	name:SetFont(unpack(T.Fonts.uName.setfont))
	name:Point("CENTER", health, "CENTER", 0, 1)
	if C["unitframes"].unicolor then
		self:Tag(name, '[Tukui:leader][Tukui:getnamecolor][Tukui:name_short][Tukui:masterlooter][Tukui:dead][Tukui:afk]')
	else
		self:Tag(name, '[Tukui:leader][Tukui:name_short][Tukui:masterlooter][Tukui:dead][Tukui:afk]')
	end
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
	
	return self
end

oUF:RegisterStyle('TukuiDpsR25', Shared)
oUF:Factory(function(self)
	oUF:SetActiveStyle("TukuiDpsR25")

	local raid = self:SpawnHeader("TukuiDps25", nil, "custom [@raid16,exists] show;hide", 
		'oUF-initialConfigFunction', [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute('initial-width'))
			self:SetHeight(header:GetAttribute('initial-height'))
		]],
		'initial-width', rwidth,
		'initial-height', T.Scale(21),
		"showRaid", true, 
		"xOffset", T.Scale(3),
		"point", "LEFT",
		"groupFilter", "1,2,3,4,5,6,7,8", 
		"groupingOrder", "1,2,3,4,5,6,7,8", 
		"groupBy", "GROUP", 
		"maxColumns", 8,
		"unitsPerColumn", 5,
		"columnSpacing", 1,
		"columnAnchorPoint", "BOTTOM"
	)
	raid:SetPoint("BOTTOMLEFT", TukuiChatLeft, "TOPLEFT", 0, 2)
end)