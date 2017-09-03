--星境边界的叶族人
function c1000908.initial_effect(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23401839,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCost(c1000908.cost)
	e1:SetTarget(c1000908.tg)
	e1:SetOperation(c1000908.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--卡片破坏
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40619741,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCountLimit(1)
	e3:SetCondition(c1000908.decon)
	e3:SetTarget(c1000908.destg)
	e3:SetOperation(c1000908.desop)
	c:RegisterEffect(e3)
end
function c1000908.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,1000908)==0 end
	Duel.RegisterFlagEffect(tp,1000908,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c1000908.cfilter(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c1000908.decon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1000908.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c1000908.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c1000908.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c1000908.filter(c)
	return c:IsSetCard(0xc201) and c:IsAbleToHand() and c:IsType(TYPE_SPELL)
end
function c1000908.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1000908.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c1000908.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1000908.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
