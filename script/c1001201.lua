--零食的魔女 夏洛特
function c1001201.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3205),aux.NonTuner(Card.IsType,TYPE_PENDULUM),1)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c1001201.splimit)
	e2:SetCondition(function(e) return not e:GetHandler():IsHasEffect(EFFECT_FORBIDDEN) end)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c1001201.target)
	e3:SetOperation(c1001201.desop)
	c:RegisterEffect(e3)
	--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c1001201.pencon)
	e4:SetTarget(c1001201.pentg)
	e4:SetOperation(c1001201.penop)
	c:RegisterEffect(e4)
	--reflect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CHANGE_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(1,1)
	e5:SetValue(c1001201.val)
	c:RegisterEffect(e5)
	--indes
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EFFECT_DESTROY_REPLACE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTarget(c1001201.reptg)
	e6:SetValue(c1001201.repval)
	c:RegisterEffect(e6)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e6:SetLabelObject(g)
   --control
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_CONTROL)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetCountLimit(1,290001)
	e7:SetCondition(c1001201.ctcon)
	e7:SetTarget(c1001201.cttg)
	e7:SetOperation(c1001201.ctop)
	c:RegisterEffect(e7)
end
function c1001201.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0x6205) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c1001201.filter_a(c)
	return c:IsFaceup() and (c:GetSequence()==6 or c:GetSequence()==7) and c:IsDestructable()
end
function c1001201.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c1001201.filter_a(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1001201.filter_a,tp,LOCATION_SZONE,LOCATION_SZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c1001201.filter_a,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c1001201.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c1001201.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local code=tc:GetOriginalCode()
		if tc:GetOwner()==tp then
		  if Duel.IsExistingMatchingCard(c1001201.thfilter,tp,LOCATION_DECK,0,1,nil,code) then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		  local g=Duel.SelectMatchingCard(tp,c1001201.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tc:GetOriginalCode())
			if g:GetCount()>0 then
					  Duel.SendtoHand(g,nil,REASON_EFFECT)
					  Duel.ConfirmCards(1-tp,g)
				 end
		  end
		else
			local cg=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_DECK+LOCATION_EXTRA+LOCATION_ONFIELD+LOCATION_HAND,nil,tc:GetOriginalCode())
			Duel.Destroy(cg,REASON_EFFECT)
		end
	end
end
function c1001201.val(e,re,val,r,rp,rc)
	return val/2
end
function c1001201.repfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
		and c:IsType(TYPE_MONSTER) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetFlagEffect(1001201)==0
end
function c1001201.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c1001201.repfilter,1,nil,tp) end
	local g=eg:Filter(c1001201.repfilter,nil,tp)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(1001201,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(1001201,0))
		tc=g:GetNext()
	end
	e:GetLabelObject():Clear()
	e:GetLabelObject():Merge(g)
	return true
end
function c1001201.repval(e,c)
	local g=e:GetLabelObject()
	return g:IsContains(c)
end
function c1001201.pencon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c1001201.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lsc=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rsc=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g=Group.FromCards(lsc,rsc):Filter(Card.IsDestructable,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c1001201.penop(e,tp,eg,ep,ev,re,r,rp)
	local lsc=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rsc=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g=Group.FromCards(lsc,rsc)
	if Duel.Destroy(g,REASON_EFFECT)~=0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c1001201.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO and e:GetHandler():GetMaterial():IsExists(Card.IsSetCard,1,nil,0x3205)
end
function c1001201.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c1001201.vfilter(c)
	return c:IsPosition(POS_FACEUP) and c:GetAttack()~=c:GetBaseAttack() or c:GetDefense()~=c:GetBaseDefense()
end
function c1001201.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=tg:GetFirst()
	while tc do
		local atk=tc:GetAttack()
		local def=tc:GetDefense()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(atk/2)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(def/2)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		tc=tg:GetNext()
	end
	--atkup
	local ct=Duel.GetMatchingGroupCount(c1001201.vfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetValue(ct*400)
	c:RegisterEffect(e1)
end