local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
if not C["unitframes"].enable == true then return end

------------------------------------------------------------------------
--	unitframes Functions
------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "Tukui was unable to locate oUF install.")

T.updateAllElements = function(frame)
	for _, v in ipairs(frame.__elements) do
		v(frame, "UpdateElement", frame.unit)
	end
end

local SetUpAnimGroup = function(self)
	self.anim = self:CreateAnimationGroup("Flash")
	self.anim.fadein = self.anim:CreateAnimation("ALPHA", "FadeIn")
	self.anim.fadein:SetChange(1)
	self.anim.fadein:SetOrder(2)

	self.anim.fadeout = self.anim:CreateAnimation("ALPHA", "FadeOut")
	self.anim.fadeout:SetChange(-1)
	self.anim.fadeout:SetOrder(1)
end

local Flash = function(self, duration)
	if not self.anim then
		SetUpAnimGroup(self)
	end

	self.anim.fadein:SetDuration(duration)
	self.anim.fadeout:SetDuration(duration)
	self.anim:Play()
end

local StopFlash = function(self)
	if self.anim then
		self.anim:Finish()
	end
end

T.SpawnMenu = function(self)
	local unit = self.unit:gsub("(.)", string.upper, 1)
	if unit == "Targettarget" or unit == "focustarget" or unit == "pettarget" then return end

	if _G[unit.."FrameDropDown"] then
		ToggleDropDownMenu(1, nil, _G[unit.."FrameDropDown"], "cursor")
	elseif (self.unit:match("party")) then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor")
	else
		FriendsDropDown.unit = self.unit
		FriendsDropDown.id = self.id
		FriendsDropDown.initialize = RaidFrameDropDown_Initialize
		ToggleDropDownMenu(1, nil, FriendsDropDown, "cursor")
	end
end

T.PostUpdatePower = function(element, unit, min, max)
	element:GetParent().Health:SetHeight(max ~= 0 and 20 or 22)
end

