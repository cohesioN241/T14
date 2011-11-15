-- Tukui API, see DOCS/API.txt for more informations

local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

local noop = T.dummy
local floor = math.floor
local class = T.myclass
local texture = C.media.blank
local backdropr, backdropg, backdropb = unpack(C["media"].backdropcolor)
local borderr, borderg, borderb = unpack(C["media"].bordercolor)
local backdropa = 1
local bordera = 1
local template
local inset = 0
local noinset = C.media.noinset

-- pixel perfect script of custom ui Scale.
local mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/C["general"].uiscale
local Scale = function(x)
    return mult*math.floor(x/mult+.5)
end

T.Scale = function(x) return Scale(x) end
T.mult = mult

local function Size(frame, width, height)
	frame:SetSize(Scale(width), Scale(height or width))
end

local function Width(frame, width)
	frame:SetWidth(Scale(width))
end

local function Height(frame, height)
	frame:SetHeight(Scale(height))
end

local function Point(obj, arg1, arg2, arg3, arg4, arg5)
	-- anyone has a more elegant way for this?
	if type(arg1)=="number" then arg1 = Scale(arg1) end
	if type(arg2)=="number" then arg2 = Scale(arg2) end
	if type(arg3)=="number" then arg3 = Scale(arg3) end
	if type(arg4)=="number" then arg4 = Scale(arg4) end
	if type(arg5)=="number" then arg5 = Scale(arg5) end

	obj:SetPoint(arg1, arg2, arg3, arg4, arg5)
end

local function CreateShadow(f, t)
	if f.shadow then return end -- we seriously don't want to create shadow 2 times in a row on the same frame.
	
	local shadow = CreateFrame("Frame",  f:GetName() and f:GetName() .. "Shadow" or nil, f)
	shadow:SetFrameLevel(1)
	shadow:SetFrameStrata(f:GetFrameStrata())
	shadow:Point("TOPLEFT", -3, 3)
	shadow:Point("BOTTOMLEFT", -3, -3)
	shadow:Point("TOPRIGHT", 3, 3)
	shadow:Point("BOTTOMRIGHT", 3, -3)
	shadow:SetBackdrop( { 
		edgeFile = C["media"].glowTex, edgeSize = T.Scale(3),
		insets = {left = T.Scale(5), right = T.Scale(5), top = T.Scale(5), bottom = T.Scale(5)},
	})
	shadow:SetBackdropColor(0, 0, 0, 0)
	shadow:SetBackdropBorderColor(0, 0, 0, 0.8)
	f.shadow = shadow
end

local function CreateOverlay(f)
	if f.overlay then return end
	
	local overlay = f:CreateTexture(f:GetName() and f:GetName().."Overlay" or nil, "BORDER", f)
	overlay:ClearAllPoints()
	overlay:Point("TOPLEFT", 2, -2)
	overlay:Point("BOTTOMRIGHT", -2, 2)
	overlay:SetTexture(unpack(T.Textures.interface))
	overlay:SetVertexColor(.05, .05, .05)
	f.overlay = overlay
end

local function CreateBorder(f, i, o)
	if i then
		if f.iborder then return end
		local border = CreateFrame("Frame", f:GetName() and f:GetName() .. "InnerBorder" or nil, f)
		border:Point("TOPLEFT", mult, -mult)
		border:Point("BOTTOMRIGHT", -mult, mult)
		border:SetBackdrop({
			edgeFile = C["media"].blank, 
			edgeSize = mult, 
			insets = { left = mult, right = mult, top = mult, bottom = mult }
		})
		border:SetBackdropBorderColor(unpack(C["media"].backdropcolor))
		f.iborder = border
	end
	
	if o then
		if f.oborder then return end
		local border = CreateFrame("Frame", f:GetName() and f:GetName() .. "OuterBorder" or nil, f)
		border:Point("TOPLEFT", -mult, mult)
		border:Point("BOTTOMRIGHT", mult, -mult)
		border:SetFrameLevel(f:GetFrameLevel() + 1)
		border:SetBackdrop({
			edgeFile = C["media"].blank, 
			edgeSize = mult, 
			insets = { left = mult, right = mult, top = mult, bottom = mult }
		})
		border:SetBackdropBorderColor(unpack(C["media"].backdropcolor))
		f.oborder = border
	end
