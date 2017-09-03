--奶酪的少女 百江渚
function c1001209.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--syn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c1001209.target)
	e2:SetCode(EFFECT_SYNCHRO_LEVEL)
	e2:SetValue(c1001209.slevel)
	c:RegisterEffect(e2)
	--xyz
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c1001209.target)
	e3:SetCode(EFFECT_XYZ_LEVEL)
	e3:SetValue(c1001209.xyzlv)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,9009)
	e4:SetCondition(c1001209.condition)
	e4:SetTarget(c1001209.target_a)
	e4:SetOperation(c1001209.activate)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROY)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e5:SetCountLimit(1,290091)
	e5:SetCondition(c1001209.spcon1)
	e5:SetTarget(c1001209.sptg1)
	e5:SetOperation(c1001209.spop1)
	c:RegisterEffect(e5)
	--Token
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetCountLimit(1,290092)
	e6:SetCondition(c1001209.drcon)
	e6:SetTarget(c1001209.drtg)
	e6:SetOperation(c1001209.drop)
	c:RegisterEffect(e6)
end
function c1001209.atktg(e,c)
	return c:IsSetCard(0x3205)
end
function c1001209.target(e,c)
	return c:IsSetCard(0x3205)
end
function c1001209.slevel(e,c)
	local lv=e:GetHandler():GetLevel()
	return 4*65536+lv
end
function c1001209.xyzlv(e,c,rc)
	return 0x40000+e:GetHandler():GetLevel()
end
function c1001209.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c1001209.filter(c)
	return c:IsSetCard(0x3205) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c1001209.target_a(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c1001209.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1001209.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c1001209.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c1001209.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c1001209.cfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x3205) 
end
function c1001209.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1001209.cfilter,1,nil,tp)
end
function c1001209.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and  Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c1001209.spop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		--update_attck
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(1001209,1))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c1001209.atktg)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		Duel.RegisterEffect(e2,tp)
	end
end
function c1001209.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsReason(REASON_DESTROY)
end
function c1001209.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,1001203,0,0x4011,200,200,1,RACE_SPELLCASTER,ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c1001209.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,1001203,0,0x4011,200,200,1,RACE_SPELLCASTER,ATTRIBUTE_FIRE) then
		local token=Duel.CreateToken(tp,1001203)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,1001203,0,0x4011,200,200,1,RACE_SPELLCASTER,ATTRIBUTE_FIRE) then
		local token=Duel.CreateToken(tp,1001203)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end