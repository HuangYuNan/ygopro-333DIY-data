--叶族人的村落
function c1000901.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1000901,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc201))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_RELEASE)
	e3:SetCountLimit(1,1000901)
	e3:SetCondition(c1000901.condition)
	e3:SetOperation(c1000901.operation)
	c:RegisterEffect(e3)
end
function c1000901.ctfilter(c,tp)
	return c:IsReason(REASON_RELEASE) and c:IsPreviousLocation(LOCATION_HAND+LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsType(TYPE_MONSTER)
end
function c1000901.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1000901.ctfilter,1,nil,tp)
end
function c1000901.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end