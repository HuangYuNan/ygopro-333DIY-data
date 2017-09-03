--救赎的少女	巴麻美
function c1000509.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),8,3,c1000509.ovfilter,aux.Stringid(1000509,0),3,c1000509.xyzop)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1000509,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e1:SetCondition(c1000509.con)
	e1:SetCost(c1000509.cost)
	e1:SetTarget(c1000509.thtg)
	e1:SetOperation(c1000509.thop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1000509,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetCondition(c1000509.con)
	e2:SetCost(c1000509.cost)
	e2:SetTarget(c1000509.destg)
	e2:SetOperation(c1000509.desop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1000509,3))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(c1000509.damcon)
	e3:SetCost(c1000509.cost)
	e3:SetTarget(c1000509.damtg)
	e3:SetOperation(c1000509.damop)
	c:RegisterEffect(e3)
	--attack/def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c1000509.atkval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)
	--pierce
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e6)
end
function c1000509.disfilter(c)
	return  c:IsSetCard(0xa204) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c1000509.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa204) and c:GetCode()~=1000509
	 and (c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ))
end
function c1000509.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1000509.disfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c1000509.disfilter,1,1,REASON_COST+REASON_DISCARD)
	e:GetHandler():RegisterFlagEffect(1000509,RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END,0,1)
end
function c1000509.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and 
	 e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0xa204)
end
function c1000509.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c1000509.thfilter(c)
	return  bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and c:IsAbleToHand()
end
function c1000509.xfilter(c)
	return c:GetLevel()>0
end
function c1000509.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1000509.thfilter,tp,0,LOCATION_MZONE,1,nil)  
	and e:GetHandler():GetFlagEffect(1000509)==0 end
	local g=Duel.GetMatchingGroup(c1000509.thfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	local ct1=g:Filter(c1000509.xfilter,nil):GetSum(Card.GetLevel)
	local ct2=g:Filter(Card.IsType,nil,TYPE_XYZ):GetSum(Card.GetRank)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,(ct1+ct2)*150)
end
function c1000509.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c1000509.thfilter,tp,0,LOCATION_MZONE,nil)
	if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		local ct1=Duel.GetOperatedGroup():Filterfunction(c1000509.xfilter,nil):GetSum(Card.GetLevel)
		local ct2=Duel.GetOperatedGroup():Filter(Card.IsType,nil,TYPE_XYZ):GetSum(Card.GetRank)
		Duel.Damage(1-tp,(ct1+ct2)*150,REASON_EFFECT)
	end
end
function c1000509.desfilter(c)
	return (c:GetSequence()==6 or c:GetSequence()==7) and c:IsDestructable()
end
function c1000509.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xa204) 
end
function c1000509.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1000509.desfilter,tp,LOCATION_SZONE,0,1,nil)
	and Duel.IsExistingMatchingCard(c1000509.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil) 
	and e:GetHandler():GetFlagEffect(1000509)==0	end
	local g=Duel.GetMatchingGroup(c1000509.desfilter,tp,LOCATION_SZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c1000509.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c1000509.desfilter,tp,LOCATION_SZONE,0,nil)
	if Duel.Destroy(tg,REASON_EFFECT)>0 then
	local g=Duel.SelectMatchingCard(tp,c1000509.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,2,nil)
	if g:GetCount()==2 then
	local tc=g:GetFirst()
	while tc do
		if (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)) then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		tc=g:GetNext()
	end
	end
end
end
end
function c1000509.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsType(TYPE_MONSTER)
end
function c1000509.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local dam=bc:GetAttack()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
end
function c1000509.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c1000509.atkfilter(c)
	return  c:IsSetCard(0xa204) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c1000509.atkval(e,c)
	return Duel.GetMatchingGroupCount(c1000509.atkfilter,c:GetControler(),LOCATION_GRAVE+LOCATION_EXTRA,0,nil)*300
end
