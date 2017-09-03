--赤城级航空母舰1号舰—赤城
function c1001244.initial_effect(c)
	c:SetUniqueOnField(1,0,1001244)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x203),aux.NonTuner(Card.IsSetCard,0x203),1)
	c:EnableReviveLimit()
	--th
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1001243,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,9244)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c1001244.thtg)
	e2:SetOperation(c1001244.thop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1001243,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,10244)
	e3:SetTarget(c1001244.destg)
	e3:SetOperation(c1001244.desop)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1001244,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1,11244)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c1001244.sptg)
	e4:SetOperation(c1001244.spop)
	c:RegisterEffect(e4)
	--return to Spell
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(1001244,1))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,12244)
	e5:SetCondition(c1001244.tacon)
	e5:SetTarget(c1001244.target)
	e5:SetOperation(c1001244.op)
	c:RegisterEffect(e5)
end
function c1001244.filter(c)
	return c:IsSetCard(0x6207) and c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c1001244.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1001244.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c1001244.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1001244.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c1001244.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6207)
end
function c1001244.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c1001244.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1001244.cfilter,tp,LOCATION_SZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c1001244.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c1001244.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c1001244.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(c1001244.cfilter,tp,LOCATION_SZONE,0,nil)
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c1001244.desfilter,tp,0,LOCATION_ONFIELD,1,ct,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local tc=mg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-800)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
			tc=mg:GetNext()
		end
	end
end
function c1001244.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c1001244.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c1001244.refilter(c)
	return c:IsFaceup() and c:IsSetCard(0x203)
end
function c1001244.tacon(e,c)
	return Duel.IsExistingMatchingCard(c1001244.refilter,tp,LOCATION_MZONE,0,5,nil)
end
function c1001244.refilter(c)
	return c:IsFaceup() and c:IsSetCard(0x203)
end
function c1001244.tacon(e,c)
	return Duel.IsExistingMatchingCard(c1001244.refilter,tp,LOCATION_MZONE,0,4,nil)
end
function c1001244.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c1001244.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	else
		Duel.SendtoGrave(tc,REASON_RULE)
		return
	end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
end