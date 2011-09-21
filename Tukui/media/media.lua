local T, C, L = unpack(select(2, ...))

C["media"] = {
	-- fonts (ENGLISH, SPANISH)
	["font"] = [=[Interface\Addons\Tukui\media\fonts\normal_font.ttf]=], -- general font of tukui
	["uffont"] = [[Interface\AddOns\Tukui\media\fonts\uf_font.ttf]], -- general font of unitframes
	["dmgfont"] = [[Interface\AddOns\Tukui\media\fonts\combat_font.ttf]], -- general font of dmg / sct
	
	-- fonts (DEUTSCH)
	["de_font"] = [=[Interface\Addons\Tukui\media\fonts\normal_font.ttf]=], -- general font of tukui
	["de_uffont"] = [[Interface\AddOns\Tukui\media\fonts\uf_font.ttf]], -- general font of unitframes
	["de_dmgfont"] = [[Interface\AddOns\Tukui\media\fonts\combat_font.ttf]], -- general font of dmg / sct
	
	-- fonts (FRENCH)
	["fr_font"] = [=[Interface\Addons\Tukui\media\fonts\normal_font.ttf]=], -- general font of tukui
	["fr_uffont"] = [[Interface\AddOns\Tukui\media\fonts\uf_font.ttf]], -- general font of unitframes
	["fr_dmgfont"] = [=[Interface\AddOns\Tukui\media\fonts\combat_font.ttf]=], -- general font of dmg / sct
	
	-- fonts (RUSSIAN)
	["ru_font"] = [=[Interface\Addons\Tukui\media\fonts\normal_font.ttf]=], -- general font of tukui
	["ru_uffont"] = [[Fonts\ARIALN.TTF]], -- general font of unitframes
	["ru_dmgfont"] = [[Fonts\ARIALN.TTF]], -- general font of dmg / sct
	
	-- fonts (TAIWAN ONLY)
	["tw_font"] = [=[Fonts\bLEI00D.ttf]=], -- general font of tukui
	["tw_uffont"] = [[Fonts\bLEI00D.ttf]], -- general font of unitframes
	["tw_dmgfont"] = [[Fonts\bLEI00D.ttf]], -- general font of dmg / sct
	
	-- fonts (KOREAN ONLY)
	["kr_font"] = [=[Fonts\2002.TTF]=], -- general font of tukui
	["kr_uffont"] = [[Fonts\2002.TTF]], -- general font of unitframes
	["kr_dmgfont"] = [[Fonts\2002.TTF]], -- general font of dmg / sct
	
	-- textures
	["normTex"] = [[Interface\AddOns\Tukui\media\textures\normTex]], -- texture used for tukui healthbar/powerbar/etc
	["glowTex"] = [[Interface\AddOns\Tukui\media\textures\glowTex]], -- the glow text around some frame.
	["bubbleTex"] = [[Interface\AddOns\Tukui\media\textures\bubbleTex]], -- unitframes combo points
	["striped"] = [[Interface\AddOns\Tukui\media\textures\Striped]], -- unitframes combo points
	["copyicon"] = [[Interface\AddOns\Tukui\media\textures\copy]], -- copy icon
	["blank"] = [[Interface\AddOns\Tukui\media\textures\blank]], -- the main texture for all borders/panels
	["buttonhover"] = [[Interface\AddOns\Tukui\media\textures\button_hover]],

	-- custom textures
	["empath"] = [[Interface\AddOns\Tukui\media\textures\empath]],
	
	-- colors
	["bordercolor"] = { .1, .1, .1, 1 }, -- border color of tukui panels
	["backdropcolor"] = { 0, 0, 0, 1 }, -- background color of tukui panels
	["altbordercolor"] = { .4, .4, .4 }, -- alternative border color, mainly for unitframes text panels.
	--["bordercolor"] = C.general.bordercolor or { .1, .1, .1, 1 }, -- border color of tukui panels
	--["backdropcolor"] = C.general.backdropcolor or { 0, 0, 0, 1 }, -- background color of tukui panels
	--["altbordercolor"] = C.unitframes.altbordercolor or { .4, .4, .4 }, -- alternative border color, mainly for unitframes text panels.
	["gradienthealth"] = {                                    -- health gradient color if unicolor is true. Credits to Hydra
		1.0, 0.3, 0.3, -- R, G, B (low HP)
		0.6, 0.3, 0.3, -- R, G, B (medium HP)
		0.15, 0.15, 0.15, -- R, G, B (high HP)
	},
	
	-- sound
	["whisper"] = [[Interface\AddOns\Tukui\media\sounds\whisper.mp3]],
	["warning"] = [[Interface\AddOns\Tukui\media\sounds\warning.mp3]],
	
	-- custom fonts
	["pixel_font"] = [[Interface\Addons\Tukui\media\fonts\visitor2.ttf]],
	["caith"] = [[Interface\Addons\Tukui\media\fonts\caith.ttf]],
}