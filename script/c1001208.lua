--甜点的少女 百江渚
function c1001208.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Chinmaterial
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1001208,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHAIN_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c1001208.chain_target)
	e2:SetOperation(c1001208.chain_operation)
	e2:SetValue(aux.FilterBoolFunction(Card.IsSetCard,0x6205))
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c1001208.target)
	e3:SetOperation(c1001208.activate)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1001208,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e4:SetCountLimit(1,290081)
	e4:SetCondition(c1001208.spcon1)
	e4:SetTarget(c1001208.sptg1)
	e4:SetOperation(c1001208.spop1)
	c:RegisterEffect(e4)
	--atk,def up
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(1001208,3))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(TIMING_DAMAGE_STEP)
	e5:SetRange(LOCATION_HAND)
	e5:SetCountLimit(1,290082)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCondition(c1001208.condition)
	e5:SetCost(c1001208.cost)
	e5:SetOperation(c1001208.operation)
	c:RegisterEffect(e5)
end
function c1001208.filter1(c,e)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c1001208.chain_target(e,te,tp)
	return Duel.GetMatchingGroup(c1001208.filter1,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND+LOCATION_EXTRA,0,nil,te)
end
function c1001208.chain_operation(e,te,tp,tc,mat,sumtype)
	if not sumtype then sumtype=SUMMON_TYPE_FUSION end
	tc:SetMaterial(mat)
	Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	Duel.BreakEffect()
	Duel.SpecialSummon(tc,sumtype,tp,tp,false,false,POS_FACEUP)
	e:Reset()
end
function c1001208.filter_a(c)
	return c:IsSetCard(0x3205) and c:IsDestructable()
end
function c1001208.filter_b(c)
	return c:IsSetCard(0x3205) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsAbleToHand()
end
function c1001208.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD) and c1001208.filter_a(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1001208.filter_a,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) and Duel.IsExistingTarget(c1001208.filter_b,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c1001208.filter_a,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c1001208.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c1001208.filter_b,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c1001208.cfilter(c,tp)
	return c:IsSetCard(0x3205) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp
end
function c1001208.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1001208.cfilter,1,nil,tp)
end
function c1001208.filter_c(c,e,tp)
	return c:IsSetCard(0x3205) and c:IsType(TYPE_PENDULUM) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(1001208)
end
function c1001208.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1001208.filter_c,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c1001208.spop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c1001208.filter_c,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end
function c1001208.filter_d(c)
	return c:IsSetCard(0x3205)
end
function c1001208.condition(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a:GetControler()==tp and c1001208.filter_d(a) and a:IsRelateToBattle())
		or (d and d:GetControler()==tp and d:IsFaceup() and c1001208.filter_d(d) and d:IsRelateToBattle())
end
function c1001208.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckOrExtraAsCost() end
	Duel.SendtoExtraP(e:GetHandler(),nil,REASON_COST)
end
function c1001208.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	if Duel.GetTurnPlayer()~=tp then a=Duel.GetAttackTarget() end
	if not a:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(1000)
	a:RegisterEffect(e1)
end