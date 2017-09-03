--灵异传-巫女 博丽靈梦
function c1000299.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1000299,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c1000299.spcon)
	e2:SetTarget(c1000299.sptg)
	e2:SetOperation(c1000299.spop)
	c:RegisterEffect(e2)
	--DESTROYED
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1000299,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c1000299.thcon)
	e3:SetTarget(c1000299.tdtg)
	e3:SetOperation(c1000299.tdop)
	c:RegisterEffect(e3)
end
function c1000299.filter(c,tp)
	return c:IsType(TYPE_SPELL) and bit.band(c:GetReason(),0x41)==0x41 and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_SZONE) and c:IsPreviousPosition(POS_FACEUP) and c:GetCode()==1000292
end
function c1000299.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1000299.filter,1,nil,tp)
end
function c1000299.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c1000299.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)
	end
end
function c1000299.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c1000299.tdfilter(c)
	return c:IsDestructable()
end
function c1000299.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1000299.tdfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c1000299.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c1000299.tdfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end