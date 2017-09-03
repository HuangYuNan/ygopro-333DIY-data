--金刚级高速战舰1号舰—金刚
if not pcall(function() require("expansions/script/c1001252") end) then require("script/c1001252") end
function c1001248.initial_effect(c)
	c:SetUniqueOnField(1,0,1001248)
	colle.sum2(c,8)
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1001248,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c1001248.sptg)
	e2:SetOperation(c1001248.spop)
	c:RegisterEffect(e2)
	--direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetCondition(c1001248.atcon)
	c:RegisterEffect(e3)
	--1bat
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c1001248.bacon)
	e4:SetValue(c1001248.valcon)
	c:RegisterEffect(e4)
end
function c1001248.filter1(c,e,tp)
	return c:IsSetCard(0x9207) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and not c:IsCode(1001248)
end
function c1001248.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1001248.filter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c1001248.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1001248.filter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK)
		e3:SetValue(0)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_SET_DEFENSE)
		e4:SetValue(0)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
	end
	Duel.SpecialSummonComplete()
end
function c1001248.spfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c1001248.atcon(e,c)
	return Duel.IsExistingMatchingCard(c1001248.spfilter,tp,LOCATION_MZONE,0,1,nil,1001248)
		and Duel.IsExistingMatchingCard(c1001248.spfilter,tp,LOCATION_MZONE,0,1,nil,1001249)
		and Duel.IsExistingMatchingCard(c1001248.spfilter,tp,LOCATION_MZONE,0,1,nil,1001250)
		and Duel.IsExistingMatchingCard(c1001248.spfilter,tp,LOCATION_MZONE,0,1,nil,1001251)
end
function c1001248.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x203)
end
function c1001248.bacon(e,c)
	return Duel.IsExistingMatchingCard(c1001248.filter,tp,LOCATION_MZONE,0,5,nil)
end
function c1001248.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end