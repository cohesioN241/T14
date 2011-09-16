local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

T.PP = function(p, obj)
	local TukuiInfoLeft = TukuiInfoLeft
	local TukuiInfoRight = TukuiInfoRight
	local TukuiTopStatLeft = TukuiTopStatLeft
	local TukuiTopStatRight = TukuiTopStatRight
	
	if p == 1 then
		obj:SetParent(TukuiInfoLeft)
		obj:Height(TukuiInfoLeft:GetHeight())
		obj:Point("LEFT", TukuiInfoLeft, 20, 1)
	elseif p == 2 then
		obj:SetParent(TukuiInfoLeft)
		obj:Height(TukuiInfoLeft:GetHeight())
		obj:Point("CENTER", TukuiInfoLeft, 0, 1)
	elseif p == 3 then
		obj:SetParent(TukuiInfoLeft)
		obj:Height(TukuiInfoLeft:GetHeight())
		obj:Point("RIGHT", TukuiInfoLeft, -20, 1)
	elseif p == 4 then
		obj:SetParent(TukuiInfoRight)
		obj:Height(TukuiInfoRight:GetHeight())
		obj:Point("LEFT", TukuiInfoRight, 20, 1)
	elseif p == 5 then
		obj:SetParent(TukuiInfoRight)
		obj:Height(TukuiInfoRight:GetHeight())
		obj:Point("CENTER", TukuiInfoRight, 0, 1)
	elseif p == 6 then
		obj:SetParent(TukuiInfoRight)
		obj:Height(TukuiInfoRight:GetHeight())
		obj:Point("RIGHT", TukuiInfoRight, -20, 1)
	end
end