local ShortValue = function(value)
	if value >= 1e6 then
		return ("%.1fm"):format(value / 1e6):gsub("%.?0+([km])$", "%1")
	elseif value >= 1e3 or value <= -1e3 then
		return ("%.1fk"):format(value / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return value
	end
end

local ShortValueNegative = function(v)
	if v <= 999 then return v end
	if v >= 1000000 then
		local value = string.format("%.1fm", v/1000000)
		return value
	elseif v >= 1000 then
		local value = string.format("%.1fk", v/1000)
		return value
	end
end

T.PostUpdateHealth = function(health, unit, min, max)
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		if not UnitIsConnected(unit) then
			health.value:SetText("|cffe45050"..L.unitframes_ouf_offline.."|r")
		elseif UnitIsDead(unit) then
			health.value:SetText("|cffe45050"..L.unitframes_ouf_dead.."|r")
		elseif UnitIsGhost(unit) then
			health.value:SetText("|cffe45050"..L.unitframes_ouf_ghost.."|r")
		end
	else
		local r, g, b
		
		-- overwrite healthbar color for enemy player (a tukui option if enabled), target vehicle/pet too far away returning unitreaction nil and friend unit not a player. (mostly for overwrite tapped for friendly)
		-- I don't know if we really need to call C["unitframes"].unicolor but anyway, it's safe this way.
		if (C["unitframes"].unicolor ~= true and C["unitframes"].enemyhcolor and unit == "target" and UnitIsEnemy(unit, "player") and UnitIsPlayer(unit)) or (C["unitframes"].unicolor ~= true and unit == "target" and not UnitIsPlayer(unit) and UnitIsFriend(unit, "player")) then
			local c = T.oUF_colors.reaction[UnitReaction(unit, "player")]
			if c then 
				r, g, b = c[1], c[2], c[3]
				health:SetStatusBarColor(r, g, b)
			else
				-- if "c" return nil it's because it's a vehicle or pet unit too far away, we force friendly color
				-- this should fix color not updating for vehicle/pet too far away from yourself.
				r, g, b = 75/255,  175/255, 76/255
				health:SetStatusBarColor(r, g, b)
			end					
		end

		if min ~= max then
			local r, g, b
			r, g, b = oUF.ColorGradient(min/max, 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33)
			if unit == "player" and health:GetAttribute("normalUnit") ~= "pet" then
				if C["unitframes"].showtotalhpmp == true then
					health.value:SetFormattedText("|cff559655%s|r |cffD7BEA5|||r |cff559655%s|r", ShortValue(min), ShortValue(max))
				else
					health.value:SetFormattedText("|cffAF5050%d|r |cffD7BEA5-|r |cff%02x%02x%02x%d%%|r", min, r * 255, g * 255, b * 255, floor(min / max * 100))
					--health.value:SetText("|cff559655"..floor(min / max * 100).."%".."|r")
				end
			elseif unit == "target" or (unit and unit:find("boss%d")) then
				if C["unitframes"].showtotalhpmp == true then
					health.value:SetFormattedText("|cff559655%s|r |cffD7BEA5|||r |cff559655%s|r", ShortValue(min), ShortValue(max))
				else
					health.value:SetFormattedText("|cffAF5050%s|r |cffD7BEA5-|r |cff%02x%02x%02x%d%%|r", ShortValue(min), r * 255, g * 255, b * 255, floor(min / max * 100))
					--health.value:SetText("|cff559655"..floor(min / max * 100).."%".."|r")
				end
			elseif (unit and unit:find("arena%d")) or unit == "focus" or unit == "focustarget" then
				health.value:SetText("|cff559655"..ShortValue(min).."|r")
				--health.value:SetText("|cff559655"..floor(min / max * 100).."%".."|r")
			else
				health.value:SetText("|cff559655-"..ShortValueNegative(max-min).."|r")
				--health.value:SetText("|cff559655-"..floor(min / max * 100).."%".."|r")
			end
		else
			if unit == "player" and health:GetAttribute("normalUnit") ~= "pet" then
				health.value:SetText("|cff559655"..max.."|r")
				--health.value:SetText("|cff559655"..floor(min / max * 100).."%".."|r")
			elseif unit == "target" or unit == "focus"  or unit == "focustarget" or (unit and unit:find("arena%d")) then
				health.value:SetText("|cff559655"..ShortValue(max).."|r")
				--health.value:SetText("|cff559655"..floor(min / max * 100).."%".."|r")
			else
				health.value:SetText(" ")
			end
		end
	end
end

T.PostUpdateHealthRaid = function(health, unit, min, max)
	if (not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit)) and (not unit:find('partypet%d')) then
		if not UnitIsConnected(unit) then
			health.value:SetText("|cffe45050"..L.unitframes_ouf_offline.."|r")
			health:SetStatusBarColor(.8, .3, .3) -- Red health if offline/dead/dc'd
		elseif UnitIsDead(unit) then
			health.value:SetText("|cffe45050"..L.unitframes_ouf_dead.."|r")
		elseif UnitIsGhost(unit) then
			health.value:SetText("|cffe45050"..L.unitframes_ouf_ghost.."|r")
		end
	else
		-- doing this here to force friendly unit (vehicle or pet) very far away from you to update color correcly
		-- because if vehicle or pet is too far away, unitreaction return nil and color of health bar is white.
		if not UnitIsPlayer(unit) and UnitIsFriend(unit, "player") and C["unitframes"].unicolor ~= true then
			local c = T.oUF_colors.reaction[5]
			local r, g, b = c[1], c[2], c[3]
			health:SetStatusBarColor(r, g, b)
			health.bg:SetTexture(.1, .1, .1)
		end

		-- health deficit gradient, credits to Hydra
		if C.unitframes.gradienthealth and C.unitframes.unicolor then
			if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then return end
			if not health.classcolored then
				local r, g, b = oUF.ColorGradient(min/max, unpack(C["media"].gradienthealth))
				health:SetStatusBarColor(r, g, b)
			end
		end
		
		if not unit:find('partypet%d') then
			if min ~= max then
				health.value:SetText("|cff559655-"..ShortValueNegative(max-min).."|r")
			else
				health.value:SetText(" ")
			end
		end
	end
end