end

if noinset then inset = mult end

-- function to update color when it doesn't match template we try to apply
local function UpdateColor(t)
	if t == template then return end

	if t == "ClassColor" or t == "Class Color" or t == "Class" then
		local c = T.UnitColor.class[class]
		borderr, borderg, borderb = c[1], c[2], c[3]
		backdropr, backdropg, backdropb = unpack(C["media"].backdropcolor)
		backdropa = 1
	else
		local balpha = 1
		if t == "Transparent" then balpha = 0.8 end
		borderr, borderg, borderb = unpack(C["media"].bordercolor)
		backdropr, backdropg, backdropb = unpack(C["media"].backdropcolor)
		backdropa = balpha
	end
	
	template = t
end

local function CreatePanel(f, t, w, h, a1, p, a2, x, y)
	UpdateColor(t)
	
	f:Width(w)
	f:Height(h)
	f:SetFrameLevel(1)
	f:SetFrameStrata("BACKGROUND")
	f:Point(a1, p, a2, x, y)
	f:SetBackdrop({
		bgFile = C["media"].blank, 
		edgeFile = C["media"].blank, 
		tile = false, tileSize = 0, edgeSize = mult, 
		insets = { left = -mult + inset, right = -mult + inset, top = -mult + inset, bottom = -mult + inset}
	})
	
	f:SetBackdropColor(backdropr, backdropg, backdropb, backdropa)
	f:SetBackdropBorderColor(borderr, borderg, borderb)
	
	if t == "Transparent" then
		f:CreateShadow()
	else
		f:CreateShadow()
		f:CreateOverlay()
	end
end

local function CreateBackdrop(f, t, tex)
	if not t then t = "Default" end

	local b = CreateFrame("Frame", nil, f)
	b:Point("TOPLEFT", -2 + inset, 2 - inset)
	b:Point("BOTTOMRIGHT", 2 - inset, -2 + inset)
	b:SetTemplate(t, tex)

	if f:GetFrameLevel() - 1 >= 0 then
		b:SetFrameLevel(f:GetFrameLevel() - 1)
	else
		b:SetFrameLevel(0)
	end

	f.backdrop = b
end

local function SetTemplate(f, t, tex)
	if tex then
		texture = C.media.normTex
	else
		texture = C.media.blank
	end
	
	UpdateColor(t)

	f:SetBackdrop({
		bgFile = texture, 
		edgeFile = C.media.blank, 
		tile = false, tileSize = 0, edgeSize = mult, 
		insets = { left = -mult + inset, right = -mult + inset, top = -mult + inset, bottom = -mult + inset}
	})
	
	f:SetBackdropColor(backdropr, backdropg, backdropb, backdropa)
	f:SetBackdropBorderColor(borderr, borderg, borderb)
end

local function Kill(object)
	if object.UnregisterAllEvents then
		object:UnregisterAllEvents()
	end
	object.Show = noop
	object:Hide()
end

-- styleButton function authors are Chiril & Karudon.
local function StyleButton(b, c) 
    local name = b:GetName()
 
    local button          = _G[name]
	
	local hover = b:CreateTexture("frame", nil, self) -- hover
	hover:SetTexture(1, 1, 1, .3)
	hover:Size(button:GetWidth(), button:GetHeight())
	hover:Point("TOPLEFT", button, 2, -2)
	hover:Point("BOTTOMRIGHT", button, -2, 2)
	button:SetHighlightTexture(hover)

	local pushed = b:CreateTexture("frame", nil, self) -- pushed
	pushed:SetTexture(.9, .8, .1, .3)
	pushed:Size(button:GetWidth(), button:GetHeight())
	pushed:Point("TOPLEFT", button, 2, -2)
	pushed:Point("BOTTOMRIGHT", button, -2, 2)
	button:SetPushedTexture(pushed)
 
	if c then
		local checked = b:CreateTexture("frame", nil, self) -- checked
		checked:SetTexture(0, 1, 0, .3)
		checked:Size(button:GetWidth(), button:GetHeight())
		checked:Point("TOPLEFT", button, 2, -2)
		checked:Point("BOTTOMRIGHT", button, -2, 2)
		button:SetCheckedTexture(checked)
	end
