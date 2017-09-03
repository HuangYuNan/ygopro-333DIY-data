--六十年目の東方裁判·四季映姬
function c1000712.initial_effect(c)
	c:SetUniqueOnField(1,1,1000712)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c1000712.sprcon)
	e2:SetOperation(c1000712.sprop)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c1000712.eqtg)
	e3:SetOperation(c1000712.eqop)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e4)
end
function c1000712.sprfilter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x5204) and c:IsType(TYPE_TUNER) and c:IsAbleToRemoveAsCost()
end
function c1000712.sprfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x5204) and c:IsType(TYPE_XYZ) and c:IsAbleToRemoveAsCost()
end
function c1000712.sprfilter3(c)
	return c:IsFaceup() and c:IsSetCard(0x5204) and c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemoveAsCost()
end
function c1000712.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
		and Duel.IsExistingMatchingCard(c1000712.sprfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.IsExistingMatchingCard(c1000712.sprfilter2,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.IsExistingMatchingCard(c1000712.sprfilter3,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c1000712.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c1000712.sprfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c1000712.sprfilter2,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g3=Duel.SelectMatchingCard(tp,c1000712.sprfilter3,tp,LOCATION_MZONE,0,1,1,nil,tp)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c1000712.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToChangeControler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c1000712.eqlimit(e,c)
	return e:GetOwner()==c
end
function c1000712.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
	local atk=tc:GetTextAttack()
	if tc:IsFacedown() then atk=0 end
	if atk<0 then atk=0 end
	if not Duel.Equip(tp,tc,c,false) then return end
	--Add Equip limit
	tc:RegisterFlagEffect(1000712,RESET_EVENT+0x1fe0000,0,0)
	e:SetLabelObject(tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c1000712.eqlimit)
	tc:RegisterEffect(e1)
	if atk>0 then
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e2:SetValue(atk)
	tc:RegisterEffect(e2)
	end
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetReset(RESET_EVENT+0x1fe0000)
	e4:SetValue(c1000712.repval)
	tc:RegisterEffect(e4)
	else Duel.SendtoGrave(tc,REASON_EFFECT) end
end
function c1000712.repval(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end