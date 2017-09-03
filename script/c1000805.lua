--圆环之理的使者 美树沙耶香
function c1000805.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_RITUAL),6,2)
	c:EnableReviveLimit()
	--cannot be battle target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetCondition(c1000805.aatkcon)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.TRUE)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c1000805.reptg)
	c:RegisterEffect(e3)
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,7210)
	e4:SetCondition(c1000805.descon)
	e4:SetCost(c1000805.spcost)
	e4:SetTarget(c1000805.sptg)
	e4:SetOperation(c1000805.spop)
	c:RegisterEffect(e4)
end
function c1000805.aatkcon(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,1000808)
end
function c1000805.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectYesNo(tp,aux.Stringid(1000805,0)) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end
function c1000805.filter(c)
	return c:IsSetCard(0x3204)
end
function c1000805.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(c1000805.filter,1,nil)
end
function c1000805.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c1000805.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,1000808,0,0x4011,2800,2500,8,RACE_AQUA,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c1000805.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,1000808,0,0x4011,2800,2500,8,RACE_AQUA,ATTRIBUTE_WATER) then
		local token=Duel.CreateToken(tp,1000808)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end