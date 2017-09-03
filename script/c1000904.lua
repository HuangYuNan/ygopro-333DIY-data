--叶族人大祭司
function c1000904.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2)
	c:EnableReviveLimit()
	--解放
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RELEASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c1000904.damcost)
	e1:SetTarget(c1000904.damtg)
	e1:SetOperation(c1000904.damop)
	c:RegisterEffect(e1)
	--代替破坏
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c1000904.reptg)
	e2:SetValue(c1000904.repval)
	c:RegisterEffect(e2)
end
function c1000904.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0xc201)
	and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c1000904.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c1000904.repfilter,1,nil,tp) end
	if e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(83994433,0)) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true 
	else return false end
end
function c1000904.repval(e,c)
	return c1000904.repfilter(c,e:GetHandlerPlayer())
end
function c1000904.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
	e:SetLabelObject(g:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,g:GetCount(),0,0)
end
function c1000904.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Release(tc,REASON_EFFECT)
end
function c1000904.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end