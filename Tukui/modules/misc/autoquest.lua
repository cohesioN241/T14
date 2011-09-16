local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
-- by Industrial, edited by Dajova
if not C["others"].autoquest == true then return end

local f = CreateFrame("Frame")

local function MostValueable()
	local bestp, besti = 0
	for i=1,GetNumQuestChoices() do
		local link, name, _, qty = GetQuestItemLink("choice", i), GetQuestItemInfo("choice", i)
		local price = link and select(11, GetItemInfo(link))
		if not price then
			return
		elseif (price * (qty or 1)) > bestp then
			bestp, besti = (price * (qty or 1)), i
		end
	end
	if besti then
		local btn = _G["QuestInfoItem"..besti]
		if (btn.type == "choice") then
			btn:GetScript("OnClick")(btn)
		end
	end
end

f:SetScript("OnEvent", function(self, event, ...)
    if (event == "QUEST_DETAIL") then
		AcceptQuest()
		CompleteQuest()
	elseif (event == "QUEST_COMPLETE") then
		if (GetNumQuestChoices() and GetNumQuestChoices() < 1) then
			GetQuestReward()
		else
			MostValueable()
		end
    elseif (event == "QUEST_ACCEPT_CONFIRM") then
		ConfirmAcceptQuest()
	end
end)
f:RegisterEvent("QUEST_ACCEPT_CONFIRM")    
f:RegisterEvent("QUEST_DETAIL")
f:RegisterEvent("QUEST_COMPLETE")