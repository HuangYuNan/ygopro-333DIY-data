--审判「Guilty or Not Guilty」
function c1000709.initial_effect(c)
	c:SetUniqueOnField(1,1,1000709)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1000709.target1)
	e1:SetOperation(c1000709.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1000709,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,98091)
	e2:SetCondition(c1000709.condition)
	e2:SetTarget(c1000709.target2)
	e2:SetOperation(c1000709.operation)
	e2:SetLabel(1)
	c:RegisterEffect(e2)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1000709,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c1000709.spcon)
	e3:SetTarget(c1000709.sptg)
	e3:SetOperation(c1000709.spop)
	c:RegisterEffect(e3)
	--to deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1000709,1))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCost(c1000709.tdcost)
	e4:SetTarget(c1000709.tdtg)
	e4:SetOperation(c1000709.tdop)
	c:RegisterEffect(e4)
end
function c1000709.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if Duel.GetTurnPlayer()==tp then
		return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
	else
		return ph==PHASE_BATTLE
	end
end
function c1000709.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tn=Duel.GetTurnPlayer()
	local ph=Duel.GetCurrentPhase()
	if ((tn==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)) or (tn~=tp and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)))
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1000709.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,94) then
		e:GetHandler():RegisterFlagEffect(1000709,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,65)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
	end
end
function c1000709.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x5204) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1000709.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(1000709)==0 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1000709.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end
	e:GetHandler():RegisterFlagEffect(1000709,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c1000709.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(1000709)==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1000709.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c1000709.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and c:IsReason(REASON_DESTROY)
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp
end
function c1000709.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c1000709.spop(e,tp,eg,ep,ev,re,r,rp)
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
function c1000709.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c1000709.tdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5204) and c:IsAbleToDeck()
end
function c1000709.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c1000709.tdfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c1000709.tdfilter,tp,LOCATION_REMOVED,0,1,e:GetHandler())
		and not e:GetHandler():IsStatus(STATUS_CHAINING) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c1000709.tdfilter,tp,LOCATION_REMOVED,0,1,3,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c1000709.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end