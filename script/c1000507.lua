--终焉的乐章 巴麻美
function c1000507.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xa204),4,2,nil,nil,5)
	c:EnableReviveLimit()
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetDescription(aux.Stringid(1000507,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c1000507.con)
	e1:SetCost(c1000507.cost)
	e1:SetTarget(c1000507.target)
	e1:SetOperation(c1000507.operation)
	e1:SetLabel(3)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c1000507.efilter)
	e2:SetLabel(4)
	c:RegisterEffect(e2)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetDescription(aux.Stringid(1000507,2))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,0x1e0)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c1000507.con)
	e4:SetCost(c1000507.cost2)
	e4:SetTarget(c1000507.destg)
	e4:SetOperation(c1000507.desop)
	e4:SetLabel(5)
	c:RegisterEffect(e4)
	--Activate
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,1000507)
	e5:SetTarget(c1000507.tg)
	e5:SetOperation(c1000507.activate)
	c:RegisterEffect(e5)
end
function c1000507.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>=e:GetLabel()
end
function c1000507.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c1000507.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c1000507.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c1000507.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetOverlayCount()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,g,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,g,g,REASON_COST)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c1000507.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c1000507.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c1000507.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function c1000507.filter(c)
	return c:IsSetCard(0xa204) and c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c1000507.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c1000507.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1000507.filter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c1000507.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c1000507.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e)
	or not e:GetHandler():IsRelateToEffect(e)   then return end
		Duel.Overlay(tc,e:GetHandler())
end