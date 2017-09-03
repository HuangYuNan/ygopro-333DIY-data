--古鹰级重巡洋舰1号舰—古鹰
if not pcall(function() require("expansions/script/c1001252") end) then require("script/c1001252") end
function c1001240.initial_effect(c)
	colle.sum(c,3)
	colle.atkup(c,100)
	colle.thc(c)
	--attack up
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1001240,0))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCountLimit(1,1240)
	e4:SetCondition(c1001240.condition)
	e4:SetOperation(c1001240.operation)
	c:RegisterEffect(e4)
end
function c1001240.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsRelateToBattle()
end
function c1001240.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
		c:RegisterEffect(e1)
	end
end