T.PostUpdatePetColor = function(health, unit, min, max)
	-- doing this here to force friendly unit (vehicle or pet) very far away from you to update color correcly
	-- because if vehicle or pet is too far away, unitreaction return nil and color of health bar is white.
	if not UnitIsPlayer(unit) and UnitIsFriend(unit, "player") and C["unitframes"].unicolor ~= true then
		local c = T.oUF_colors.reaction[5]
		local r, g, b = c[1], c[2], c[3]

		health:SetStatusBarColor(r, g, b)
		health.bg:SetTexture(.1, .1, .1)
	end
end

T.PostNamePosition = function(self)
	self.Name:ClearAllPoints()
	self.Name:SetShadowOffset(1.25, -1.25)
	if (self.Power.value:GetText() and UnitIsEnemy("player", "target") and C["unitframes"].targetpowerpvponly == true) or (self.Power.value:GetText() and C["unitframes"].targetpowerpvponly == false) then
		self.Name:SetPoint("CENTER", self.Health, "CENTER", 0, 1)
		self.Power:SetPoint("LEFT", self.Health, "LEFT", 7, 1)
	else
		self.Power.value:SetAlpha(0)
		if C["unitframes"].style == "Cohesion" then
			self.Name:SetPoint("LEFT", self.Health, "LEFT", 7, 1)
		else
			self.Name:SetPoint("LEFT", self.panel, "LEFT", 4, 1)
		end
	end
end

T.PreUpdatePower = function(power, unit)
	local _, pType = UnitPowerType(unit)
	
	local color = T.oUF_colors.power[pType]
	if color then
		power:SetStatusBarColor(color[1], color[2], color[3])
	end
end

T.PostUpdatePower = function(power, unit, min, max)
	local self = power:GetParent()
	local pType, pToken = UnitPowerType(unit)
	local color = T.oUF_colors.power[pToken]

	if color then
		power.value:SetTextColor(color[1], color[2], color[3])
	end

	if not UnitIsPlayer(unit) and not UnitPlayerControlled(unit) or not UnitIsConnected(unit) then
		power.value:SetText()
	elseif UnitIsDead(unit) or UnitIsGhost(unit) then
		power.value:SetText()
	else
		if min ~= max then
			if pType == 0 then
				if unit == "target" then
					if C["unitframes"].showtotalhpmp == true then
						power.value:SetFormattedText("%s |cffD7BEA5|||r %s", ShortValue(max - (max - min)), ShortValue(max))
					else
						power.value:SetFormattedText("%d%% |cffD7BEA5-|r %s", floor(min / max * 100), ShortValue(max - (max - min)))
						--power.value:SetText(floor(min / max * 100).."%")
					end
				elseif unit == "player" and self:GetAttribute("normalUnit") == "pet" or unit == "pet" then
					if C["unitframes"].showtotalhpmp == true then
						power.value:SetFormattedText("%s |cffD7BEA5|||r %s", ShortValue(max - (max - min)), ShortValue(max))
					else
						power.value:SetFormattedText("%d%%", floor(min / max * 100))
						--power.value:SetText(floor(min / max * 100).."%")
					end
				elseif (unit and unit:find("arena%d")) or unit == "focus" or unit == "focustarget" then
					power.value:SetText(ShortValue(min))
				else
					if C["unitframes"].showtotalhpmp == true then
						power.value:SetFormattedText("%s |cffD7BEA5|||r %s", ShortValue(max - (max - min)), ShortValue(max))
					else
						power.value:SetFormattedText("%d%% |cffD7BEA5-|r %d", floor(min / max * 100), max - (max - min))
						--power.value:SetText(floor(min / max * 100).."%")
					end
				end
			else
				power.value:SetText(max - (max - min))
			end
		else
			if pType == 0 then
				if unit == "pet" or unit == "target" or unit == "focus" or unit == "focustarget" or (unit and unit:find("arena%d")) then
					power.value:SetText(ShortValue(min))
					--power.value:SetText(floor(min / max * 100).."%")
				else
					power.value:SetText(min)
					--power.value:SetText(floor(min / max * 100).."%")
				end
			else
				power.value:SetText(max - (max - min))
			end
		end
	end
	if self.Name then
		if unit == "target" then T.PostNamePosition(self, power) end
	end
end

T.CustomCastTimeText = function(self, duration)
	self.Time:SetText(("%.1f / %.1f"):format(self.channeling and duration or self.max - duration, self.max))
end

