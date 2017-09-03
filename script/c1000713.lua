--四季映姫·亚玛萨那度
function c1000713.initial_effect(c)
	c:SetUniqueOnField(1,1,1000713)
	--xyz summon
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--4~1xyx
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c1000713.xyzcon)
	e1:SetOperation(c1000713.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--pendulum set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1000713,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c1000713.pctg)
	e2:SetOperation(c1000713.pcop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1000713,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCost(c1000713.spcost)
	e3:SetTarget(c1000713.sptg)
	e3:SetOperation(c1000713.spop)
	c:RegisterEffect(e3)
	--cannot target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c1000713.cost)
	e5:SetTarget(c1000713.target)
	e5:SetOperation(c1000713.operation)
	c:RegisterEffect(e5)
	--pendulum
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(c1000713.pencon)
	e6:SetTarget(c1000713.pentg)
	e6:SetOperation(c1000713.penop)
	c:RegisterEffect(e6) 
end
c1000713.pendulum_level=4
function c1000713.pcfilter(c)
	return c:IsSetCard(0x5204) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c1000713.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local seq=e:GetHandler():GetSequence()
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,13-seq)
		and Duel.IsExistingMatchingCard(c1000713.pcfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c1000713.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local seq=e:GetHandler():GetSequence()
	if not Duel.CheckLocation(tp,LOCATION_SZONE,13-seq) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c1000713.pcfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c1000713.cfilter(c)
	return c:IsSetCard(0x5204) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c1000713.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1000713.cfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c1000713.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c1000713.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c1000713.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c1000713.mfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and c:IsSetCard(0x5204) and not c:IsType(TYPE_XYZ) and not c:IsType(TYPE_TOKEN)
end
function c1000713.xyzfilter1(c,g)
	return g:IsExists(c1000713.xyzfilter2,1,c,c:GetLevel())
end
function c1000713.xyzfilter2(c,ll)
	return c:GetLevel()==ll
end
function c1000713.xyzcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c1000713.mfilter,tp,LOCATION_MZONE,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and mg:IsExists(c1000713.xyzfilter1,1,nil,mg)
end
function c1000713.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	local mg=Duel.GetMatchingGroup(c1000713.mfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=mg:FilterSelect(tp,c1000713.xyzfilter1,1,1,nil,mg)
	local tc1=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g2=mg:FilterSelect(tp,c1000713.xyzfilter2,1,1,tc1,tc1:GetLevel())
	local tc2=g2:GetFirst()
	g1:Merge(g2)
	local sg1=tc1:GetOverlayGroup()
	local sg2=tc2:GetOverlayGroup()
	sg1:Merge(sg2)
	Duel.SendtoGrave(sg1,REASON_RULE)
	c:SetMaterial(g1)
	Duel.Overlay(c,g1)
end
function c1000713.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c1000713.filter(c)
	return c:IsSetCard(0x5204) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c1000713.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1000713.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1000713.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1000713.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c1000713.pencon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c1000713.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lsc=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rsc=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g=Group.FromCards(lsc,rsc):Filter(Card.IsDestructable,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c1000713.penop(e,tp,eg,ep,ev,re,r,rp)
	local lsc=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rsc=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g=Group.FromCards(lsc,rsc)
	if Duel.Destroy(g,REASON_EFFECT)~=0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end