end

local function FontString(parent, name, fontName, fontHeight, fontStyle)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:SetFont(fontName, fontHeight, fontStyle)
	fs:SetJustifyH("LEFT")
	
	if not name then
		parent.text = fs
	else
		parent[name] = fs
	end
	
	return fs
end

local function HighlightTarget(self, event, unit)
	if self.unit == "target" then return end
	if UnitIsUnit('target', self.unit) then
		self.HighlightTarget:Show()
	else
		self.HighlightTarget:Hide()
	end
end

local function HighlightUnit(f, r, g, b)
	if f.HighlightTarget then return end
	local glowBorder = {edgeFile = C["media"].blank, edgeSize = 1}
	f.HighlightTarget = CreateFrame("Frame", nil, f)
	f.HighlightTarget:Point("TOPLEFT", f, "TOPLEFT", -2, 2)
	f.HighlightTarget:Point("BOTTOMRIGHT", f, "BOTTOMRIGHT", 2, -2)
	f.HighlightTarget:SetBackdrop(glowBorder)
	f.HighlightTarget:SetFrameLevel(f:GetFrameLevel() + 1)
	f.HighlightTarget:SetBackdropBorderColor(r,g,b,1)
	f.HighlightTarget:Hide()
	f:RegisterEvent("PLAYER_TARGET_CHANGED", HighlightTarget)
end

local function FadeIn(f)
	UIFrameFadeIn(f, .4, f:GetAlpha(), 1)
end
	
local function FadeOut(f)
	UIFrameFadeOut(f, .8, f:GetAlpha(), 0)
end

if C["datatext"].classcolor then
	local color = RAID_CLASS_COLORS[T.myclass]
	T.cStart = ("|cff%.2x%.2x%.2x"):format(color.r * 255, color.g * 255, color.b * 255)
else
	local r, g, b = unpack(C["datatext"].color)
	T.cStart = ("|cff%.2x%.2x%.2x"):format(r * 255, g * 255, b * 255)
end
T.cEnd = "|r"

function ColorGradient(perc, ...)
	if perc >= 1 then
		local r, g, b = select(select('#', ...) - 2, ...)
		return r, g, b
	elseif perc <= 0 then
		local r, g, b = ...
		return r, g, b
	end
	
	local num = select('#', ...) / 3

	local segment, relperc = math.modf(perc*(num-1))
	local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

	return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end

local function StripTextures(object, kill)
	for i=1, object:GetNumRegions() do
		local region = select(i, object:GetRegions())
		if region:GetObjectType() == "Texture" then
			if kill then
				region:Kill()
			else
				region:SetTexture(nil)
			end
		end
	end		
end

local function addapi(object)
	local mt = getmetatable(object).__index
	if not object.Width then mt.Width = Width end
	if not object.Height then mt.Height = Height end
	if not object.Size then mt.Size = Size end
	if not object.Point then mt.Point = Point end
	if not object.SetTemplate then mt.SetTemplate = SetTemplate end
	if not object.CreateBackdrop then mt.CreateBackdrop = CreateBackdrop end
	if not object.StripTextures then mt.StripTextures = StripTextures end
	if not object.CreatePanel then mt.CreatePanel = CreatePanel end
	if not object.CreateShadow then mt.CreateShadow = CreateShadow end
	if not object.CreateOverlay then mt.CreateOverlay = CreateOverlay end
	if not object.CreateBorder then mt.CreateBorder = CreateBorder end
	if not object.Kill then mt.Kill = Kill end
	if not object.StyleButton then mt.StyleButton = StyleButton end
	if not object.FontString then mt.FontString = FontString end
	if not object.FadeIn then mt.FadeIn = FadeIn end
	if not object.FadeOut then mt.FadeOut = FadeOut end
	if not object.HighlightUnit then mt.HighlightUnit = HighlightUnit end
end

local handled = {["Frame"] = true}
local object = CreateFrame("Frame")
addapi(object)
addapi(object:CreateTexture())
addapi(object:CreateFontString())

object = EnumerateFrames()
while object do
	if not handled[object:GetObjectType()] then
		addapi(object)
		handled[object:GetObjectType()] = true
	end

	object = EnumerateFrames(object)
end