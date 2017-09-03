--束缚的天网 巴麻美
function c1000505.initial_effect(c)
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
	e2:SetTarget(c1000505.splimit)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa204))
	e3:SetValue(300)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--level
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_PZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetCode(EFFECT_CHANGE_LEVEL)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa204))
	e5:SetValue(4)
	c:RegisterEffect(e5)
	--ret&draw
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(1000505,0))
	e6:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_DESTROY)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCountLimit(1,1000505)
	e6:SetTarget(c1000505.tdtg)
	e6:SetOperation(c1000505.tdop)
	c:RegisterEffect(e6)
	--synchro limit
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetValue(c1000505.limit)
	c:RegisterEffect(e7)
	--spsummon
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_SPSUMMON_PROC)
	e8:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e8:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e8:SetCountLimit(1,4567129)
	e8:SetCondition(c1000505.spcon)
	e8:SetOperation(c1000505.spop)
	c:RegisterEffect(e8)
	--pos
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e9:SetCategory(CATEGORY_POSITION)
	e9:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e9:SetCode(EVENT_TO_GRAVE)
	e9:SetCountLimit(1,4567130)
	e9:SetCondition(c1000505.poscon)
	e9:SetTarget(c1000505.postg)
	e9:SetOperation(c1000505.posop)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e10)
	--xyzlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c1000505.xyzlimit)
	c:RegisterEffect(e3)  
end
function c1000505.splimit(e,c,tp,sumtp,sumpos)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	if tc and not tc:IsSetCard(0xa204) then
		return not c:IsSetCard(0xa204)
	end
end
function c1000505.tdfilter(c)
	return c:IsSetCard(0xa204) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c1000505.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c1000505.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(c1000505.tdfilter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c1000505.tdfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),0,tp,1)
end
function c1000505.tgfilter(c,e)
	return not c:IsRelateToEffect(e)
end
function c1000505.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not e:GetHandler():IsRelateToEffect(e) or tg:IsExists(c1000505.tgfilter,1,nil,e) then return end
	if Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)>0 then
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	Duel.Draw(tp,1,REASON_EFFECT)
end
end
function c1000505.limit(e,c)
	if not c then return false end
	return not (c:IsRace(RACE_SPELLCASTER) or c:IsAttribute(ATTRIBUTE_EARTH))
end
function c1000505.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local tc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	return tc1 and tc1:IsSetCard(0xa204) and tc2 and tc2:IsSetCard(0xa204)
end
function c1000505.spop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_DECK)
		c:RegisterEffect(e1,true)
end
function c1000505.poscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
	and re:GetHandler():IsSetCard(0xa204)
		and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c1000505.posfilter(c)
	return not c:IsPosition(POS_FACEUP_DEFENSE)
end
function c1000505.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1000505.posfilter,tp,0,LOCATION_MZONE,1,nil) end
	local ct=Duel.GetMatchingGroup(c1000505.posfilter,tp,0,LOCATION_MZONE,nil) 
	Duel.SetOperationInfo(0,CATEGORY_POSITION,ct,ct:GetCount(),0,0)
end
function c1000505.posop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local ct=Duel.GetMatchingGroup(c1000505.posfilter,tp,0,LOCATION_MZONE,nil)  
	if ct:GetCount()>0 then
	local g=ct:GetFirst()
	while g do  
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,nil,POS_FACEUP_DEFENSE,true)
	g=ct:GetNext()
	end
end
end
function c1000505.xyzlimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_SPELLCASTER)
end