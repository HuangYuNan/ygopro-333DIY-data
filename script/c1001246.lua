--长门级战列舰1号舰—长门
if not pcall(function() require("expansions/script/c1001252") end) then require("script/c1001252") end
function c1001246.initial_effect(c)
	c:SetUniqueOnField(1,0,1001246)
	colle.sum3(c,10)
	--th
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1001246,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c1001246.destg)
	e2:SetOperation(c1001246.desop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c1001246.discon)
	e3:SetOperation(c1001246.disop)
	c:RegisterEffect(e3)
	--act
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1001246,0))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1,1246)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c1001246.target)
	e4:SetOperation(c1001246.activate)
	c:RegisterEffect(e4)
	--Remove
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e5:SetValue(LOCATION_REMOVED)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c1001246.recon)
	c:RegisterEffect(e5)
	--1bat
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e6:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c1001246.recon)
	e6:SetValue(c1001246.valcon)
	c:RegisterEffect(e6)
end
function c1001246.filter(c)
	return c:IsAbleToRemove()
end
function c1001246.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1001246.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c1001246.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c1001246.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c1001246.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c1001246.spfilter(c,sca)
	return c:IsFaceup() and c:IsSetCard(sca)
end
function c1001246.discon(e,c)
	return Duel.IsExistingMatchingCard(c1001246.spfilter,tp,LOCATION_MZONE,0,1,nil,0x6206)
		and Duel.IsExistingMatchingCard(c1001246.spfilter,tp,LOCATION_MZONE,0,1,nil,0x9206)
		and Duel.IsExistingMatchingCard(c1001246.spfilter,tp,LOCATION_MZONE,0,1,nil,0xc206)
		and Duel.IsExistingMatchingCard(c1001246.spfilter,tp,LOCATION_MZONE,0,1,nil,0x3206)
end
function c1001246.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e2)
end
function c1001246.filter1(c)
	return c:IsSetCard(0x203) and c:IsAbleToHand()
end
function c1001246.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1001246.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c1001246.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1001246.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c1001246.refilter(c)
	return c:IsFaceup() and c:IsSetCard(0x203)
end
function c1001246.recon(e,c)
	return Duel.IsExistingMatchingCard(c1001246.refilter,tp,LOCATION_MZONE,0,5,nil)
end
function c1001246.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end