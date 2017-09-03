colle=colle or {}

function colle.sum(c,ct)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_HAND,0,ct,e:GetHandler(),0x203) end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1001252,1))
		local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_HAND,0,ct,ct,e:GetHandler(),0x203)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end)
	e4:SetTarget(colle.sstg)
	e4:SetOperation(colle.ssop)
	c:RegisterEffect(e4)
end
function colle.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function colle.ssop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end

function colle.sum2(c,lv)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(function(e,c)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		if c==nil then return true end
		local tp=c:GetControler()
		local g=Duel.GetMatchingGroup(colle.sumfilter,tp,LOCATION_GRAVE,0,nil)
		return g:CheckWithSumEqual(Card.GetLevel,lv,1,99)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp,c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.GetMatchingGroup(colle.sumfilter,tp,LOCATION_GRAVE,0,nil)
		local sg=g:SelectWithSumEqual(tp,Card.GetLevel,lv,1,99)
		Duel.Remove(sg,POS_FACEUP,REASON_COST)
	end)
	c:RegisterEffect(e2)
end
function colle.sumfilter(c)
	return c:IsSetCard(0x203) and c:IsAbleToRemoveAsCost() and c:GetLevel()~=8
end
function colle.sum3(c,lv)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(function(e,c)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		if c==nil then return true end
		local tp=c:GetControler()
		local g=Duel.GetMatchingGroup(colle.sumfilter1,tp,LOCATION_GRAVE,0,nil)
		return g:CheckWithSumEqual(Card.GetLevel,lv,1,99)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp,c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.GetMatchingGroup(colle.sumfilter1,tp,LOCATION_GRAVE,0,nil)
		local sg=g:SelectWithSumEqual(tp,Card.GetLevel,lv,1,99)
		Duel.Remove(sg,POS_FACEUP,REASON_COST)
	end)
	c:RegisterEffect(e2)
end
function colle.sumfilter1(c)
	return c:IsSetCard(0x203) and c:IsAbleToRemoveAsCost() and c:GetLevel()~=10
end

function colle.atkup(c,atk)
	local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_SINGLE)
	e21:SetCode(EFFECT_UPDATE_ATTACK)
	e21:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e21:SetRange(LOCATION_MZONE)
	e21:SetValue(function(e,c)
	return Duel.GetMatchingGroupCount(Card.IsSetCard,c:GetControler(),LOCATION_MZONE,0,nil,0x203)*atk
	end)
	c:RegisterEffect(e21)
end
function colle.cnb(c)
	local e22=Effect.CreateEffect(c)
	e22:SetDescription(aux.Stringid(1001252,0))
	e22:SetType(EFFECT_TYPE_IGNITION)
	e22:SetRange(LOCATION_MZONE)
	e22:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e22:SetCountLimit(1)
	e22:SetCondition(colle.con1)
	e22:SetOperation(colle.op1)
	c:RegisterEffect(e22)
end
function colle.cnbfilter_a(c)
	return c:IsFaceup() and c:IsSetCard(0x3206)
end
function colle.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(colle.cnbfilter_a,tp,LOCATION_MZONE,0,3,nil)
end
function colle.cnb1(c)
	local e23=Effect.CreateEffect(c)
	e23:SetDescription(aux.Stringid(1001252,0))
	e23:SetType(EFFECT_TYPE_IGNITION)
	e23:SetRange(LOCATION_MZONE)
	e23:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e23:SetCountLimit(1)
	e23:SetCondition(colle.con2)
	e23:SetOperation(colle.op2)
	c:RegisterEffect(e23)
end
function colle.cnbfilter_b(c)
	return c:IsFaceup() and c:IsSetCard(0x5207)
end
function colle.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(colle.cnbfilter_b,tp,LOCATION_MZONE,0,2,nil)
end
function colle.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(1001252,0))
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(aux.imval1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
		c:RegisterEffect(e2)
	end
end
function colle.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(1001252,0))
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(aux.imval1)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
	end
end
function colle.thfilter(c)
	return c:IsSetCard(0x203) and c:IsAbleToHand()
end
function colle.th(c)
	local e24=Effect.CreateEffect(c)
	e24:SetDescription(aux.Stringid(1001252,1))
	e24:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e24:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e24:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e24:SetCode(EVENT_TO_GRAVE)
	e24:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
	end)
	e24:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(colle.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end)
	e24:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,colle.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		end
	end)
	c:RegisterEffect(e24)
end
function colle.thc(c)
	local e24=Effect.CreateEffect(c)
	e24:SetDescription(aux.Stringid(1001252,1))
	e24:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e24:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e24:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e24:SetCode(EVENT_TO_GRAVE)
	e24:SetCountLimit(1,c:GetCode())
	e24:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
	end)
	e24:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(colle.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end)
	e24:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,colle.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		end
	end)
	c:RegisterEffect(e24)
end
function colle.th1(c)
	local e25=Effect.CreateEffect(c)
	e25:SetDescription(aux.Stringid(1001252,1))
	e25:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e25:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e25:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e25:SetCode(EVENT_TO_GRAVE)
	e25:SetCountLimit(1,c:GetCode())
	e25:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(colle.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end)
	e25:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,colle.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		end
	end)
	c:RegisterEffect(e25)
end
function colle.fivefilter(c)
	return c:IsFaceup() and c:IsSetCard(0x203)
end
function colle.posfilter(c)
	return c:IsPosition(POS_FACEUP_DEFENSE) and c:IsDestructable()
end
function colle.defwd(c)
	--Activate
	local e26=Effect.CreateEffect(c)
	e26:SetDescription(aux.Stringid(1001252,2))
	e26:SetCategory(CATEGORY_DESTROY)
	e26:SetType(EFFECT_TYPE_IGNITION)
	e26:SetRange(LOCATION_MZONE)
	e26:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e26:SetCountLimit(1,c:GetCode())
	e26:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(colle.fivefilter,tp,LOCATION_MZONE,0,5,nil)
	end)
	e26:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(colle.posfilter,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,colle.posfilter,tp,0,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end)
	e26:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
	end)
	c:RegisterEffect(e26)
end
function colle.fivefilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x5206)
end
function colle.posfilter1(c)
	return c:IsPosition(POS_FACEUP_DEFENSE) and c:IsDestructable()
end
function colle.defwd1(c)
	--Activate
	local e26=Effect.CreateEffect(c)
	e26:SetDescription(aux.Stringid(1001252,2))
	e26:SetCategory(CATEGORY_DESTROY)
	e26:SetType(EFFECT_TYPE_IGNITION)
	e26:SetRange(LOCATION_MZONE)
	e26:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e26:SetCountLimit(1,c:GetCode())
	e26:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(colle.fivefilter1,tp,LOCATION_MZONE,0,3,nil)
	end)
	e26:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(colle.posfilter1,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,colle.posfilter1,tp,0,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end)
	e26:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
	end)
	c:RegisterEffect(e26)
end