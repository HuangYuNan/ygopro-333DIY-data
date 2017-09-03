--金刚级高速战舰2号舰—比睿
if not pcall(function() require("expansions/script/c1001252") end) then require("script/c1001252") end
function c1001249.initial_effect(c)
	c:SetUniqueOnField(1,0,1001249)
	colle.sum2(c,8)
	--th
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1001248,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c1001249.thtg)
	e2:SetOperation(c1001249.thop)
	c:RegisterEffect(e2)
	--ng
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1001249,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c1001249.negcon)
	e3:SetCost(c1001249.negcost)
	e3:SetTarget(c1001249.negtg)
	e3:SetOperation(c1001249.negop)
	c:RegisterEffect(e3)
	--1bat
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c1001249.bacon)
	e4:SetValue(c1001249.valcon)
	c:RegisterEffect(e4)
end
function c1001249.filter(c)
	return c:IsSetCard(0x9207) and c:IsAbleToHand()
end
function c1001249.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1001249.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c1001249.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1001249.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c1001249.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x203) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c1001249.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c1001249.repfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c1001249.tdfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x203) and c:IsAbleToDeckAsCost()
end
function c1001249.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c1001249.tdfilter1,tp,LOCATION_REMOVED,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c1001249.tdfilter1,tp,LOCATION_REMOVED,0,3,3,nil)
	if g:GetCount()~=3 then return end
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c1001249.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c1001249.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c1001249.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x203)
end
function c1001249.bacon(e,c)
	return Duel.IsExistingMatchingCard(c1001249.filter2,tp,LOCATION_MZONE,0,5,nil)
end
function c1001249.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end