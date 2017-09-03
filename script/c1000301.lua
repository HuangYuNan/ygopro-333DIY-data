--封魔录·玄龟
function c1000301.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1000301,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c1000301.eqtg)
	e1:SetOperation(c1000301.eqop)
	c:RegisterEffect(e1)
	--unequip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1000301,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c1000301.uncon)
	e2:SetTarget(c1000301.sptg)
	e2:SetOperation(c1000301.spop)
	c:RegisterEffect(e2)
	--Atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(300)
	e3:SetCondition(c1000301.uncon)
	c:RegisterEffect(e3)
	--Def up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	e4:SetValue(300)
	e4:SetCondition(c1000301.uncon)
	c:RegisterEffect(e4)
	--destroy sub
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e5:SetCondition(c1000301.uncon)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--draw
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(1000301,2))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BATTLE_DESTROYING)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c1000301.drcon)
	e6:SetTarget(c1000301.drtg)
	e6:SetOperation(c1000301.drop)
	c:RegisterEffect(e6)
	--eqlimit
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_EQUIP_LIMIT)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetValue(c1000301.eqlimit)
	c:RegisterEffect(e7)
end
function c1000301.uncon(e)
	return e:GetHandler():IsStatus(STATUS_UNION)
end
function c1000301.eqlimit(e,c)
	return c:IsSetCard(0x9201)
end
function c1000301.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x9201) and c:GetUnionCount()==0
end
function c1000301.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c1000301.filter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(1000301)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c1000301.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c1000301.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	e:GetHandler():RegisterFlagEffect(1000301,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c1000301.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) or not c1000301.filter(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,false) then return end
	c:SetStatus(STATUS_UNION,true)
end
function c1000301.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(1000301)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	e:GetHandler():RegisterFlagEffect(1000301,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c1000301.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_ATTACK)
	end
end
function c1000301.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==1 and eg:GetFirst()==e:GetHandler():GetEquipTarget()
end
function c1000301.sefilter(c,e,tp)
	return c:IsSetCard(0x9201) and c:IsAbleToHand()
end
function c1000301.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local eqc=e:GetHandler():GetEquipTarget()
	if chk==0 then return Duel.IsExistingMatchingCard(c1000301.sefilter,tp,LOCATION_DECK,0,1,nil,eqc:GetRace(),eqc:GetAttribute()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1000301.drop(e,tp,eg,ep,ev,re,r,rp)
	local eqc=e:GetHandler():GetEquipTarget()
	if not eqc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1000301.sefilter,tp,LOCATION_DECK,0,1,1,nil,eqc:GetRace(),eqc:GetAttribute())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
