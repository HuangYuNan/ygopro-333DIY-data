--秋月级驱逐舰1号舰—秋月
if not pcall(function() require("expansions/script/c1001252") end) then require("script/c1001252") end
function c1001224.initial_effect(c)
	colle.sum(c,3)
	colle.atkup(c,200)
	colle.cnb(c)
	colle.th(c)
	--②
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101224)
	e3:SetCondition(c1001224.negcon)
	e3:SetTarget(c1001224.neptg)
	e3:SetOperation(c1001224.negop)
	c:RegisterEffect(e3)
end
function c1001224.nefilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x203) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c1001224.fivefilter(c)
	return c:IsFaceup() and c:IsSetCard(0x203)
end
function c1001224.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c1001224.nefilter,1,nil,tp) and Duel.IsChainNegatable(ev) and Duel.IsExistingMatchingCard(c1001224.fivefilter,tp,LOCATION_MZONE,0,5,nil)
end
function c1001224.neptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c1001224.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end