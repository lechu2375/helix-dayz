PLUGIN.name = "Entry Questions"
PLUGIN.author = "Lechu2375"
ix.util.Include("cl_derma.lua")
ix.util.Include("sv_core.lua")


ix.command.Add("ForceRPTest", {
	description = "Zmuś kogoś do przejścia testu z wiedzy RP",
	adminOnly = true,
	arguments = ix.type.character,
	OnRun = function(self, client, target)
        target = target:GetPlayer()
        RequestEntryQuestionAnswer(target)
        SavePlayerQuestionAnswer(target,false)
    end
})