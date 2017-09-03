--圆环之理的助手 百江渚
function c1001213.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,290131)
	e1:SetTarget(c1001213.target1)
	e1:SetOperation(c1001213.activate1)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_DESTROY)
	e2:SetCondition(c1001213.condition)
	e2:SetTarget(c1001213.sptg)
	e2:SetCountLimit(1,290132)
	e2:SetOperation(c1001213.operation)
	c:RegisterEffect(e2)
	--synchro custom
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetTarget(c1001213.syntg)
	e7:SetValue(1)
	e7:SetOperation(c1001213.synop)
	c:RegisterEffect(e7)
end
function c1001213.filter_b(c)
	return c:IsSetCard(0x3205) and c:IsAbleToHand() and not c:IsCode(1001213)
end
function c1001213.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) and Duel.IsExistingTarget(c1001213.filter_b,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SEARCH,g,1,0,0)
end
function c1001213.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c1001213.filter_b,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c1001213.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1001213.spfilter,1,nil,tp)
end
function c1001213.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c1001213.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		--syn
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c1001213.target)
		e1:SetCode(EFFECT_SYNCHRO_LEVEL)
		e1:SetValue(c1001213.slevel)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		--xyz
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(c1001213.target)
		e2:SetCode(EFFECT_XYZ_LEVEL)
		e2:SetValue(c1001213.xyzlv)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c1001213.target(e,c)
	return c:IsSetCard(0x3205)
end
function c1001213.slevel(e,c)
	local lv=c:GetLevel()
	return 4*65536+lv
end
function c1001213.xyzlv(e,c,rc)
	return 0x40000+c:GetLevel()
end
function c1001213.synfilter(c,syncard,tuner,f)
	return c:IsFaceup() and c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard,tuner) and c:IsSetCard(0x3205) and (f==nil or f(c))
end
function c1001213.syntg(e,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	if lv<=0 then return false end
	local g=Duel.GetMatchingGroup(c1001213.synfilter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	local res=g:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
	return res
end
function c1001213.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	local g=Duel.GetMatchingGroup(c1001213.synfilter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local sg=g:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,minc,maxc,syncard)
	Duel.SetSynchroMaterial(sg)
end
function c1001213.spfilter(c,tp)
	return c:IsSetCard(0x3205) and c:IsLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp
end