T.CustomCastDelayText = function(self, duration)
	self.Time:SetText(("%.1f |cffaf5050%s %.1f|r"):format(self.channeling and duration or self.max - duration, self.channeling and "- " or "+", self.delay))
end

local FormatTime = function(s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		return format("%dd", ceil(s / day))
	elseif s >= hour then
		return format("%dh", ceil(s / hour))
	elseif s >= minute then
		return format("%dm", ceil(s / minute))
	elseif s >= minute / 12 then
		return floor(s)
	end
	return format("%.1f", s)
end

local CreateAuraTimer = function(self, elapsed)
	if self.timeLeft then
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed >= 0.1 then
			if not self.first then
				self.timeLeft = self.timeLeft - self.elapsed
			else
				self.timeLeft = self.timeLeft - GetTime()
				self.first = false
			end
			if self.timeLeft > 0 then
				local time = FormatTime(self.timeLeft)
				self.remaining:SetText(time)
				if self.timeLeft <= 5 then
					self.remaining:SetTextColor(0.99, 0.31, 0.31)
				else
					self.remaining:SetTextColor(1, 1, 1)
				end
			else
				self.remaining:Hide()
				self:SetScript("OnUpdate", nil)
			end
			self.elapsed = 0
		end
	end
end

T.PostCreateAura = function(element, button)
	button:SetTemplate("Default")
	button:CreateShadow("Default")
	
	button.remaining = T.SetFontString(button, unpack(T.Fonts.uAuras.setfont))
	button.remaining:Point("CENTER", 1, 4)
	
	button.cd.noOCC = true		 	-- hide OmniCC CDs
	button.cd.noCooldownCount = true	-- hide CDC CDs
	
	button.cd:SetReverse()
	button.icon:Point("TOPLEFT", 2, -2)
	button.icon:Point("BOTTOMRIGHT", -2, 2)
	button.icon:SetTexCoord(.09, .91, .09, .91)
	button.icon:SetDrawLayer('ARTWORK')
	
	button.count:Point("BOTTOMRIGHT", -1, 1)
	button.count:SetJustifyH("RIGHT")
	button.count:SetFont(unpack(T.Fonts.uAuras.setfont))
	button.count:SetTextColor(0.84, 0.75, 0.65)
	
	button.overlayFrame = CreateFrame("frame", nil, button, nil)
	button.cd:SetFrameLevel(button:GetFrameLevel() + 1)
	button.cd:ClearAllPoints()
	button.cd:Point("TOPLEFT", button, "TOPLEFT", 2, -2)
	button.cd:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
	button.overlayFrame:SetFrameLevel(button.cd:GetFrameLevel() + 1)	   
	button.overlay:SetParent(button.overlayFrame)
	button.count:SetParent(button.overlayFrame)
	button.remaining:SetParent(button.overlayFrame)
end

T.PostUpdateAura = function(icons, unit, icon, index, offset, filter, isDebuff, duration, timeLeft)
	local _, _, _, _, dtype, duration, expirationTime, unitCaster, _ = UnitAura(unit, index, icon.filter)

	if(icon.debuff) then
		if(not UnitIsFriend("player", unit) and icon.owner ~= "player" and icon.owner ~= "vehicle") then
			icon:SetBackdropBorderColor(unpack(C["media"].bordercolor))
			icon.icon:SetDesaturated(true)
		else
			local color = DebuffTypeColor[dtype] or DebuffTypeColor.none
			icon:SetBackdropBorderColor(color.r * 0.6, color.g * 0.6, color.b * 0.6)
			icon.icon:SetDesaturated(false)
		end
	else
		if (isStealable or ((T.myclass == "MAGE" or T.myclass == "PRIEST" or T.myclass == "SHAMAN") and dtype == "Magic")) and not UnitIsFriend("player", unit) then
			icon:SetBackdropBorderColor(1, 0.85, 0, 1)
		else
			icon:SetBackdropBorderColor(unpack(C.media.bordercolor))
		end
	end
	
	if duration and duration > 0 then
		if C["unitframes"].auratimer == true then
			icon.remaining:Show()
		else
			icon.remaining:Hide()
		end
	else
		icon.remaining:Hide()
	end
 
	icon.duration = duration
	icon.timeLeft = expirationTime
	icon.first = true
	
	if T.ReverseTimer and T.ReverseTimer[spellID] then
		icon.reverse = true
	else
		icon.reverse = false
	end
	
	icon:SetScript("OnUpdate", CreateAuraTimer)
end

T.HidePortrait = function(self, unit)
	if self.unit == "target" then
		if not UnitExists(self.unit) or not UnitIsConnected(self.unit) or not UnitIsVisible(self.unit) then
			self.Portrait:SetAlpha(0)
		else
			self.Portrait:SetAlpha(1)
		end
	end
end

T.PortraitUpdate = function(self, unit)
	--Fucking Furries
	if self:GetModel() and self:GetModel().find and self:GetModel():find("worgenmale") then
		self:SetCamera(1)
	else
		self:SetCamera(0)
	end
end

local CheckInterrupt = function(self, unit)
	if unit == "vehicle" then unit = "player" end

	if self.interrupt and UnitCanAttack("player", unit) then
		self:SetStatusBarColor(1, 0, 0, 0.5)	
	else
		if C["unitframes"].cbclasscolor == true then
			self:SetStatusBarColor(unpack(oUF.colors.class[select(2, UnitClass(unit))]))
		else
			self:SetStatusBarColor(unpack(C["unitframes"].cbcustomcolor))		
		end
	end
end

T.CheckCast = function(self, unit, name, rank, castid)
	CheckInterrupt(self, unit)
end

T.CheckChannel = function(self, unit, name, rank)
	CheckInterrupt(self, unit)
end

T.UpdateShards = function(self, event, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= 'SOUL_SHARDS')) then return end
	local num = UnitPower(unit, SPELL_POWER_SOUL_SHARDS)
	for i = 1, SHARD_BAR_NUM_SHARDS do
		if(i <= num) then
			self.SoulShards[i]:SetAlpha(1)
		else
			self.SoulShards[i]:SetAlpha(.2)
		end
	end
