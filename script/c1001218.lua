--我不再是一个人了
function c1001218.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCountLimit(1,1001218)
	e1:SetCost(c1001218.cost)
	e1:SetTarget(c1001218.target)
	e1:SetOperation(c1001218.activate)
	c:RegisterEffect(e1)
	--Hand dis or lp cha
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROY)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c1001218.retcon)
	e2:SetTarget(c1001218.rettg)
	e2:SetOperation(c1001218.retop)
	c:RegisterEffect(e2)
end
function c1001218.filter(c)
	return c:IsFaceup() and (c:IsSetCard(0x3205) or c:IsSetCard(0x5205)) and c:IsAbleToDeckOrExtraAsCost()
end
function c1001218.costfilter(c,rg,dg)
	local a=0
	if dg:IsContains(c) then a=1 end
	if c:GetEquipCount()==0 then return rg:IsExists(c1001218.costfilter2,1,c,a,dg) end
	local eg=c:GetEquipGroup()
	local tc=eg:GetFirst()
	while tc do
		if dg:IsContains(tc) then a=a+1 end
		tc=eg:GetNext()
	end
	return rg:IsExists(c1001218.costfilter2,1,c,a,dg)
end
function c1001218.costfilter2(c,a,dg)
	if dg:IsContains(c) then a=a+1 end
	if c:GetEquipCount()==0 then return dg:GetCount()-a>=1 end
	local eg=c:GetEquipGroup()
	local tc=eg:GetFirst()
	while tc do
		if dg:IsContains(tc) then a=a+1 end
		tc=eg:GetNext()
	end
	return dg:GetCount()-a>=1
end
function c1001218.tgfilter(c,e)
	return c:IsDestructable() and c:IsCanBeEffectTarget(e)
end
function c1001218.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c1001218.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			local rg=Duel.GetMatchingGroup(c1001218.filter,tp,LOCATION_MZONE,0,nil)
			local dg=Duel.GetMatchingGroup(c1001218.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),e)
			return rg:IsExists(c1001218.costfilter,1,nil,rg,dg)
		else
			return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local rg=Duel.GetMatchingGroup(c1001218.filter,tp,LOCATION_MZONE,0,nil)
		local dg=Duel.GetMatchingGroup(c1001218.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),e)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg1=rg:FilterSelect(tp,c1001218.costfilter,1,1,nil,rg,dg)
		local sc=sg1:GetFirst()
		local a=0
		if dg:IsContains(sc) then a=1 end
		if sc:GetEquipCount()>0 then
			local eqg=sc:GetEquipGroup()
			local tc=eqg:GetFirst()
			while tc do
				if dg:IsContains(tc) then a=a+1 end
				tc=eqg:GetNext()
			end
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg2=rg:FilterSelect(tp,c1001218.costfilter2,1,1,sc,a,dg)
		sg1:Merge(sg2)
		Duel.SendtoExtraP(sg1,nil,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,3,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end 
function c1001218.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c1001218.filter_a(c)
	return c:IsFaceup() and (c:IsSetCard(0x3205) or c:IsSetCard(0x5205))
end
function c1001218.retcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and Duel.IsExistingMatchingCard(c1001218.filter_a,0,LOCATION_GRAVE,0,1,nil) and e:GetHandler():GetPreviousControler()==tp
end
function c1001218.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_HAND)
end
function c1001218.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(1-tp,1)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	else
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)/2)
	end
end