--殇鸣的节拍
function c1000818.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c1000818.condition)
	e1:SetTarget(c1000818.target)
	e1:SetOperation(c1000818.activate)
	c:RegisterEffect(e1)
end
function c1000818.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c1000818.filter(c)
	return c:IsSetCard(0x3204) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c1000818.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c1000818.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c1000818.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c1000818.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(c1000818.efilter)
		tc:RegisterEffect(e2)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EXTRA_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetCondition(c1000818.atcon)
		e2:SetOperation(c1000818.atop)
		tc:RegisterEffect(e2)
	end
end
function c1000818.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c1000818.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsChainAttackable() and c:IsStatus(STATUS_OPPO_BATTLE) 
end
function c1000818.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end