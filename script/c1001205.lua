--学姐的宠物 百江渚
function c1001205.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c1001205.condition)
	e2:SetTarget(c1001205.target)
	c:RegisterEffect(e2)
	--cannot direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c1001205.condition)
	e3:SetTarget(c1001205.atktarget)
	c:RegisterEffect(e3)
	--dam/2
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCondition(c1001205.rdcon)
	e4:SetOperation(c1001205.rdop)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e5:SetCountLimit(1,290051)
	e5:SetCondition(c1001205.spcon1)
	e5:SetTarget(c1001205.sptg1)
	e5:SetOperation(c1001205.spop1)
	c:RegisterEffect(e5)
	--fusion
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,290052)
	e6:SetCost(c1001205.cost)
	e6:SetTarget(c1001205.target_a)
	e6:SetOperation(c1001205.activate_a)
	c:RegisterEffect(e6)
end
function c1001205.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(0)~=Duel.GetLP(1)
end
function c1001205.atktarget(e,c)
	return c:IsSetCard(0x6205)
end
function c1001205.target(e,c)
	return c:IsSetCard(0x6205)
end
function c1001205.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local ac=eg:GetFirst()
	return ep~=tp and ac:IsControler(tp) and ac:IsSetCard(0x6205) and Duel.GetLP(tp)<Duel.GetLP(1-tp) and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c1001205.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function c1001205.cfilter(c,tp)
	return c:IsSetCard(0x3205) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp
end
function c1001205.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1001205.cfilter,1,nil,tp)
end
function c1001205.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c1001205.spop1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c1001205.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() end
	Duel.Destroy(e:GetHandler(),REASON_COST)
end
function c1001205.filter(c)
	return c:IsSetCard(0x3205) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c1001205.target_a(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1001205.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c1001205.activate_a(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1001205.filter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end