--金刚级高速战舰3号舰—榛名
if not pcall(function() require("expansions/script/c1001252") end) then require("script/c1001252") end
function c1001250.initial_effect(c)
	c:SetUniqueOnField(1,0,1001250)
	colle.sum2(c,8)
	--th
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1001248,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c1001250.thtg)
	e2:SetOperation(c1001250.thop)
	c:RegisterEffect(e2)
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1000073,3))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c1001250.con)
	e3:SetTarget(c1001250.target)
	e3:SetOperation(c1001250.operation)
	c:RegisterEffect(e3)
	--1bat
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c1001250.bacon)
	e4:SetValue(c1001250.valcon)
	c:RegisterEffect(e4)
end
function c1001250.filter(c)
	return c:IsSetCard(0x9207) and c:IsAbleToHand() and not c:IsCode(1001250)
end
function c1001250.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1001250.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c1001250.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1001250.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c1001250.spfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c1001250.con(e,c)
	return Duel.IsExistingMatchingCard(c1001250.spfilter,tp,LOCATION_MZONE,0,1,nil,1001248)
		and Duel.IsExistingMatchingCard(c1001250.spfilter,tp,LOCATION_MZONE,0,1,nil,1001249)
		and Duel.IsExistingMatchingCard(c1001250.spfilter,tp,LOCATION_MZONE,0,1,nil,1001250)
		and Duel.IsExistingMatchingCard(c1001250.spfilter,tp,LOCATION_MZONE,0,1,nil,1001251)
end
function c1001250.filter1(c)
	return c:IsSetCard(0x203) and c:IsSummonable(true,nil)
end
function c1001250.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1001250.filter1,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c1001250.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c1001250.filter1,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function c1001250.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x203)
end
function c1001250.bacon(e,c)
	return Duel.IsExistingMatchingCard(c1001250.filter2,tp,LOCATION_MZONE,0,5,nil)
end
function c1001250.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end