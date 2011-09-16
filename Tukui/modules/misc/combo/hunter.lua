local T, C, L = unpack(select(2, ...))

if not C["combo"].display or not C["combo"].hunter or select(2, UnitClass("player")) ~= 'HUNTER' then return end

local id = nil
   
local function map(frame, ...)
	if frame then
		local func = frame:GetScript('OnEvent')
		if func then func(frame, 'UNIT_COMBO_POINTS', 'player') end
		return map(...)
	end
end
 
local frame = CreateFrame('frame')
frame:RegisterEvent('UNIT_AURA')
frame:RegisterEvent('UNIT_PET')
frame:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED') 
frame:RegisterEvent('PLAYER_TALENT_UPDATE') 
frame:RegisterEvent('INSPECT_TALENT_READY')
frame:SetScript('OnEvent', function(self, event)
	if GetPrimaryTalentTree() == 2 then
		local _,_,_,count = UnitBuff('player', GetSpellInfo(82925)) -- Ready, Set, Aim... 
		if count ~= id then
			id = count
			return map(GetFramesRegisteredForEvent('UNIT_COMBO_POINTS'))
		end
	elseif GetPrimaryTalentTree() == 1 then
		local _,_,_,count = UnitBuff('pet', GetSpellInfo(19615)) -- Frenzy Effect
		if count ~= id then
			id = count
			return map(GetFramesRegisteredForEvent('UNIT_COMBO_POINTS'))
		end
	end
end)
 
local UnitExists = UnitExists
local oldGetComboPoints = GetComboPoints
GetComboPoints = function(...)
	return (...) == 'player' and id or UnitExists('pet') and id or oldGetComboPoints(...)
end