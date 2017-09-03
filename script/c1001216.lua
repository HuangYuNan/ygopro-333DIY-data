--已经没有什么好怕的了
function c1001216.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(1001216,1))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Activate(spsummon)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1001216,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c1001216.spcon)
	e1:SetCost(c1001216.spcost)
	e1:SetTarget(c1001216.sptg1)
	e1:SetOperation(c1001216.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1001216,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,1001216)
	e2:SetCondition(c1001216.spcon)
	e2:SetCost(c1001216.spcost)
	e2:SetTarget(c1001216.sptg2)
	e2:SetOperation(c1001216.spop)
	c:RegisterEffect(e2)
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1001216,1))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c1001216.sumcon)
	e3:SetTarget(c1001216.pttg)
	e3:SetOperation(c1001216.ptop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCondition(c1001216.spcon1)
	e4:SetTarget(c1001216.sptg3)
	e4:SetOperation(c1001216.spop3)
	c:RegisterEffect(e4)
end
function c1001216.cfilter(c,tp)
	return (c:IsSetCard(0x3205) or c:IsSetCard(0x5205)) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c1001216.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1001216.cfilter,1,nil,tp)
end
function c1001216.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(1001216)==0 end
	e:GetHandler():RegisterFlagEffect(1001216,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c1001216.filter(c,e,tp)
	return c:IsSetCard(0x3205) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1001216.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c1001216.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1001216.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c1001216.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c1001216.filter(chkc) end
	if chk==0 then return e:GetHandler():IsRelateToEffect(e)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1001216.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c1001216.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1001216.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	e:GetHandler():RegisterFlagEffect(1001216,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
end
function c1001216.filter_a(c)
	return c:IsDestructable()
end
function c1001216.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(1001216)~=0
end
function c1001216.pttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c1001216.filter_a(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1001216.filter_a,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c1001216.filter_a,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	if g:GetFirst():IsFaceup() then
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack())
	end
end
function c1001216.ptop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local atk=tc:IsFaceup() and tc:GetAttack() or 0
		if Duel.Destroy(tc,REASON_EFFECT)>0 and atk~=0 then
			Duel.Recover(tp,atk,REASON_EFFECT)
		end
	end
end
function c1001216.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and e:GetHandler():GetPreviousControler()==tp and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c1001216.ptfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c1001216.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c1001216.ptfilter,tp,0,LOCATION_GRAVE,1,nil) and Duel.IsPlayerCanSpecialSummonMonster(tp,1001204,0,0x4011,0,0,7,RACE_AQUA,ATTRIBUTE_WATER) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c1001216.ptfilter,tp,0,LOCATION_GRAVE,1,1,nil)
	e:SetLabel(g:GetFirst():GetAttack())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c1001216.spop3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,1001204,0,0x4011,0,0,7,RACE_AQUA,ATTRIBUTE_WATER) then
		local token=Duel.CreateToken(tp,1001204)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(e:GetLabel())
			token:RegisterEffect(e1)
			Duel.SpecialSummonComplete()
		end
end