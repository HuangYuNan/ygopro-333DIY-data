--对祈祷的回报
function c1000291.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1000291,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c1000291.condition)
	e2:SetTarget(c1000291.target)
	e2:SetOperation(c1000291.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e3:SetValue(c1000291.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1000291,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCondition(c1000291.negcon)
	e4:SetCost(c1000291.cost)
	e4:SetTarget(c1000291.tg)
	e4:SetOperation(c1000291.op)
	c:RegisterEffect(e4)
end
function c1000291.valcheck(e,c)
	local ct=c:GetMaterial():FilterCount(Card.IsSetCard,nil,0x5201)
	e:GetLabelObject():SetLabel(ct)
end
function c1000291.condition(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local ec=eg:GetFirst()
	return ct>0 and ec:IsControler(tp) and bit.band(ec:GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE
		and ec:IsSetCard(0x5201)
end
function c1000291.filter(c,e,tp)
	return c:IsSetCard(0x5201) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1000291.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c1000291.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c1000291.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c1000291.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c1000291.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c1000291.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():GetTurnID()~=Duel.GetTurnCount()
end
function c1000291.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c1000291.thfilter(c)
	return c:IsSetCard(0x5201) and c:IsType(TYPE_MONSTER) and (c:IsRace(RACE_FAIRY+RACE_FIEND)) and  c:IsAbleToHand()
end
function c1000291.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1000291.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c1000291.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1000291.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end