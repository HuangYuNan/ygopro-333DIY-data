--千岁级轻空母2号舰—千代田
if not pcall(function() require("expansions/script/c1001252") end) then require("script/c1001252") end
function c1001243.initial_effect(c)
	colle.sum(c,2)
	colle.thc(c)
	--th
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1001243,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c1001243.thtg)
	e2:SetOperation(c1001243.thop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1001243,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,1243)
	e3:SetCondition(c1001243.condition)
	e3:SetTarget(c1001243.destg)
	e3:SetOperation(c1001243.desop)
	c:RegisterEffect(e3)
end
function c1001243.filter(c)
	return c:IsSetCard(0x6207) and c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c1001243.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1001243.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1001243.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1001243.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c1001243.twfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa206)
end
function c1001243.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1001243.twfilter,tp,LOCATION_MZONE,0,2,nil)
end
function c1001243.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6207)
end
function c1001243.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c1001243.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1001243.cfilter,tp,LOCATION_SZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c1001243.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c1001243.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c1001243.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(c1001243.cfilter,tp,LOCATION_SZONE,0,nil)
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c1001243.desfilter,tp,0,LOCATION_ONFIELD,1,ct,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local tc=mg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-300)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
			tc=mg:GetNext()
		end
	end
end