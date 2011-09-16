local T, C, L = unpack(select(2, ...))

if not C["combo"].display or not C["combo"].shaman or select(2, UnitClass("player")) ~= 'SHAMAN' then return end  

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
frame:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED') 
frame:RegisterEvent('PLAYER_TALENT_UPDATE') 
frame:RegisterEvent('INSPECT_TALENT_READY')
frame:SetScript('OnEvent', function(self, event)
	if GetPrimaryTalentTree() == 1 then
		local _,_,_,count = UnitBuff('player', GetSpellInfo(324)) -- Lightning Shield (Fulmination)
		if count then
			if count > 3 then
				count = count - 3
			else
				count = 0
			end
		end
		if count ~= id then
			id = count
			return map(GetFramesRegisteredForEvent('UNIT_COMBO_POINTS'))
		end
	elseif GetPrimaryTalentTree() == 2 then
		local _,_,_,count = UnitBuff('player', GetSpellInfo(53817)) -- Maelstrom Weapon
		if count ~= id then
			id = count
			return map(GetFramesRegisteredForEvent('UNIT_COMBO_POINTS'))
		end
	elseif GetPrimaryTalentTree() == 3 then
		local _,_,_,count = UnitBuff('player', GetSpellInfo(53390)) -- Tidal Waves
		if count ~= id then
			id = count
			return map(GetFramesRegisteredForEvent('UNIT_COMBO_POINTS'))
		end
	end
end)
 
local oldGetComboPoints = GetComboPoints
GetComboPoints = function(...)
	return (...) == 'player' and id or oldGetComboPoints(...)
end