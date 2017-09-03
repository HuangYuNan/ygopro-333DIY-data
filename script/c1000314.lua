--恋色Magic
function c1000314.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c1000314.decon)
	e1:SetTarget(c1000314.target)
	e1:SetOperation(c1000314.activate)
	c:RegisterEffect(e1)
end
function c1000314.filter(c)
	return c:IsFaceup() and c:IsCode(1000304)
end
function c1000314.decon(e,tp,eg,ep,ev,re,r,r)
	return Duel.IsExistingMatchingCard(c1000314.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c1000314.defilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c1000314.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and c1000314.defilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c1000314.defilter,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c1000314.defilter,tp,0,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c1000314.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
