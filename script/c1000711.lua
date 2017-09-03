--文花帖·四季映姫
function c1000711.initial_effect(c)
	c:SetUniqueOnField(1,1,1000711)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5204),aux.NonTuner(Card.IsSetCard,0x5204),1)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5204))
	e1:SetValue(c1000711.value)
	c:RegisterEffect(e1)
	--position change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1000711,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c1000711.postg)
	e2:SetOperation(c1000711.posop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetCondition(c1000711.condition)
	e3:SetOperation(c1000711.operation)
	c:RegisterEffect(e3) 
end
function c1000711.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5204)
end
function c1000711.value(e,c)
	return Duel.GetMatchingGroupCount(c1000711.atkfilter,c:GetControler(),LOCATION_GRAVE+LOCATION_EXTRA,0,nil)*150
end
function c1000711.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c1000711.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1000711.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1000711.posfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c1000711.posfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c1000711.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
function c1000711.gfilter(c)
	return c:GetControler()~=tp and c:IsLocation(LOCATION_GRAVE)
end
function c1000711.condition(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if loc==LOCATION_GRAVE then return true end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c1000711.gfilter,1,nil)
end
function c1000711.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
