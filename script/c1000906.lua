--叶族人的烹饪食谱
function c1000906.initial_effect(c)
	c:SetUniqueOnField(1,0,1000906)
	--发动
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--选择效果
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c1000906.condition)
	e2:SetTarget(c1000906.target)
	e2:SetOperation(c1000906.operation)
	c:RegisterEffect(e2)
	if not c1000906.global_check then
		c1000906.global_check=true
		c1000906[0]=0
		c1000906[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_RELEASE)
		ge1:SetOperation(c1000906.addcount)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c1000906.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c1000906.clear(e,tp,eg,ep,ev,re,r,rp)
	c1000906[0]=0
	c1000906[1]=0
end
function c1000906.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		local pl=tc:GetPreviousLocation()
		if pl==LOCATION_MZONE and tc:GetPreviousRaceOnField()==RACE_PLANT then
			local p=tc:GetReasonPlayer()
			c1000906[p]=c1000906[p]+1
		elseif pl==LOCATION_HAND and tc:GetOriginalRace()==RACE_PLANT then
			local p=tc:GetPreviousControler()
			c1000906[p]=c1000906[p]+1
		end
		tc=eg:GetNext()
	end
end
function c1000906.condition(e,tp,eg,ep,ev,re,r,rp)
	return c1000906[tp]>0 and Duel.GetTurnPlayer()==tp
end 
function c1000906.filter1(c)
	return c:IsSetCard(0xc201) and c:IsAbleToHand()
end
function c1000906.filter2(c,e,tp)
	return c:IsSetCard(0xc201) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()<=5
end
function c1000906.filter3(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c1000906.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c1000906.filter1,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c1000906.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	local b3=Duel.IsExistingMatchingCard(c1000906.filter3,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 or b3 end
	local ops={}
	local opval={}
	local off=1
	if b1 and c1000906[tp]>=1 then
		ops[off]=aux.Stringid(123709,2)
		opval[off-1]=1
		off=off+1
	end
	if b2 and c1000906[tp]>=2 then
		ops[off]=aux.Stringid(38492752,0)
		opval[off-1]=2
		off=off+1
	end
	if b3 and c1000906[tp]>=3 then
		ops[off]=aux.Stringid(54974237,0)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif sel==2 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	elseif sel==3 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	end
end
function c1000906.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c1000906.filter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif sel==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c1000906.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end 
	elseif sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c1000906.filter3,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end 