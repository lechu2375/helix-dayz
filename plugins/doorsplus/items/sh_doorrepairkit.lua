
ITEM.name = "Zestaw naprawczy drzwi"
ITEM.description = "Zwyczajne, ciasne kajdanki."
ITEM.price = 500
ITEM.model = "models/props_c17/BriefCase001a.mdl"
local sounds ={"items/ammocrate_open.wav","doors/door_metal_thin_close2.wav","physics/metal/metal_box_strain1.wav"}
local randomAnims = {"barellpush","buttonfront","motionleft","motionright","pushplayer","spreadwall",}
local function RepairSounds(ply)
    if(!SERVER or !ply.repairingDoor) then return end
    timer.Simple(5, function()
        if(ply.repairingDoor) then
            ply:EmitSound(sounds[math.random(1, #sounds)])
            ply:ForceSequence(randomAnims[math.random(1, #randomAnims)],function()end, 1, false)
            RepairSounds(ply)
        end
    end)
end
ITEM.functions.Use = {
	OnRun = function(itemTable)
		local client = itemTable.player
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and string.find(target:GetClass(),"door")) then
			itemTable.bBeingUsed = true
            client.repairingDoor = true
			client:SetAction("Naprawianie drzwi", 30)

            client:EmitSound(sounds[math.random(1, #sounds)])
            RepairSounds(client)

			client:DoStaredAction(target, 
            function()
                target:SetHealth(500)
                client.repairingDoor = false
                client:EmitSound(sounds[math.random(1, #sounds)])
                client:Notify("Naprawiłeś drzwi!")
                itemTable:Remove()
            end
            , 30, 
            function()
                client.repairingDoor = false
				itemTable.bBeingUsed = false
                client:SetAction()
                client:Notify("Musisz przez cały czas patrzeć na drzwi!")
			end)

			

		else
			itemTable.player:NotifyLocalized("plyNotValid")
		end

		return false
	end,
	OnCanRun = function(itemTable)
		return !IsValid(itemTable.entity) or itemTable.bBeingUsed
	end
}

function ITEM:CanTransfer(inventory, newInventory)
	return !self.bBeingUsed
end
