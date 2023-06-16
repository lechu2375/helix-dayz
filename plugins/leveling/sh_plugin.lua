ix.leveling = {}

PLUGIN.name = "Leveling 2.0"
PLUGIN.author = "NS:Vex,IX:Lechu"
PLUGIN.desc = "A new and improved version of leveling, how dank."

ix.util.Include("sv_plugin.lua")
ix.util.Include("sv_rewardshook.lua")
ix.util.Include("cl_plugin.lua")



ix.leveling.spike = 50

function ix.leveling.requiredXP(level)
	local XPR = 0

	if level > ix.leveling.spike then
		XPR = ix.leveling.requiredXP(ix.leveling.spike) + math.floor(1.22 ^ level)
	elseif level > 0 then
		XPR = ( 92 + (level * 2)) * (math.max(level - 1, 0) ) + 200
	end

	return XPR
end
