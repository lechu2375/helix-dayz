FACTION.name = "Cywil"
FACTION.description = "Obcokrajowcy oraz obywatele Czarnorusi, którzy przetrwali."
FACTION.isDefault = true
FACTION.color = Color(0, 140, 0)

FACTION.models = {
	"models/drem/cch/male_01.mdl",
	"models/drem/cch/male_02.mdl",
	"models/drem/cch/male_03.mdl",
	"models/drem/cch/male_04.mdl",
	"models/drem/cch/male_05.mdl",
	"models/drem/cch/male_06.mdl",
	"models/drem/cch/male_07.mdl",
	"models/drem/cch/male_08.mdl",
	"models/drem/cch/male_09.mdl"
}


function FACTION:OnSpawn(client)
	
	client:SetSkin(math.random(0, client:SkinCount()))
	local bodyGroups = client:GetBodyGroups()
	for k,v in pairs(bodyGroups) do
		client:SetBodygroup(v.id, math.random(0, v.num))
	end
	
end
FACTION_SURVIVOR = FACTION.index


