--大淀级轻巡洋舰1号舰—大淀
if not pcall(function() require("expansions/script/c1001252") end) then require("script/c1001252") end
function c1001236.initial_effect(c)
	colle.sum(c,3)
	colle.atkup(c,100)
	colle.thc(c)
	--sp
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,1236)
	e1:SetCost(c1001236.spcost)
	e1:SetCondition(c1001236.chcon)
	e1:SetTarget(c1001236.sptg)
	e1:SetOperation(c1001236.spop)
	c:RegisterEffect(e1)
end
function c1001236.chfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x203)
end
function c1001236.chcon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c1001236.chfilter,c:GetControler(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c1001236.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x203) and c:IsAbleToHand()
end
function c1001236.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c1001236.desfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c1001236.cfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	if g:GetCount()~=1 then return end
	Duel.SendtoHand(g,nil,2,REASON_COST)
end
function c1001236.spfilter(c,e,tp)
	return c:IsSetCard(0x203) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1001236.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1001236.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c1001236.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1001236.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end