local T, C, L = unpack(select(2, ...))

if not C["combo"].display or not C["combo"].paladin or select(2, UnitClass("player")) ~= 'PALADIN' then return end

local id = nil
   
local function map(frame, ...)
	if frame then
		local func = frame:GetScript('OnEvent')
		if func then func(frame, 'UNIT_COMBO_POINTS', 'player') end
		return map(...)
	end
end
 
local frame = CreateFrame('frame')
frame:RegisterEvent('UNIT_POWER')
frame:SetScript('OnEvent', function(self,event, ...)
local unit = select(1, ...)
    local count = UnitPower('player', SPELL_POWER_HOLY_POWER)
    if count ~= id then
        id = count
        return map(GetFramesRegisteredForEvent('UNIT_COMBO_POINTS'))
    end
end)
 
local oldGetComboPoints = GetComboPoints
GetComboPoints = function(...)
	return (...) == 'player' and id or oldGetComboPoints(...)
end