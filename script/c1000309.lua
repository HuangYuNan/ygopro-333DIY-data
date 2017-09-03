--封魔录·邪眼西格玛
function c1000309.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,1000302,aux.FilterBoolFunction(Card.IsFusionSetCard,0x9201),1,true,false)
	--DEFENSE attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c1000309.target)
	e2:SetOperation(c1000309.activate)
	c:RegisterEffect(e2)
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1000309,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c1000309.poscon)
	e2:SetTarget(c1000309.postar)
	e2:SetOperation(c1000309.posop)
	c:RegisterEffect(e2)
end
function c1000309.filter(c)
	return c:IsFacedown() and c:IsDestructable()
end
function c1000309.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and c1000309.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1000309.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c1000309.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	Duel.SetChainLimit(c1000309.limit(g:GetFirst()))
end
function c1000309.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end
function c1000309.limit(c)
	return  function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c1000309.poscon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c1000309.postar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c1000309.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end