end

T.Phasing = function(self, event)
	local inPhase = UnitInPhase(self.unit)
	local picon = self.PhaseIcon

	if not UnitIsPlayer(self.unit) then picon:Hide() return end

	-- TO BE COMPLETED
end

T.UpdateHoly = function(self, event, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= 'HOLY_POWER')) then return end
	local num = UnitPower(unit, SPELL_POWER_HOLY_POWER)
	for i = 1, MAX_HOLY_POWER do
		if(i <= num) then
			self.HolyPower[i]:SetAlpha(1)
		else
			self.HolyPower[i]:SetAlpha(.2)
		end
	end
end

T.EclipseDirection = function(self)
	if ( GetEclipseDirection() == "sun" ) then
			self.Text:SetText("|cffE5994C"..L.unitframes_ouf_starfirespell.."|r")
	elseif ( GetEclipseDirection() == "moon" ) then
			self.Text:SetText("|cff4478BC"..L.unitframes_ouf_wrathspell.."|r")
	else
			self.Text:SetText("")
	end
end

T.DruidBarDisplay = function(self, login)
	local eb = self.EclipseBar
	local dm = self.DruidMana
	local txt = self.EclipseBar.Text
	local bg = self.DruidManaBackground
	local buffs = self.Buffs
	local flash = self.FlashInfo

	if login then
		dm:SetScript("OnUpdate", nil)
	end
	
	if eb:IsShown() or dm:IsShown() then
		if eb:IsShown() then
			txt:Show()
			flash:Hide()
		end
		bg:SetAlpha(1)
		if buffs then buffs:SetPoint("BOTTOMLEFT", self.ufbg, "TOPLEFT", 0, 7) end
	else
		txt:Hide()
		flash:Hide()
		bg:SetAlpha(0)
		if buffs then buffs:SetPoint("BOTTOMLEFT", self.ufbg, "TOPLEFT", 0, 3) end
	end
end

T.MLAnchorUpdate = function (self)
	if self.Leader:IsShown() then
		self.MasterLooter:SetPoint("TOPLEFT", 14, 8)
	else
		self.MasterLooter:SetPoint("TOPLEFT", 2, 8)
	end
end

T.UpdateName = function(self,event)
	if self.Name then self.Name:UpdateTag(self.unit) end
