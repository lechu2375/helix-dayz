
local PLUGIN = PLUGIN

PLUGIN.name = "Doors plus"
PLUGIN.author = "Lechu2375"
PLUGIN.description = "Dodatkowe funkcje do systemu drzwi"

ix.util.Include("sv_plugin.lua")


ix.command.Add("DoorFix", {
	description = "Napraw drzwi naprzeciwko Ciebie",
	OnRun = function(self, client, arguments)
		
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local trace = util.TraceLine(data)
		local entity = trace.Entity

		-- Check if the entity is a valid door.
		if (IsValid(entity) and entity:IsDoor() and !entity:GetNetVar("disabled")) then
			-- Check if the player owners the door.
            entity:SetHealth(entity:GetMaxHealth())

		else
			-- Tell the player the door isn't valid.
			return "@dNotValid"
		end
	end
})



if(CLIENT) then

local status = {"Zniszczone","Zużyte","Obtarte", "Lekko Obtarte", "Nowe"}
local colorGood = Color(39, 174, 96)
local colorMedium = Color(243, 156, 18)
local colorBad = Color(192, 57, 43)

    function PLUGIN:GetDoorInfo(door) 

        local percentage = door:Health()/door:GetMaxHealth()
        if(!percentage) then return end
        if(percentage<0) then percentage = 0.1 end 
        local toReturn = {}
        toReturn.name = "Drzwi"
        toReturn.description = "Wyglądają na "..status[math.max(1,math.Round(#status*percentage))] 

        if(percentage>=0.7) then
            toReturn.color = colorGood
        elseif(percentage<0.7 and percentage>=0.4) then
            toReturn.color = colorMedium
        else
            toReturn.color = colorBad
        end

        return toReturn
    end




end