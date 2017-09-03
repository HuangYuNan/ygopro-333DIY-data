--鸢尾花
function c1000287.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c1000287.spcon)
	e1:SetOperation(c1000287.activate)
	c:RegisterEffect(e1)
end
function c1000287.acfilter(c)
	return c:IsSetCard(0x5201) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c1000287.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c1000287.acfilter,tp,LOCATION_GRAVE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct==7 and Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c1000287.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c1000287.acfilter,tp,LOCATION_GRAVE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	if ct>=7 then
	   Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	   Duel.ShuffleDeck(tp)
	   Duel.BreakEffect()
	   Duel.Draw(tp,3,REASON_EFFECT)
	end
end