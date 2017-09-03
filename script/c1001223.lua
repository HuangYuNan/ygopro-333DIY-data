--岛风级驱逐舰1号舰—岛风
if not pcall(function() require("expansions/script/c1001252") end) then require("script/c1001252") end
function c1001223.initial_effect(c)
	colle.sum(c,3)
	colle.atkup(c,200)
	colle.cnb(c)
	colle.th(c)
	--cannot be battle target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetCondition(c1001223.condition)
	e3:SetValue(c1001223.val)
	c:RegisterEffect(e3)
	--chain attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(72989439,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLED)
	e4:SetCondition(c1001223.condition)
	e4:SetCondition(c1001223.atcon)
	e4:SetOperation(c1001223.atop)
	c:RegisterEffect(e4)
end
function c1001223.fivefilter(c)
	return c:IsFaceup() and c:IsSetCard(0x203)
end
function c1001223.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1001223.fivefilter,tp,LOCATION_MZONE,0,5,nil)
end
function c1001223.val(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c1001223.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and c:GetFlagEffect(1001223)==0
		and c:IsChainAttackable() and c:IsStatus(STATUS_OPPO_BATTLE) 
end
function c1001223.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end