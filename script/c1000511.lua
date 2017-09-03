--巴麻美不再孤单
function c1000511.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1000511,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,1000511)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c1000511.sptg)
	e2:SetOperation(c1000511.spop)
	c:RegisterEffect(e2)
	--Search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetTarget(c1000511.thtg)
	e3:SetOperation(c1000511.thop)
	c:RegisterEffect(e3)
end
function c1000511.cfilter(c,e,tp)
	return c:IsSetCard(0xa204)  and c:IsFaceup() and Duel.IsExistingMatchingCard(c1000511.filter,tp,LOCATION_MZONE,0,1,c,e,tp,c:GetCode())
end
function c1000511.filter(c,e,tp,code)
	return c:IsFaceup() and c:IsCode(code)  and Duel.IsExistingMatchingCard(c1000511.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_HAND,0,1,nil,e,tp,code)
end
function c1000511.spfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c1000511.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c1000511.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c1000511.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c1000511.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_HAND)
end
function c1000511.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	local g=Duel.SelectMatchingCard(tp,c1000511.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_HAND,0,1,1,nil,e,tp,tc:GetCode())
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end
function c1000511.thfilter(c)
	return c:IsSetCard(0xa204) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c1000511.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c1000511.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1000511.thfilter,tp,LOCATION_GRAVE,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end