--魔法的少女 百江渚
function c1001202.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3205),3,2)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1001202,4))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(c1001202.tg)
	e1:SetOperation(c1001202.op)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c1001202.splimit)
	c:RegisterEffect(e2)
	--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c1001202.pencon)
	e4:SetTarget(c1001202.pentg)
	e4:SetOperation(c1001202.penop)
	c:RegisterEffect(e4)
	--to grave
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c1001202.thcost)
	e5:SetTarget(c1001202.sptg)
	e5:SetOperation(c1001202.spop)
	c:RegisterEffect(e5)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(1001202,1))
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e6:SetHintTiming(0,TIMING_END_PHASE)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c1001202.pttg)
	e6:SetOperation(c1001202.ptop)
	c:RegisterEffect(e6)
	--Destroy to ToHand
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(1001202,2))
	e7:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCountLimit(1,29002)
	e7:SetCondition(c1001202.condition1)
	e7:SetTarget(c1001202.drtg)
	e7:SetOperation(c1001202.drop)
	c:RegisterEffect(e7)
	--Destroy to Damage
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(1001202,3))
	e8:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetCountLimit(1,29002)
	e8:SetCondition(c1001202.condition1)
	e8:SetTarget(c1001202.drtg1)
	e8:SetOperation(c1001202.drop1)
	c:RegisterEffect(e8)
end
c1001202.pendulum_level=3
function c1001202.condition1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c1001202.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x3205) and c:IsDestructable()
		and Duel.IsExistingMatchingCard(c1001202.spfilter2,tp,LOCATION_MZONE,0,1,nil,c:GetCode())
end
function c1001202.filter2(c,code)
	return c:IsSetCard(0x3205) and not c:IsCode(code)
end
function c1001202.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c1001202.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c1001202.filter1,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c1001202.filter1,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c1001202.drop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c1001202.filter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		end
	end
end
function c1001202.desfilter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c1001202.drtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c1001202.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c1001202.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c1001202.drop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Damage(1-tp,500,REASON_EFFECT)
		Duel.Recover(tp,500,REASON_EFFECT)
	end
end
function c1001202.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c1001202.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,1001203,0,0x4011,200,200,1,RACE_SPELLCASTER,ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c1001202.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,1001203,0,0x4011,200,200,1,RACE_SPELLCASTER,ATTRIBUTE_FIRE) then
		local token=Duel.CreateToken(tp,1001203)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetValue(c1001202.atkval)
		token:RegisterEffect(e1)
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,1001203,0,0x4011,200,200,1,RACE_SPELLCASTER,ATTRIBUTE_FIRE) then
		local token=Duel.CreateToken(tp,1001203)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetValue(c1001202.atkval)
		token:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
function c1001202.atkval(e)
	local tp=e:GetHandlerPlayer()
	local lpd=Duel.GetLP(tp)-Duel.GetLP(1-tp)
	if lpd<0 then lpd=-lpd end
	if lpd>2500 then lpd=2500 end
	return lpd
end
function c1001202.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0x3205) or c:IsSetCard(0x5205) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c1001202.filter(c,e,tp,ft)
	return c:IsSetCard(0x3205) and c:IsLevelBelow(3) and c:IsType(TYPE_PENDULUM) and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c1001202.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c1001202.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,ft) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c1001202.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1001202.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp,ft)
	local tc=g:GetFirst()
	if tc then
		if ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(1001202,1))) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
function c1001202.pencon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c1001202.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lsc=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rsc=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g=Group.FromCards(lsc,rsc):Filter(Card.IsDestructable,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c1001202.penop(e,tp,eg,ep,ev,re,r,rp)
	local lsc=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rsc=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g=Group.FromCards(lsc,rsc)
	if Duel.Destroy(g,REASON_EFFECT)~=0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
	e:GetHandler():RegisterFlagEffect(1001202,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
end
function c1001202.ptfilter(c)
	return c:IsDestructable()
end
function c1001202.pttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c1001202.ptfilter,tp,0,LOCATION_ONFIELD,1,nil) and c:GetFlagEffect(1001202)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,1001204,0,0x4011,0,0,7,RACE_AQUA,ATTRIBUTE_WATER) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c1001202.ptfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c1001202.ptop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,1001204,0,0x4011,0,0,7,RACE_AQUA,ATTRIBUTE_WATER) then
		local token=Duel.CreateToken(tp,1001204)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(2500)
		token:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
	end
end