--海大VI型潜水艇1号舰—伊168
if not pcall(function() require("expansions/script/c1001252") end) then require("script/c1001252") end
function c1001233.initial_effect(c)
	colle.sum(c,1)
	colle.th1(c)
	colle.cnb1(c)
	--Pos Change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_POSITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c1001233.target)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e2)
	--dowatk
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,1233)
	e3:SetTarget(c1001233.target1)
	e3:SetOperation(c1001233.activate1)
	c:RegisterEffect(e3)
end
function c1001233.target(e,c)
	return c:IsCode(1001233) and c:IsFaceup()
end
function c1001233.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c1001233.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(-1000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetValue(-1000)
		tc:RegisterEffect(e2)
	end
end