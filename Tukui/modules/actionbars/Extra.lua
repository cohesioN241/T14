local T, C, L = unpack(select(2, ...))
if T.toc < 40300 then return end

-- create the anchor to allow moving extra button
local anchor = CreateFrame("Frame", "TukuiExtraActionBarFrameHolder", UIParent)
anchor:Size(160, 80)
anchor:SetPoint("BOTTOM", 0, 250)
anchor:SetMovable(true)
anchor:SetTemplate("Default")
anchor:SetBackdropBorderColor(0,0,0,0)
anchor:SetBackdropColor(0,0,0,0)
anchor.text = T.SetFontString(anchor, unpack(T.Fonts.movers.setfont))
anchor.text:SetPoint("CENTER")
anchor.text:SetText(L.move_extrabutton)
anchor.text:Hide()

-- We never use MainMenuBar, so we need to parent this frame outside of it else it will not work.
ExtraActionBarFrame:SetParent(anchor)
ExtraActionBarFrame:ClearAllPoints()
ExtraActionBarFrame:SetPoint("CENTER", anchor, "CENTER", 0, 0)