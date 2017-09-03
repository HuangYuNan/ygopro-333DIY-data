--馋嘴的少女 百江渚
function c1001206.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c1001206.actcon)
	e2:SetOperation(c1001206.actop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e3)
	--cannot be battle target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetValue(c1001206.vala)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_SELECT_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e5:SetTargetRange(0,0xff)
	e5:SetValue(c1001206.vala_a)
	c:RegisterEffect(e5)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e6:SetCountLimit(1,29006)
	e6:SetCondition(c1001206.spcon1)
	e6:SetTarget(c1001206.sptg1)
	e6:SetOperation(c1001206.spop1)
	c:RegisterEffect(e6)
end
function c1001206.spfilter(c,tp)
	return c:IsSetCard(0x3205) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp 
end
function c1001206.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1001206.spfilter,1,nil,tp)
end
function c1001206.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,1)
end
function c1001206.spop1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		local g=Duel.GetDecktopGroup(tp,1)
		local tc=g:GetFirst()
		Duel.Draw(tp,1,REASON_EFFECT)
		if tc then
			Duel.ConfirmCards(1-tp,tc)
			Duel.BreakEffect()
			if not (tc:IsSetCard(0x3205) or tc:IsSetCard(0x5205)) then
				Duel.SetLP(tp,Duel.GetLP(tp)-1000)
			end
			Duel.ShuffleHand(tp)
		end
	end
end
function c1001206.actcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	return tc and tc:IsControler(tp) and tc:IsSetCard(0x6205)
end
function c1001206.actop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c1001206.cfilter(c,atk)
	return c:IsFaceup() and (c:IsSetCard(0x3205) or c:IsSetCard(0x5205)) and c:GetAttack()>atk
end
function c1001206.vala(e,c)
	return Duel.IsExistingMatchingCard(c1001206.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,c:GetAttack())
end
function c1001206.vala_a(e,re,c)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsLocation(LOCATION_MZONE) and Duel.IsExistingMatchingCard(c1001206.cfilter,tp,LOCATION_MZONE,0,1,nil,c:GetAttack())
end