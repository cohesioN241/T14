-- Localized langs for Smelly MarkBar (cutie)
MarkBarLocal = { }
local client = GetLocale() 

MarkBarLocal.button_Clear = "Clear Target"
MarkBarLocal.button_MarkBar = "Mark Bar"

if client == "frFR" then -- French
	MarkBarLocal.button_Clear = "Supprimer l'objectif"
	MarkBarLocal.button_MarkBar = "Barre de symboles"
elseif client == "deDE" then -- German
	MarkBarLocal.button_Clear = "Ziel l��en"
	MarkBarLocal.button_MarkBar = "Raidsymbol-Leiste"
elseif client == "koKR" then -- Korean
	MarkBarLocal.button_Clear = "?𶙍𶢍"
	MarkBarLocal.button_MarkBar = "𶑀ퟦ�"
elseif client == "ruRU" then -- Russian
	MarkBarLocal.button_Clear = "Отменить Выбор Цели"
	MarkBarLocal.button_MarkBar = "Панель Меток"
elseif client == "esES" then -- Spanish
	MarkBarLocal.button_Clear = "Limpiar Objetivo"
	MarkBarLocal.button_MarkBar = "Barra de Marcas de objetivo"
elseif client == "zhTW" then -- Taiwanese
	MarkBarLocal.button_Clear = "清除目標"
	MarkBarLocal.button_MarkBar = "標記條"
end