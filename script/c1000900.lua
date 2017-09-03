--叶族人先祖
function c1000900.initial_effect(c)
	 --synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xc201),aux.NonTuner(Card.IsAttribute,ATTRIBUTE_EARTH),1)
	c:EnableReviveLimit()
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1000900,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c1000900.con)
	e1:SetCost(c1000900.thcost)
	e1:SetTarget(c1000900.tg)
	e1:SetOperation(c1000900.op)
	c:RegisterEffect(e1)
	--atk/lv up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1000900,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c1000900.cost)
	e2:SetOperation(c1000900.operation)
	c:RegisterEffect(e2)
	--必须支付COST
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c1000900.efcon)
	e3:SetOperation(c1000900.efop)
	c:RegisterEffect(e3)
end
function c1000900.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c1000900.thfilter(c)
	return c:IsRace(RACE_PLANT) and c:IsAbleToDeckAsCost()
end
function c1000900.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1000900.thfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c1000900.thfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c1000900.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c1000900.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c1000900.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,nil,1,nil) end
	local rg=Duel.SelectReleaseGroupEx(tp,nil,1,1,nil)
	Duel.Release(rg,REASON_COST)
end
function c1000900.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_LEVEL)
		e2:SetValue(1)
		c:RegisterEffect(e2)
	end
end
function c1000900.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c1000900.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SUMMON_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(c1000900.sumtg)
	e1:SetCost(c1000900.ccost)
	e1:SetOperation(c1000900.acop)
	rc:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SPSUMMON_COST)
	rc:RegisterEffect(e2,true)
	--accumulate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(0x10000000+1000900)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	rc:RegisterEffect(e3,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_TYPE)
		e2:SetValue(TYPE_MONSTER+TYPE_EFFECT+TYPE_XYZ)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2)
	end
end
function c1000900.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and e:GetHandler():IsSetCard(0xc201)
end
function c1000900.sumtg(e,c)
	return c:GetRace()~=RACE_PLANT
end
function c1000900.ccost(e,c,tp)
	return Duel.CheckLPCost(tp,500)
end
function c1000900.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,500)
end