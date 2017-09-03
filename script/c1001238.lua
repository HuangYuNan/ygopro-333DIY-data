--川内级轻巡洋舰2号舰—神通
if not pcall(function() require("expansions/script/c1001252") end) then require("script/c1001252") end
function c1001238.initial_effect(c)
	colle.sum(c,2)
	colle.atkup(c,100)
	colle.thc(c)
	colle.defwd1(c)
end
