local T, C, L = unpack(select(2, ...))

if not C["combo"].display or not C["combo"].warlock or select(2, UnitClass("player")) ~= 'WARLOCK' then return end
 
local id = nil 

local function map(frame, ...) 
	if frame then 
		local func = frame:GetScript('OnEvent') 
		if func then func(frame, 'UNIT_COMBO_POINTS', 'player') end 
		return map(...) 
	end 
end 
 
local frame = CreateFrame('frame') 
frame:RegisterEvent('PLAYER_REGEN_ENABLED') 
frame:RegisterEvent('PLAYER_REGEN_DISABLED') 
frame:RegisterEvent('UNIT_POWER') 
frame:RegisterEvent('UNIT_DISPLAYPOWER') 
frame:SetScript('OnEvent', function(self,event, ...) 
local unit = select(1, ...) 
    if UnitAffectingCombat('player') then 
		CCP:Show()
		local count = UnitPower('player', SPELL_POWER_SOUL_SHARDS) 
		if count ~= id then 
			id = count 
			return map(GetFramesRegisteredForEvent('UNIT_COMBO_POINTS')) 
		end
	elseif not UnitAffectingCombat('player') then
		CCP:Hide()
	end 
end) 
 
local oldGetComboPoints = GetComboPoints 
GetComboPoints = function(...) 
    return (...) == 'player' and id or oldGetComboPoints(...) 
end 