end

local UpdateManaLevelDelay = 0
T.UpdateManaLevel = function(self, elapsed)
	UpdateManaLevelDelay = UpdateManaLevelDelay + elapsed
	if self.parent.unit ~= "player" or UpdateManaLevelDelay < 0.2 or UnitIsDeadOrGhost("player") or UnitPowerType("player") ~= 0 then return end
	UpdateManaLevelDelay = 0

	local percMana = UnitMana("player") / UnitManaMax("player") * 100

	if percMana <= C.unitframes.lowThreshold then
		self.ManaLevel:SetText("|cffaf5050"..L.unitframes_ouf_lowmana.."|r")
		Flash(self, 0.3)
	else
		self.ManaLevel:SetText()
		StopFlash(self)
	end
end

T.UpdateDruidMana = function(self)
	if self.unit ~= "player" then return end

	local num, str = UnitPowerType("player")
	if num ~= 0 then
		local min = UnitPower("player", 0)
		local max = UnitPowerMax("player", 0)

		local percMana = min / max * 100
		if percMana <= C["unitframes"].lowThreshold then
			self.FlashInfo.ManaLevel:SetText("|cffaf5050"..L.unitframes_ouf_lowmana.."|r")
			Flash(self.FlashInfo, 0.3)
		else
			self.FlashInfo.ManaLevel:SetText()
			StopFlash(self.FlashInfo)
		end

		if min ~= max then
			if self.Power.value:GetText() then
				self.DruidManaText:SetPoint("LEFT", self.Power.value, "RIGHT", 1, 0)
				self.DruidManaText:SetFormattedText("|cffD7BEA5-|r  |cff4693FF%d%%|r|r", floor(min / max * 100))
			else
				self.DruidManaText:SetPoint("LEFT", self.panel, "LEFT", 4, 1)
				self.DruidManaText:SetFormattedText("%d%%", floor(min / max * 100))
			end
		else
			self.DruidManaText:SetText()
		end

		self.DruidManaText:SetAlpha(1)
	else
		self.DruidManaText:SetAlpha(0)
	end
end

T.UpdateThreat = function(self, event, unit)
	if (self.unit ~= unit) or (unit == "target" or unit == "pet" or unit == "focus" or unit == "focustarget" or unit == "targettarget") then return end
	local threat = UnitThreatSituation(self.unit)
	if (threat == 3) then
		if self.panel then
			self.panel:SetBackdropBorderColor(.69,.31,.31,1)
		else
			self.Name:SetTextColor(1,0.1,0.1)
		end
		if self.ufbg then
			self.ufbg:SetBackdropColor(.69,.31,.31,1)
		elseif self.t then
			self.t:SetBackdropBorderColor(.69,.31,.31,1)
			
			if self.tt then
				self.tt:SetBackdropBorderColor(.69,.31,.31,1)
			end
		end
	else
		if self.panel then
			self.panel:SetBackdropBorderColor(unpack(C["media"].bordercolor))
		else
			self.Name:SetTextColor(1,1,1)
		end
		
		if self.ufbg then
			self.ufbg:SetBackdropColor(unpack(C["media"].bordercolor))
		elseif self.t then
			self.t:SetBackdropBorderColor(unpack(C["media"].bordercolor))
			
			if self.tt then
				self.tt:SetBackdropBorderColor(unpack(C["media"].bordercolor))
			end
		end
	end 
end

--------------------------------------------------------------------------------------------
-- THE AURAWATCH FUNCTION ITSELF. HERE BE DRAGONS!
--------------------------------------------------------------------------------------------

T.countOffsets = {
	TOPLEFT = {6, 1},
	TOPRIGHT = {-6, 1},
	BOTTOMLEFT = {6, 1},
	BOTTOMRIGHT = {-6, 1},
	LEFT = {6, 1},
	RIGHT = {-6, 1},
	TOP = {0, 0},
	BOTTOM = {0, 0},
}

T.CreateAuraWatchIcon = function(self, icon)
	icon:SetTemplate("Default")
	icon.icon:Point("TOPLEFT", 1, -1)
	icon.icon:Point("BOTTOMRIGHT", -1, 1)
	icon.icon:SetTexCoord(.09, .91, .09, .91)
	icon.icon:SetDrawLayer("ARTWORK")
	if (icon.cd) then
		icon.cd:SetReverse()
	end
	icon.overlay:SetTexture()
