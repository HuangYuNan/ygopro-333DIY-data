--无限的魔奏 巴麻美
function c1000503.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c1000503.splimit)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1000503,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,0x1e0)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c1000503.imtg)
	e3:SetOperation(c1000503.imop)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,1000503)
	e4:SetTarget(c1000503.tg)
	e4:SetOperation(c1000503.op)
	c:RegisterEffect(e4)
	--neg
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,4567125)
	e5:SetCondition(c1000503.negcon)
	e5:SetTarget(c1000503.negtg)
	e5:SetOperation(c1000503.negop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e6)
	--xyzlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c1000503.xyzlimit)
	c:RegisterEffect(e3)  
end
function c1000503.splimit(e,c,tp,sumtp,sumpos)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	if tc and not tc:IsSetCard(0xa204) then
		return not c:IsSetCard(0xa204)
	end
end
function c1000503.filter(c,e,tp,ft)
	return c:GetCode()==1000503 and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c1000503.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c1000503.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,ft) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c1000503.op(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1000503.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,ft)
	local tc=g:GetFirst()
	if tc then
		if ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(1000503,1))) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
function c1000503.imfilter(c)
	return c:IsSetCard(0xa204) and c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c1000503.imtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c1000503.imfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1000503.imfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c1000503.imfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c1000503.imop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c1000503.efilter)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		if c:IsRelateToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
	end
end
function c1000503.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function c1000503.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
	and re:GetHandler():IsSetCard(0xa204)
		and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c1000503.seqfilter(c,tp)
	return  c:IsSetCard(0xa204) and c:IsType(TYPE_XYZ) and c:IsFaceup() and 
	 Duel.IsExistingMatchingCard(c1000503.negfilter,tp,0,LOCATION_ONFIELD,1,nil,c)
end
function c1000503.negfilter(c,tc)
	local g=(4-tc:GetSequence())
	return c:GetSequence()==g and c:IsFaceup() and (c:IsType(TYPE_MONSTER) or 
	 (c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsDisabled()))
end
function c1000503.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c1000503.seqfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c1000503.seqfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c1000503.seqfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c1000503.negop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c1000503.negfilter,tp,0,LOCATION_ONFIELD,nil,tc)
	if tc:IsRelateToEffect(e) and g:GetCount()>0 then
		local tg=g:GetFirst()
		while tg do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tg:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tg:RegisterEffect(e2)
		if tc:IsType(TYPE_MONSTER) then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetValue(0)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tg:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_SET_DEFENSE_FINAL)
		tg:RegisterEffect(e4)
		end
		tg=g:GetNext()
	end
end
end
function c1000503.xyzlimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_SPELLCASTER)
end