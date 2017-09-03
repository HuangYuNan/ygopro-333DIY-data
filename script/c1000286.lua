--来吧，直到倒地死去的那一刻
function c1000286.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(c1000286.condition)
	e1:SetCost(c1000286.cost)
	e1:SetTarget(c1000286.target)
	e1:SetOperation(c1000286.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
end
function c1000286.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c1000286.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5201)and c:IsAbleToGraveAsCost()
end
function c1000286.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1000286.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c1000286.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local atk=g:GetFirst():GetTextAttack()
	if atk<0 then atk=0 end
	e:SetLabel(atk)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,dam)
	Duel.SendtoGrave(g,REASON_COST)
end
function c1000286.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(Card.IsControler,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c1000286.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsControler,nil,1-tp)
	Duel.NegateSummon(g)
	Duel.Destroy(g,REASON_EFFECT)
	Duel.Damage(1-tp,e:GetLabel(),REASON_EFFECT)
	Duel.Damage(tp,e:GetLabel(),REASON_EFFECT)
end