end

T.createAuraWatch = function(self, unit)
	local auras = CreateFrame("Frame", nil, self)
	auras:SetPoint("TOPLEFT", self.Health, 2, -2)
	auras:SetPoint("BOTTOMRIGHT", self.Health, -2, 2)
	auras.presentAlpha = 1
	auras.missingAlpha = 0
	auras.icons = {}
	auras.PostCreateIcon = T.CreateAuraWatchIcon

	if (not C["unitframes"].auratimer) then
		auras.hideCooldown = true
	end

	local buffs = {}

	if (T.buffids["ALL"]) then
		for key, value in pairs(T.buffids["ALL"]) do
			tinsert(buffs, value)
		end
	end

	if (T.buffids[T.myclass]) then
		for key, value in pairs(T.buffids[T.myclass]) do
			tinsert(buffs, value)
		end
	end

	-- "Cornerbuffs"
	if (buffs) then
		for key, spell in pairs(buffs) do
			local icon = CreateFrame("Frame", nil, auras)
			icon.spellID = spell[1]
			icon.anyUnit = spell[4]
			icon:SetWidth(6)
			icon:SetHeight(6)
			icon:SetPoint(spell[2], 0, 0)

			local tex = icon:CreateTexture(nil, "OVERLAY")
			tex:SetAllPoints(icon)
			tex:SetTexture(C.media.blank)
			if (spell[3]) then
				tex:SetVertexColor(unpack(spell[3]))
			else
				tex:SetVertexColor(0.8, 0.8, 0.8)
			end

			local count = icon:CreateFontString(nil, "OVERLAY")
			count:SetFont(C["media"].pixel_font, 12, "MONOCHROMEOUTLINE")
			count:SetPoint("CENTER", unpack(T.countOffsets[spell[2]]))
			icon.count = count

			auras.icons[spell[1]] = icon
		end
	end
	
	self.AuraWatch = auras
end

