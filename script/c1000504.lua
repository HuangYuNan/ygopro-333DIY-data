--轰鸣的声音 巴麻美
function c1000504.initial_effect(c)
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
	e2:SetTarget(c1000504.splimit)
	c:RegisterEffect(e2)
	--extra summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e3:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa204))
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,1000504)
	e4:SetTarget(c1000504.tg)
	e4:SetOperation(c1000504.op)
	c:RegisterEffect(e4)
	--atk down
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCategory(CATEGORY_DEFCHANGE+CATEGORY_ATKCHANGE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,4567127)
	e5:SetCondition(c1000504.atkcon)
	e5:SetTarget(c1000504.atktg)
	e5:SetOperation(c1000504.atkop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e6) 
	--[[--act limit
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	e7:SetRange(LOCATION_PZONE)
	e7:SetCondition(c1000504.limcon)
	e7:SetOperation(c1000504.limop)
	c:RegisterEffect(e3)
	local e8=e7:Clone()
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e8)
	local e9=e7:Clone()
	e9:SetCode(EVENT_FILP_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_CANNOT_ACTIVATE)
	e10:SetTargetRange(0,1)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetRange(LOCATION_PZONE)
	e10:SetValue(c1000504.aclimit)
	e10:SetCondition(c1000504.actcon)
	c:RegisterEffect(e10)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e11:SetRange(LOCATION_PZONE)
	e11:SetCode(EVENT_CHAIN_END)
	e11:SetOperation(c1000504.limop2)
	c:RegisterEffect(e11)--]]
	--xyzlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c1000504.xyzlimit)
	c:RegisterEffect(e3) 
end
function c1000504.splimit(e,c,tp,sumtp,sumpos)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	if tc and not tc:IsSetCard(0xa204) then
		return not c:IsSetCard(0xa204)
	end
end
function c1000504.filter(c,e,tp,ft)
	return c:GetCode()==1000504 and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c1000504.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c1000504.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,ft) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c1000504.op(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1000504.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,ft)
	local tc=g:GetFirst()
	if tc then
		if ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(1000504,1))) then
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
function c1000504.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
	and re:GetHandler():IsSetCard(0xa204)
		and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c1000504.atkfilter(c)
	return c:IsSetCard(0xa204) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c1000504.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroupCount(c1000504.atkfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil)
	if chk==0 then return g1>0 and g2>0 end 
end
function c1000504.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local cg=Duel.GetMatchingGroupCount(c1000504.atkfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil)
	if   g1:GetCount()>0 and cg>0 then
		local tg=g1:GetFirst()
		while tg do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(cg*-200)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tg:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tg:RegisterEffect(e2)
		tg=g1:GetNext()
		end
	end
end
function c1000504.limfilter(c,tp)
	return c:GetSummonPlayer()==tp and  c:IsFaceup() and  c:IsSetCard(0xa204) 
end
function c1000504.limcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1000504.limfilter,1,nil,tp) 
end
function c1000504.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(c1000504.chainlm)
	else
		e:GetHandler():RegisterFlagEffect(1000504,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c1000504.chainlm(e,rp,tp)
	return tp==rp 
end
function c1000504.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c1000504.actcon(e)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return ( a and a:IsControler(e:GetHandlerPlayer()) and (a:IsSetCard(0x984) or a:IsSetCard(0x985)))
	 or (d and d:IsControler(e:GetHandlerPlayer()) and  (d:IsSetCard(0x984) or d:IsSetCard(0x985)))
end
function c1000504.limop2(e,tp,eg,ep,ev,re,r,rp)
	if  e:GetHandler():GetFlagEffect(1000504)~=0 then
		Duel.SetChainLimitTillChainEnd(c1000504.chainlm)
	end
	e:GetHandler():ResetFlagEffect(1000504)
end
function c1000504.xyzlimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_SPELLCASTER)
end