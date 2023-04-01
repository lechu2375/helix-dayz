AddCSLuaFile("autorun/nb_doorinteraction_check.lua")

local function GetDoor(ent)

	local doors = {}
	doors[1] = "models/props_c17/door01_left.mdl"
	doors[2] = "models/props_c17/door02_double.mdl"
	doors[3] = "models/props_c17/door03_left.mdl"
	doors[4] = "models/props_doors/door01_dynamic.mdl"
	doors[5] = "models/props_doors/door03_slotted_left.mdl"
	doors[6] = "models/props_interiors/elevatorshaft_door01a.mdl"
	doors[7] = "models/props_interiors/elevatorshaft_door01b.mdl"
	doors[8] = "models/props_silo/silo_door01_static.mdl"
	doors[9] = "models/props_wasteland/prison_celldoor001b.mdl"
	doors[10] = "models/props_wasteland/prison_celldoor001a.mdl"

	doors[11] = "models/props_radiostation/radio_metaldoor01.mdl"
	doors[12] = "models/props_radiostation/radio_metaldoor01a.mdl"
	doors[13] = "models/props_radiostation/radio_metaldoor01b.mdl"
	doors[14] = "models/props_radiostation/radio_metaldoor01c.mdl"


	for k,v in pairs( doors ) do
		if !IsValid( ent ) then break end
		if ent:GetModel() == v and string.find(ent:GetClass(), "door") then
			return "door"
		end
	end

end

if SERVER then
	hook.Add( "PlayerInitialSpawn", "nb_doorinteraction_check", function()

		for k,v in pairs( ents.GetAll() ) do
			if IsValid( v ) then
				if GetDoor( v ) then
					GetConVar( "nb_doorinteraction" ):SetInt(1)
				else
					GetConVar( "nb_doorinteraction" ):SetInt(0)
				end
			end
		end
		
		if GetConVar( "nb_doorinteraction" ):GetInt() == 1 then
			print("NB 3.0: Found doors on map, Door interaction (TRUE)")
		else
			print("NB 3.0: Found no doors on map, Door interaction (FALSE)")
		end
		
	end)
end