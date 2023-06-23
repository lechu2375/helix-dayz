local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Sandbox"
MODULE.Name     = "Toolgun"
MODULE.Colour   = Color(0,150,255)

MODULE:FeedbackHook("CanTool", "Toolgun:CanTool", function(theirReturn,ply,tr,tool)
	if theirReturn and theirReturn[1] == false then return end
	if (tr.Entity and IsValid(tr.Entity) and not tr.Entity:IsWorld()) then
		local creator = GAS.Logging:GetEntityCreator(tr.Entity)
		if (IsValid(creator)) then
			if (creator == ply) then
				MODULE:LogPhrase("toolgun_used_their_ent", GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(tool), GAS.Logging:FormatEntity(tr.Entity))
			else
				MODULE:LogPhrase("toolgun_used_other_ent", GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(tool), GAS.Logging:FormatEntity(tr.Entity), GAS.Logging:FormatPlayer(creator))
			end
			return
		end
		MODULE:LogPhrase("toolgun_used_world_ent", GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(tool), GAS.Logging:FormatEntity(tr.Entity))
	end
end)

GAS.Logging:AddModule(MODULE)