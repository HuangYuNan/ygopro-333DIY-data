--陆军三式潜航输送艇—Maruyu
if not pcall(function() require("expansions/script/c1001252") end) then require("script/c1001252") end
function c1001234.initial_effect(c)
	colle.sum(c,1)
	colle.th1(c)
	--Pos Change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_POSITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c1001234.target)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e2)
end
function c1001234.target(e,c)
	return c:IsCode(1001234) and c:IsFaceup()
end