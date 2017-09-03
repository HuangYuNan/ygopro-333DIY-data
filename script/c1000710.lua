--花映冢·四季映姫
function c1000710.initial_effect(c)
	c:SetUniqueOnField(1,1,1000710)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5204),aux.NonTuner(Card.IsSetCard,0x5204),1)
	c:EnableReviveLimit()
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5204))
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c1000710.aclimit)
	e2:SetCondition(c1000710.actcon)
	c:RegisterEffect(e2)
	--activate limit
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1000710,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_DRAW_PHASE)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c1000710.operation)
	c:RegisterEffect(e3) 
end
function c1000710.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c1000710.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c1000710.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c1000710.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c1000710.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end