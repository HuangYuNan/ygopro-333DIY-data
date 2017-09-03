--Z1级驱逐舰1号舰—马斯
if not pcall(function() require("expansions/script/c1001252") end) then require("script/c1001252") end
function c1001230.initial_effect(c)
	colle.sum(c,2)
	colle.atkup(c,110)
	colle.cnb(c)
	colle.th(c)
	colle.defwd(c)
end
