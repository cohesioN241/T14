local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
-- move durability frame.

local anchor = CreateFrame("Frame", "TukuiDurabilityAnchor", UIParent)
anchor:Point("TOPLEFT", UIParent, "TOPLEFT", 200, -290)
anchor:Size(120, 20)
anchor:SetMovable(true)
anchor:SetClampedToScreen(true)
anchor:SetTemplate("Default")
anchor:SetBackdropBorderColor(1,0,0)
anchor:SetAlpha(0)
anchor.text = T.SetFontString(anchor, unpack(T.Fonts.movers.setfont))
anchor.text:SetPoint("CENTER")
anchor.text:SetText(L.move_durability)

hooksecurefunc(DurabilityFrame,"SetPoint",function(_,_,parent)
    if (parent == "MinimapCluster") or (parent == _G["MinimapCluster"]) then
        DurabilityFrame:ClearAllPoints()
		DurabilityFrame:Point("BOTTOM", anchor, "BOTTOM", 0, 24)
    end
end)