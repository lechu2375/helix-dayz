local MODULE = GAS.Logging:MODULE()

MODULE.Category = "TTT"
MODULE.Name     = "Equipment"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("TTTOrderedEquipment", "tttequipment", function(ply, equipment, is_item)
		if (type(equipment) == "string") then
			MODULE:LogPhrase("ttt_bought", GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(equipment))
		else
			local name
			for _,v in pairs(EquipmentItems) do
				for _,_v in pairs(v) do
					if (_v.id == equipment) then
						name = _v.name
						break
					end
				end
			end
			if (name) then
				MODULE:LogPhrase("ttt_bought", GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(name))
			elseif (type(equipment) == "Entity") then
				MODULE:LogPhrase("ttt_bought", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(equipment))
			end
		end
	end)
end)

GAS.Logging:AddModule(MODULE)
