--吹雪级驱逐舰1号舰—吹雪
if not pcall(function() require("expansions/script/c1001252") end) then require("script/c1001252") end
function c1001219.initial_effect(c)
	c:SetUniqueOnField(1,0,c:GetCode())
	colle.sum(c,2)
	colle.atkup(c,150)
	colle.cnb(c)
	colle.th(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1001219,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101219)
	e1:SetCondition(c1001219.condition)
	e1:SetTarget(c1001219.target)
	e1:SetOperation(c1001219.activate)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1001219,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101219)
	e2:SetCondition(c1001219.condition)
	e2:SetOperation(c1001219.operaion)
	c:RegisterEffect(e2)
end
function c1001219.filter(c)
	return c:IsFacedown() and c:IsDestructable()
end
function c1001219.fivefilter(c)
	return c:IsFaceup() and c:IsSetCard(0x203)
end
function c1001219.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1001219.fivefilter,tp,LOCATION_MZONE,0,5,nil)
end
function c1001219.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c1001219.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c1001219.filter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c1001219.filter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c1001219.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c1001219.operaion(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
end