if C["unitframes"].raidunitdebuffwatch == true then
	-- Classbuffs { spell ID, position [, {r,g,b,a}][, anyUnit] }
	-- For oUF_AuraWatch
	do
		T.buffids = {
			PRIEST = {
				{6788, "TOPLEFT", {1, 0, 0}, true}, -- Weakened Soul
				{33076, "TOPRIGHT", {0.2, 0.7, 0.2}}, -- Prayer of Mending
				{139, "BOTTOMLEFT", {0.4, 0.7, 0.2}}, -- Renew
				{17, "BOTTOMRIGHT", {0.81, 0.85, 0.1}, true}, -- Power Word: Shield
			},
			DRUID = {
				{774, "TOPLEFT", {0.8, 0.4, 0.8}}, -- Rejuvenation
				{8936, "TOPRIGHT", {0.2, 0.8, 0.2}}, -- Regrowth
				{33763, "BOTTOMLEFT", {0.4, 0.8, 0.2}}, -- Lifebloom
				{48438, "BOTTOMRIGHT", {0.8, 0.4, 0}}, -- Wild Growth
			},
			PALADIN = {
				{53563, "TOPLEFT", {0.7, 0.3, 0.7}}, -- Beacon of Light
			},
			SHAMAN = {
				{61295, "TOPLEFT", {0.7, 0.3, 0.7}}, -- Riptide 
				{51945, "TOPRIGHT", {0.2, 0.7, 0.2}}, -- Earthliving
				{16177, "BOTTOMLEFT", {0.4, 0.7, 0.2}}, -- Ancestral Fortitude
				{974, "BOTTOMRIGHT", {0.7, 0.4, 0}, true}, -- Earth Shield
			},
			ALL = {
				{14253, "RIGHT", {0, 1, 0}}, -- Abolish Poison
				{23333, "LEFT", {1, 0, 0}}, -- Warsong flag xD
			},
		}
	end
		local _, ns = ...
	-- Raid debuffs (now using it with oUF_RaidDebuff instead of oUF_Aurawatch)
	do
		local ORD = ns.oUF_RaidDebuffs or oUF_RaidDebuffs

		if not ORD then return end
		
		ORD.ShowDispelableDebuff = true
		ORD.FilterDispellableDebuff = true
		ORD.MatchBySpellName = false

		T.debuffids = {
			-- Other debuff
			67479, -- Impale
			
			--CATA DEBUFFS
		-- Baradin Hold
			95173, -- Consuming Darkness
			
		-- Blackwing Descent
			-- Magmaw
			91911, -- Constricting Chains
			94679, -- Parasitic Infection
			94617, -- Mangle
			
			-- Omnotron Defense System
			79835, -- Poison Soaked Shell	
			91433, -- Lightning Conductor
			91521, -- Incineration Security Measure
			
			-- Maloriak
			77699, -- Flash Freeze
			77760, -- Biting Chill
			
			-- Atramedes
			92423, -- Searing Flame
			92485, -- Roaring Flame
			92407, -- Sonic Breath
			
			-- Chimaeron
			82881, -- Break
			89084, -- Low Health
			
			-- Nefarian
			79339, -- (Heroic) Explosive Cinders
			
		-- The Bastion of Twilight
			-- Valiona & Theralion
			92878, -- Blackout
			86840, -- Devouring Flames
			95639, -- Engulfing Magic
			
			-- Halfus Wyrmbreaker
			39171, -- Malevolent Strikes
			
			-- Twilight Ascendant Council
			92511, -- Hydro Lance
			82762, -- Waterlogged
			92505, -- Frozen
			92518, -- Flame Torrent
			83099, -- Lightning Rod
			92075, -- Gravity Core
			92488, -- Gravity Crush
			
			-- Cho'gall
			86028, -- Cho's Blast
			86029, -- Gall's Blast
			
			-- Sinestra
			92956, -- Wrack
			
		-- Throne of the Four Winds
			-- Conclave of Wind
				-- Nezir <Lord of the North Wind>
				93131, -- Ice Patch
				-- Anshal <Lord of the West Wind>
				86206, -- Soothing Breeze
				93122, -- Toxic Spores
				-- Rohash <Lord of the East Wind>
				93058, -- Slicing Gale 

			-- Al'Akir
			93260, -- Ice Storm
			93295, -- Lightning Rod
			
		-- Rise of the Zandalari
			-- Zul'Aman
				-- Akil'zon <Eagle Avatar>
				97298, -- Static Disruption
				-- Nalorakk <Bear Avatar>
				42402, -- Surge
				-- Jan'alai <Dragonhawk Avatar>
				43299, -- Flame Buffet
				-- Daakara <The Invincible>
				97639, -- Grievous Throw	
			-- Zul'Gurub
				-- High Priest Venoxis
				96466, -- Whispers of Hethiss
				96475, -- Toxic Link
				-- Bloodlord Mandokir
				96776, -- Bloodletting
				-- High Priestess Kilnara
				96958, -- Lash of Anguish
				
		-- Firelands, thanks Kaelhan :)
			-- Beth'tilac
				99506,	-- Widows Kiss
				97202,	-- Fiery Web Spin
				49026,	-- Fixate
				97079,	-- Seeping Venom
			-- Lord Rhyolith
				-- none, hehe, fake boss
			-- Alysrazor
				101296,	-- Fieroblast
				100723,	-- Gushing Wound
				99389,	-- Imprinted
				101729,	-- Blazing Claw
			-- Shannox
				99837,	-- Crystal Prison
				99937,	-- Jagged Tear
			-- Baleroc
				99256,	-- Torment
				100231,	-- Torment
				99252,	-- Blaze of Glory
				99516,	-- Countdown
			-- Majordomo Staghelm
				98450,	-- Searing Seeds
			-- Ragnaros
				99399,	-- Burning Wound
				100293,	-- Lava Wave
				98313,	-- Magma Blast
				100675,	-- Dreadflame
			--Trash
			99532, -- Melt Armor
		}
		
		T.ReverseTimer = {
			[92956] = true, -- Sinestra (Wrack)
			[89435] = true, -- Sinestra (Wrack)
			[92955] = true, -- Sinestra (Wrack)
			[89421] = true, -- Sinestra (Wrack)
		},
		
		ORD:RegisterDebuffs(T.debuffids)
	end
end