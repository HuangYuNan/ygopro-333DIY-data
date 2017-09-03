--审判「十王裁判」
function c1000708.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(c1000708.condition)
	e1:SetCost(c1000708.cost)
	e1:SetTarget(c1000708.target)
	e1:SetOperation(c1000708.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1000708,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c1000708.spcon)
	e4:SetTarget(c1000708.sptg)
	e4:SetOperation(c1000708.spop)
	c:RegisterEffect(e4)
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetTarget(c1000708.reptg)
	e5:SetValue(c1000708.repval)
	e5:SetOperation(c1000708.repop)
	c:RegisterEffect(e5)
end
function c1000708.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c1000708.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,nil,0x5204) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,nil,0x5204)
	Duel.Release(g,REASON_COST)
end
function c1000708.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c1000708.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
function c1000708.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and c:IsReason(REASON_DESTROY)
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp
end
function c1000708.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c1000708.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,1000700,0,0x4011,1000,2000,4,RACE_ZOMBIE,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,1000700)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		token:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
end
function c1000708.repfilter(c,tp)
	return c:IsSetCard(0x5204) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c1000708.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c1000708.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(1000708,0))
end
function c1000708.repval(e,c)
	return c1000708.repfilter(c,e:GetHandlerPlayer())
end
function c1000708.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end