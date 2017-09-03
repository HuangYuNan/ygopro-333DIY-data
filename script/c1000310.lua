--浄土曼茶罗
function c1000310.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--duel status
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c1000310.dualtarget)
	e2:SetCode(EFFECT_DUAL_STATUS)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1000310,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c1000310.condition)
	e3:SetTarget(c1000310.target)
	e3:SetOperation(c1000310.operation)
	c:RegisterEffect(e3)
end
function c1000310.dualtarget(e,c)
	return c:IsType(TYPE_DUAL) and c:IsSetCard(0x0f81)
end
function c1000310.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():IsReason(REASON_DESTROY)
end
function c1000310.filter(c)
	return c:IsSetCard(0x9201) and c:IsAbleToHand()
end
function c1000310.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1000310.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1000310.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c1000310.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tg=g:GetFirst()
	if tg==nil then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	 Duel.ConfirmCards(1-tp,g)
end