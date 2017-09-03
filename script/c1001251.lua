--金刚级高速战舰4号舰—雾岛
if not pcall(function() require("expansions/script/c1001252") end) then require("script/c1001252") end
function c1001251.initial_effect(c)
	c:SetUniqueOnField(1,0,1001251)
	colle.sum2(c,8)
	--th
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1001251,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c1001251.thtg)
	e2:SetOperation(c1001251.thop)
	c:RegisterEffect(e2)
	--Negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1001251,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c1001251.condition)
	e3:SetCost(c1001251.cost)
	e3:SetTarget(c1001251.target)
	e3:SetOperation(c1001251.operation)
	c:RegisterEffect(e3)
	--1bat
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c1001251.bacon)
	e4:SetValue(c1001251.valcon)
	c:RegisterEffect(e4)
end
function c1001251.filter(c)
	return c:IsSetCard(0x9207) and c:IsAbleToHand()
end
function c1001251.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1001251.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c1001251.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1001251.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c1001251.tdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x203) and c:IsAbleToDeckAsCost()
end
function c1001251.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c1001251.tdfilter,tp,LOCATION_REMOVED,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c1001251.tdfilter,tp,LOCATION_REMOVED,0,3,3,nil)
	if g:GetCount()~=3 then return end
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c1001251.condition(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
	if re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-tg:GetCount()>0
end
function c1001251.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c1001251.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c1001251.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x203)
end
function c1001251.bacon(e,c)
	return Duel.IsExistingMatchingCard(c1001251.filter2,tp,LOCATION_MZONE,0,5,nil)
end
function c1001251.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end