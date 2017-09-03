--西北风级驱逐舰3号舰—西南风
if not pcall(function() require("expansions/script/c1001252") end) then require("script/c1001252") end
function c1001232.initial_effect(c)
	colle.sum(c,3)
	colle.atkup(c,200)
	colle.cnb(c)
	colle.th(c)
	colle.defwd(c)
end