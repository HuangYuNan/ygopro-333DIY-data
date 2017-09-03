--开辟的乐章 巴麻美
function c1000512.initial_effect(c)
  --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xa204),4,3,nil,nil,5)
	c:EnableReviveLimit()
	--multi attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(c1000512.val)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1000512,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c1000512.cost)
	e2:SetTarget(c1000512.target)
	e2:SetOperation(c1000512.operation)
	c:RegisterEffect(e2)
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c1000512.poscon1)
	e2:SetOperation(c1000512.posop1)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c1000512.necost)
	e3:SetTarget(c1000512.netarget)
	e3:SetOperation(c1000512.neoperation)
	c:RegisterEffect(e3)
end
function c1000512.val(e,c)
	return c:GetOverlayCount()
end
function c1000512.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c1000512.filter(c)
	return c:IsFaceup() and c:GetAttack()>0
		and c:IsType(TYPE_MONSTER)
end
function c1000512.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c1000512.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1000512.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c1000512.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c1000512.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(tc:GetBaseAttack())
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c1000512.poscon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttackedCount()>0
end
function c1000512.posop1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsAttackPos() then
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
	end
end
function c1000512.necost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),c,nil,2,REASON_COST)
end
function c1000512.nefilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa204) and c:IsAbleToHand() 
end
function c1000512.anfilter(c)
	return c:IsSetCard(0xa204) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c1000512.netarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1000512.anfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c1000512.nefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1000512.neoperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1000512.nefilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end