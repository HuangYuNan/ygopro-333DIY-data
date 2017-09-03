--叶族人酋长
function c1000903.initial_effect(c)
	--超量召唤
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xc201),7,2,c1000903.ovfilter,aux.Stringid(100074,2),2,c1000903.xyzop)
	c:EnableReviveLimit()
	--效果无效
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c1000903.tdtg1)
	e1:SetOperation(c1000903.tdop1)
	c:RegisterEffect(e1)
	--解放
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9927551,3))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c1000903.atkcost)
	e2:SetTarget(c1000903.atktg)
	e2:SetOperation(c1000903.atkop)
	c:RegisterEffect(e2)
end
function c1000903.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc201) and c:GetCode()~=1000903 
	and (c:IsType(TYPE_XYZ) or c:IsType(TYPE_SYNCHRO))
end
function c1000903.xyzop(e,tp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(1000903,RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END,0,1)
end
function c1000903.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetOverlayCount(tp,1,1)>1 
	and Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_ONFIELD+LOCATION_HAND,LOCATION_ONFIELD,1,nil) end
	local ct=Duel.GetOverlayCount(tp,1,1)
	e:SetLabel(ct)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,1,e:GetLabel(),nil)
	Duel.Release(g,REASON_COST)
	e:SetLabel(g:GetCount())
end 
function c1000903.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(1000903)==0
	and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function c1000903.atkop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetOverlayCount(tp,1,1)
	if ct<e:GetLabel() then e:SetLabel(ct) end
	Duel.RemoveOverlayCard(tp,1,1,e:GetLabel(),e:GetLabel(),REASON_EFFECT)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c1000903.tdtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(1000903)==0
	and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c1000903.tdop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end