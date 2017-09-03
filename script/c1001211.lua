--圆环之理的使者 百江渚
function c1001211.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c1001211.ffilter_b,c1001211.ffilter_a,true)
	--aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x3205),2,false)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c1001211.condition)
	e2:SetTarget(c1001211.target)
	e2:SetOperation(c1001211.activate)
	c:RegisterEffect(e2)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,29011)
	e1:SetTarget(c1001211.target_a)
	e1:SetOperation(c1001211.activate_a)
	c:RegisterEffect(e1)
end
function c1001211.ffilter_b(c)
	return (c:IsSetCard(0x3205) or c:IsSetCard(0x5205))  and c:IsType(TYPE_XYZ+TYPE_SYNCHRO)
end
function c1001211.ffilter_a(c)
	return (c:IsSetCard(0x3205) or c:IsSetCard(0x5205))  and c:IsType(TYPE_XYZ+TYPE_SYNCHRO)
end
function c1001211.condition(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c1001211.desfilter(c)
	return c:IsSetCard(0x3205)  and c:IsDestructable()
end
function c1001211.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return c1001211.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1001211.desfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c1001211.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c1001211.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c1001211.thfilter(c)
	return c:IsSetCard(0x3205)  and c:IsAbleToHand()
end
function c1001211.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c1001211.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,ft)
		local ta=g:GetFirst()
		if ta then
			if ft>0 and ta:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not ta:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(1001202,1))) then
				Duel.SpecialSummon(ta,0,tp,tp,false,false,POS_FACEUP)
			else
				Duel.SendtoHand(ta,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,ta)
			end
		end
	end
end
function c1001211.target_a(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_DECK,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c1001211.activate_a(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(1-tp,1)
	Duel.DisableShuffleCheck()
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)==0 then return end
	local tc=Duel.GetOperatedGroup():GetFirst()
	if tc:IsType(TYPE_MONSTER) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(4000)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetValue(aux.tgoval)
		c:RegisterEffect(e2)
	elseif tc:IsType(TYPE_SPELL) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DIRECT_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	elseif tc:IsType(TYPE_TRAP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_EXTRA_ATTACK)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
		end
end