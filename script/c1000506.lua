--战后的红茶 巴麻美
function c1000506.initial_effect(c)
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
	e2:SetTarget(c1000506.splimit)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCountLimit(1,1000506)
	e3:SetTarget(c1000506.retg)
	e3:SetOperation(c1000506.reop)
	c:RegisterEffect(e3)
	--synchro effect
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1000506,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e4:SetCountLimit(1)
	e4:SetCondition(c1000506.sccon)
	e4:SetTarget(c1000506.sctg)
	e4:SetOperation(c1000506.scop)
	c:RegisterEffect(e4)
	--synchro limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetValue(c1000506.limit)
	c:RegisterEffect(e5)
	--buff
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCountLimit(1,4567132)
	e6:SetCondition(c1000506.atkcon)
	e6:SetTarget(c1000506.atktg)
	e6:SetOperation(c1000506.atkop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e7) 
	--spsummon
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_PZONE)
	e8:SetCountLimit(1,4567133)
	e8:SetTarget(c1000506.tg)
	e8:SetOperation(c1000506.op)
	c:RegisterEffect(e8)
	--xyzlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c1000506.xyzlimit)
	c:RegisterEffect(e3) 
end
function c1000506.splimit(e,c,tp,sumtp,sumpos)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	if tc and not tc:IsSetCard(0xa204) then
		return not c:IsSetCard(0xa204)
	end
end
function c1000506.filter(c)
	return c:IsSetCard(0xa204) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c1000506.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local count=Duel.GetMatchingGroupCount(c1000506.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,count*200)
end
function c1000506.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local count=Duel.GetMatchingGroupCount(c1000506.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
	if  c:IsRelateToEffect(e) and  count>0 then
		Duel.Recover(tp,count*200,REASON_EFFECT)
	end
end
function c1000506.sccon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return false end
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_BATTLE or ph==PHASE_MAIN2
end
function c1000506.mfilter(c)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial()
end
function c1000506.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c1000506.mfilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c1000506.scop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c1000506.mfilter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
	end
end
function c1000506.limit(e,c)
	if not c then return false end
	return not (c:IsRace(RACE_SPELLCASTER) or c:IsAttribute(ATTRIBUTE_EARTH))
end
function c1000506.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
	and re:GetHandler():IsSetCard(0xa204)
		and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c1000506.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xa204)
end
function c1000506.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c1000506.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1000506.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c1000506.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c1000506.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local lp1=Duel.GetLP(tp)
	local lp2=Duel.GetLP(1-tp)
	local dif
	if lp2>lp1 then
	dif=lp2-lp1 
	else
	dif=lp1-lp2
	end
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(dif)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		--hands
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetDescription(aux.Stringid(1000506,1))
		e3:SetCategory(CATEGORY_DRAW)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e3:SetCode(EVENT_BATTLE_DAMAGE)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCondition(c1000506.hcon)
		e3:SetTarget(c1000506.htg)
		e3:SetOperation(c1000506.hop)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
	end
end
function c1000506.hcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c1000506.htg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)

end
function c1000506.hop(e,tp,eg,ep,ev,re,r,rp)
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
end 
function c1000506.spfilter(c,e,tp,ft)
	return c:GetLevel()==4 and c:IsSetCard(0xa204) and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c1000506.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c1000506.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,ft) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),0,tp,1)
end
function c1000506.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1000506.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,ft)
	local tc=g:GetFirst()
	if tc then
		if ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(1000506,2))) 
			and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		tc:RegisterFlagEffect(1000506,RESET_EVENT+0x1fe0000,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabelObject(tc)
		e1:SetCondition(c1000506.descon)
		e1:SetOperation(c1000506.desop)
		Duel.RegisterEffect(e1,tp)
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		end
	end
end
function c1000506.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(1000506)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c1000506.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
function c1000506.xyzlimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_SPELLCASTER)
end