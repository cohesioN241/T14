local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "Tukui was unable to locate oUF install.")

local T, C, L = unpack(select(2, ...))
if not C["unitframes"].enable == true then return end


T.UnitColor = setmetatable({
	tapped = T.Colors.tapped,
	disconnected = T.Colors.disconnected,
	power = setmetatable({
		["MANA"] 				= T.Colors.power["MANA"],
		["RAGE"] 				= T.Colors.power["RAGE"],
		["FOCUS"] 				= T.Colors.power["FOCUS"],
		["ENERGY"] 				= T.Colors.power["ENERGY"],
		["RUNES"] 				= T.Colors.power["RUNES"],
		["RUNIC_POWER"]			= T.Colors.power["RUNIC_POWER"],
		["AMMOSLOT"] 			= T.Colors.power["AMMOSLOT"],
		["FUEL"] 				= T.Colors.power["FUEL"],
		["POWER_TYPE_STEAM"] 	= T.Colors.power["POWER_TYPE_STEAM"],
		["POWER_TYPE_PYRITE"] 	= T.Colors.power["POWER_TYPE_PYRITE"],
	}, {__index = oUF.colors.power}),
	runes = setmetatable({
			[1] = T.Colors.runes[1],
			[2] = T.Colors.runes[2],
			[3] = T.Colors.runes[3],
			[4] = T.Colors.runes[4],
	}, {__index = oUF.colors.runes}),
	reaction = setmetatable({
		[1] = T.Colors.reaction[1], -- Hated
		[2] = T.Colors.reaction[2], -- Hostile
		[3] = T.Colors.reaction[3], -- Unfriendly
		[4] = T.Colors.reaction[4], -- Neutral
		[5] = T.Colors.reaction[5], -- Friendly
		[6] = T.Colors.reaction[6], -- Honored
		[7] = T.Colors.reaction[7], -- Revered
		[8] = T.Colors.reaction[8], -- Exalted	
	}, {__index = oUF.colors.reaction}),
	class = setmetatable({
		["DEATHKNIGHT"] = T.Colors.class["DEATHKNIGHT"],
		["DRUID"]       = T.Colors.class["DRUID"],
		["HUNTER"]      = T.Colors.class["HUNTER"],
		["MAGE"]        = T.Colors.class["MAGE"],
		["PALADIN"]     = T.Colors.class["PALADIN"],
		["PRIEST"]      = T.Colors.class["PRIEST"],
		["ROGUE"]       = T.Colors.class["ROGUE"],
		["SHAMAN"]      = T.Colors.class["SHAMAN"],
		["WARLOCK"]     = T.Colors.class["WARLOCK"],
		["WARRIOR"]     = T.Colors.class["WARRIOR"],
	}, {__index = oUF.colors.class}),
}, {__index = oUF.colors})

T.ColorTemplate = T.UnitColor