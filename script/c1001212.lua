--零食的魔女 夏洛特第二形态
function c1001212.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3205),aux.NonTuner(Card.IsType,TYPE_SYNCHRO),1)
	c:EnableReviveLimit()
	--handes
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_BECOME_TARGET)
	e1:SetCountLimit(1,29012)
	e1:SetCondition(c1001212.indcon)
	e1:SetTarget(c1001212.distg)
	e1:SetOperation(c1001212.disop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,29012)
	e2:SetCondition(c1001212.indcon)
	e2:SetTarget(c1001212.hsptg)
	e2:SetOperation(c1001212.hspop)
	c:RegisterEffect(e2)
	--to grave or damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c1001212.tgtg)
	e3:SetOperation(c1001212.tgop)
	c:RegisterEffect(e3)
	--battle indestructable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetCondition(c1001212.indcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function c1001212.filter_a(c)
	return c:IsFaceup() and c:IsCode(1001201)
end
function c1001212.indcon(e)
	return Duel.IsExistingMatchingCard(c1001212.filter_a,0,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil)
end
function c1001212.discon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c1001212.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c1001212.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c1001212.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,1-tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c1001212.hspop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(1-tp,1)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c1001212.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_MZONE+LOCATION_HAND,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,LOCATION_MZONE+LOCATION_HAND,0)
end
function c1001212.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,TYPE_MONSTER)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_RULE)
	else
		local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		Duel.ConfirmCards(tp,hg)
		Duel.ShuffleHand(tp)
		Duel.Damage(tp,2000,REASON_EFFECT)
	end
end