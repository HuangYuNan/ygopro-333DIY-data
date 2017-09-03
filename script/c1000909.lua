--叶族人猎手
function c1000909.initial_effect(c)
	--特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c1000909.condition)
	e1:SetCost(c1000909.cost)
	e1:SetTarget(c1000909.sptg)
	e1:SetOperation(c1000909.spop)
	c:RegisterEffect(e1)
	--对方发动的魔法卡无效
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_BE_MATERIAL)
	e6:SetCondition(c1000909.efcon)
	e6:SetOperation(c1000909.efop)
	c:RegisterEffect(e6)
	if not c1000909.global_check then
		c1000909.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c1000909.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c1000909.checkop(e,tp,eg,ep,ev,re,r,rp)
	local p1=nil
	local p2=nil
	local tc=eg:GetFirst()
	while tc do
		if not tc:IsSetCard(0xc201) then
			if tc:GetSummonPlayer()==0 then p1=true else p2=true end
		end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,1000909,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,1000909,RESET_PHASE+PHASE_END,0,1) end
end
function c1000909.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c1000909.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14152862,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c1000909.discon)
	e1:SetCost(c1000909.discost)
	e1:SetTarget(c1000909.distg)
	e1:SetOperation(c1000909.disop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_TYPE)
		e2:SetValue(TYPE_MONSTER+TYPE_EFFECT+TYPE_XYZ)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2)
	end
end
function c1000909.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return rp~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c1000909.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c1000909.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c1000909.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c1000909.condition(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0xc201)
end
function c1000909.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,1000909)==0 end
	Duel.RegisterFlagEffect(tp,1000909,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c1000909.spfilter(c,e,tp)
	return c:GetLevel()<=5 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_FUSION)
end
function c1000909.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1000909.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c1000909.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1000909.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0xfe0000)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0xfe0000)
	tc:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetValue(0)
	e3:SetReset(RESET_EVENT+0xfe0000)
	tc:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SET_DEFENSE)
	e5:SetValue(0)
	e5:SetReset(RESET_EVENT+0xfe0000)
	tc:RegisterEffect(e5)
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetTargetRange(1,0)
	e4:SetTarget(c1000909.splimit)
	Duel.RegisterEffect(e4,tp)
end
function c1000909.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xc201)
end
