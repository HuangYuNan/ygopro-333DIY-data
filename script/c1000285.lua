--一起死吧！！
function c1000285.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1000285,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c1000285.condition)
	e1:SetTarget(c1000285.target)
	e1:SetOperation(c1000285.activate)
	c:RegisterEffect(e1)
end
function c1000285.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c1000285.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x5201) and c:IsAbleToGrave()
end
function c1000285.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1000285.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,g:GetCount()*500)
end
function c1000285.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(Card.IsAbleToGrave,tp,0,LOCATION_MZONE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local rg=Duel.SelectMatchingCard(tp,c1000285.filter,tp,LOCATION_MZONE,0,1,ct1,nil)
	local ct2=Duel.SendtoGrave(rg,REASON_EFFECT)
	if ct2==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_MZONE,ct2,ct2,nil)
	Duel.HintSelection(dg)
	local ct3=Duel.SendtoGrave(dg,REASON_EFFECT)
	local ct4=ct2+ct3
	Duel.BreakEffect()
	Duel.Damage(1-tp,ct4*500,REASON_EFFECT)
	Duel.Damage(tp,ct4*500,REASON_EFFECT)
end