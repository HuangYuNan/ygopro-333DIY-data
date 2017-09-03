--川内级轻巡洋舰1号舰—川内
if not pcall(function() require("expansions/script/c1001252") end) then require("script/c1001252") end
function c1001237.initial_effect(c)
	colle.sum(c,2)
	colle.atkup(c,100)
	colle.thc(c)
	colle.defwd1(c)
end