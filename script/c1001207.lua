--草莓和蛋糕 百江渚
function c1001207.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DAMAGE_CALCULATING)
	e2:SetRange(LOCATION_PZONE)
	e2:SetOperation(c1001207.atkup)
	c:RegisterEffect(e2)
	--change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c1001207.target)
	e3:SetOperation(c1001207.scop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROY)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e4:SetCountLimit(1,29007)
	e4:SetCondition(c1001207.spcon1)
	e4:SetTarget(c1001207.sptg1)
	e4:SetOperation(c1001207.spop1)
	c:RegisterEffect(e4)
end
function c1001207.cfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x3205) 
end
function c1001207.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1001207.cfilter,1,nil,tp)
end
function c1001207.filter_a(c)
	return (c:IsSetCard(0x3205) or c:IsSetCard(0x5205)) and c:IsType(TYPE_PENDULUM) and c:IsAbleToExtra() and not c:IsCode(1001207)
end
function c1001207.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and  Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c1001207.spop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,c1001207.filter_a,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SendtoExtraP(tc,nil,REASON_EFFECT)
		end
	end
end
function c1001207.atkup(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a:IsSetCard(0x6205) or not d or a:GetAttack()>=d:GetAttack() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	--e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(1000)
	a:RegisterEffect(e1)
end
function c1001207.filter(c)
	return c:IsFaceup() and (c:GetSequence()==6 or c:GetSequence()==7)
end
function c1001207.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c1001207.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1001207.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c1001207.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,e:GetHandler())
end
function c1001207.scop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LSCALE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RSCALE)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e4)
	end
end