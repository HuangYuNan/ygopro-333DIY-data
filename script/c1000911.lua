--叶族人的幼芽
function c1000911.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c1000911.hspcon)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77901552,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCost(c1000911.cost)
	e2:SetTarget(c1000911.sptg)
	e2:SetOperation(c1000911.spop)
	c:RegisterEffect(e2)
end
function c1000911.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,1000911)==0 end
	Duel.RegisterFlagEffect(tp,1000911,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c1000911.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_PLANT) and c:IsLevelBelow(4)
end
function c1000911.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1000911.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c1000911.spfilter(c,e,tp)
	return c:IsSetCard(0xc201) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1000911.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c1000911.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1000911.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
	    e1:SetType(EFFECT_TYPE_SINGLE)
	    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	    e1:SetRange(LOCATION_MZONE)
	    e1:SetCode(EFFECT_IMMUNE_EFFECT)
	    e1:SetValue(c1000911.efilter)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	    tc:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end
function c1000911.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP) and e:GetHandlerPlayer()~=te:GetHandlerPlayer()
end