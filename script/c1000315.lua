--神篱，在紫色中燃烧
function c1000315.initial_effect(c)
	--daw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1000315,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c1000315.decon)
	e1:SetOperation(c1000315.dawop)
	c:RegisterEffect(e1)
	--specialsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1000315,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c1000315.spcon)
	e2:SetTarget(c1000315.tg3)
	e2:SetOperation(c1000315.op3)
	c:RegisterEffect(e2)
end
function c1000315.cfilter(c)
	return c:IsSetCard(0x6201) and c:IsAbleToDeck()
end
function c1000315.dfilter(c)
	return c:IsSetCard(0x6201)
end
function c1000315.decon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c1000315.dfilter,tp,LOCATION_DECK,0,1,nil)
end
function c1000315.dawop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c1000315.cfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
	if ct>1 then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
function c1000315.filter(c,e,tp)
	return c:IsSetCard(0x9201) and c:IsType(TYPE_DUAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1000315.wfilter(c)
	return c:IsSetCard(0x6201)
end
function c1000315.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c1000315.wfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c1000315.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_HAND) and c1000315.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c1000315.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c1000315.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c1000315.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==1 then
		tc:EnableDualState()
	end
end