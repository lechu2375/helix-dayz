DIALOGUE.name = "Template NPC"

-- Template NPC showcasing all currently implemented features
-- Copy&Paste from this file to build new NPCs

-- Progression can be done by calling this:
-- 				ix.progression.AddProgessionValue(progressionIdentifier, amountToIncrement, client:Name())
-- and
--  			ix.progression.GetProgressionValue(progressionIdentifier)
-- to react to progression levels

DIALOGUE.addTopic("GREETING", {
	response = "Welcome!",
	options = {
		"InterestTopic",
		"TradeTopic", 
		"RepairItems",
		"AboutWorkTopic",
		"GetTask",
		"GOODBYE"
	},
	preCallback = function(self, client, target)
		-- Only needed if NPC offers tasks
		-- 4th argument is the categories to grab tasks from
		-- 5th argument is the amount of tasks to grab
		netstream.Start("job_updatenpcjobs", target, target:GetDisplayName(), {"mutantkillgroupeasy"}, 4)
	end
})

DIALOGUE.addTopic("BackTopic", {
	statement = "Pogadajmy o czymś innym.",
	response = "Co chciałbyś wiedzieć??",
	options = {
		"InterestTopic",
		"TradeTopic", 
		"RepairItems",
		"AboutWorkTopic",
		"GetTask",
		"GOODBYE"
	} --Should be identical to GREETING's options
})

DIALOGUE.addTopic("GOODBYE", {
	statement = "Na razie!",
	response = "Uważaj na siebie..."
})

----------------------------------------------------------------
----------------------START-TRADER-START------------------------
----------------------------------------------------------------

DIALOGUE.addTopic("TradeTopic", {
	statement = "Chcesz pohandlować?",
	response = "Tak!",
	postCallback = function(self, client, target)
		if (SERVER) then
			local character = client:GetCharacter()

			target.receivers[#target.receivers + 1] = client

			local items = {}
			-- Only send what is needed.
			for k, v in pairs(target.items) do
				if (!table.IsEmpty(v) and (CAMI.PlayerHasAccess(client, "Helix - Manage Vendors", nil) or v[VENDOR_MODE])) then
					items[k] = v
				end
			end

			target.scale = target.scale or 0.5
			client.ixVendorAdv = target

			-- force sync to prevent outdated inventories while buying/selling
			if (character) then
				character:GetInventory():Sync(client, true)
			end

			net.Start("ixVendorAdvOpen")
				net.WriteEntity(target)
				net.WriteUInt(target.money or 0, 16)
				net.WriteTable(items)
				net.WriteFloat(target.scale or 0.5)
			net.Send(client)

			ix.log.Add(client, "vendorUse", target:GetDisplayName())
		end
	end,
	options = {
		"BackTopic",
	}
})

----------------------------------------------------------------
------------------------END-TRADER-END--------------------------
----------------------------------------------------------------

----------------------------------------------------------------
--------------------START-TASKGIVER-START-----------------------
----------------------------------------------------------------

DIALOGUE.addTopic("GetTask", {
	statement = "Masz jakąś pracę dla mnie?",
	response = "Tak, zobacz co trzeba zrobić.",
	options = {
		"BackTopic"
	},
	preCallback = function(self, client, target)
		if client:ixHasJobFromNPC(target:GetDisplayName()) and CLIENT then
			self.response = "Już dostałeś odemnie robotę."
		end
	end,
	IsDynamic = true,
	GetDynamicOptions = function(self, client, target)
		local dynopts = {}

		if not client:ixHasJobFromNPC(target:GetDisplayName()) then
			local jobs = target:GetNetVar("jobs")

			for k,v in pairs(jobs) do
				table.insert(dynopts, {statement = ix.jobs.getFormattedNameInactive(v), topicID = "GetTask", dyndata = {identifier = v}})
			end
		end
		
		return dynopts
	end,
	ResolveDynamicOption = function(self, client, target, dyndata)

		-- Return the next topicID
		return "ConfirmTask", {description = ix.jobs.getFormattedDescInactive(dyndata.identifier), identifier = dyndata.identifier}
	end,
})


DIALOGUE.addTopic("ConfirmTask", {
	statement = "",
	response = "",
	IsDynamicFollowup = true,
	IsDynamic = true,
	DynamicPreCallback = function(self, player, target, dyndata)
		if(dyndata) then
			if (CLIENT) then
				self.response = dyndata.description
			else
				target.taskid = dyndata.identifier
			end
		end
	end,
	GetDynamicOptions = function(self, client, target)
		local dynopts = {
			{statement = "Wezmę", topicID = "ConfirmTask", dyndata = {accepted = true}},
			{statement = "Nie chcę, odpuszczam", topicID = "ConfirmTask", dyndata = {accepted = false}},
		}
		return dynopts
	end,
	ResolveDynamicOption = function(self, client, target, dyndata)
		if (SERVER) then
			if (dyndata.accepted) then
				if (!ix.jobs.NPCHasJob(target:GetDisplayName(), target.taskid)) then
					client:Notify("Ktoś już zabrał to zadanie!")
				else
					ix.dialogue.notifyTaskGet(client, ix.jobs.getFormattedNameInactive(target.taskid))
		
					client:ixJobAdd(target.taskid, target:GetDisplayName())
		
					ix.jobs.setNPCJobTaken(target:GetDisplayName(), target.taskid)
				end
			end
			
			target.taskid = nil
		end
		
		-- Return the next topicID
		return "BackTopic"
	end,
})

DIALOGUE.addTopic("AboutWorkTopic", {
	statement = "Jeśli chodzi o pracę...",
	response = "",
	IsDynamic = true,
	options = {
		"BackTopic"
	},
	GetDynamicOptions = function(self, client, target)
		local dynopts = {}

		if(client:ixHasJobFromNPC(target:GetDisplayName())) then
			local jobs = client:GetCharacter():GetJobs()

			-- If it's an item delivery quest, let the player hand in an item
			local itemuid = ix.jobs.isItemJob(jobs[target:GetDisplayName()].identifier)

			if itemuid and not jobs[target:GetDisplayName()].isCompleted then
				dynopts = {
					{statement = string.format("Dostarcz 1 %s", ix.item.list[itemuid].name), topicID = "AboutWorkTopic", dyndata = {identifier = itemuid}},
				}
			end
		end

		return dynopts
	end,
	preCallback = function(self, client, target)
		if client:ixHasJobFromNPC(target:GetDisplayName()) then
			local jobs = client:GetCharacter():GetJobs()
			if (jobs[target:GetDisplayName()].isCompleted) then
				if (SERVER) then 
					ix.dialogue.notifyTaskComplete(client, ix.jobs.getFormattedName(jobs[target:GetDisplayName()]))
					client:ixJobComplete(target:GetDisplayName()) 
				end
				if (CLIENT) then self.response = "Dobra robota, oto Twoja zapłata." end
			else
				if (CLIENT) then self.response = string.format("Skończyłeś %s już?", ix.jobs.getFormattedName(jobs[target:GetDisplayName()])) end
			end
		else
			if (CLIENT) then self.response = "Nie pracujesz dla mnie obecnie." end
		end

	end,
	ResolveDynamicOption = function(self, client, target, dyndata)
		netstream.Start("job_deliveritem", target:GetDisplayName())

		-- Return the next topicID
		return "BackTopic"
	end,
} )


----------------------------------------------------------------
---------------------END--TASKGIVER--END------------------------
----------------------------------------------------------------

----------------------------------------------------------------
--------------------START-TECHNICIAN-START----------------------
----------------------------------------------------------------

DIALOGUE.addTopic("RepairItems", {
	statement = "Możesz naprawić moje przedmioty?",
	response = "Co mam naprawić konkretnie?",
	IsDynamic = true,
	options = {
		"BackTopic"
	},
	GetDynamicOptions = function(self, client, target)
		local dynopts = {}

		local items = client:GetCharacter():GetInventory():GetItems()

		for k,v in pairs(items) do
			if v.canRepair then
				if v.isWeapon then
					local percenttorepair = (100 - v:GetData("wear", 100))
					if(percenttorepair < 0.5) then continue end
					local repaircost = math.Round(percenttorepair * v:GetRepairCost())

					table.insert(dynopts, {statement = v:GetName().." ( "..math.Round(v:GetData("wear", 100)).."% Wear ) - "..ix.currency.Get(repaircost), topicID = "RepairItems", dyndata = {itemuid = v.uniqueID , itemid = v:GetID(), cost = repaircost, type="wear"}})
				else
					local percenttorepair = (100 - v:GetData("durability", 100))
					if(percenttorepair < 0.5) then continue end
					local repaircost = math.Round(percenttorepair * v:GetRepairCost())

					table.insert(dynopts, {statement = v:GetName().." ( "..math.Round(v:GetData("durability", 100)).."% Durability ) - "..ix.currency.Get(repaircost), topicID = "RepairItems", dyndata = {itemuid = v.uniqueID , itemid = v:GetID(), cost = repaircost, type="durability"}})
				end
			end
		end
		
		return dynopts
	end,
	ResolveDynamicOption = function(self, client, target, dyndata)

		-- Return the next topicID
		if( !client:GetCharacter():HasMoney(dyndata.cost)) then
			return "NotEnoughMoneyRepair"
		end
		return "ConfirmRepair", dyndata
	end,
})

DIALOGUE.addTopic("ConfirmRepair", {
	statement = "",
	response = "",
	IsDynamicFollowup = true,
	IsDynamic = true,
	DynamicPreCallback = function(self, player, target, dyndata)
		if(dyndata) then
			if (CLIENT) then
				self.response = string.format("Naprawa %s będzie kosztowała %s.", ix.item.list[dyndata.itemuid].name ,ix.currency.Get(dyndata.cost))
			else
				target.repairstruct = { dyndata.itemid, dyndata.cost, dyndata.type }
			end
		end
	end,
	GetDynamicOptions = function(self, client, target)

		local dynopts = {
			{statement = "Okej, naprawiaj.", topicID = "ConfirmRepair", dyndata = {accepted = true}},
			{statement = "Muszę się zastanowić.", topicID = "ConfirmRepair", dyndata = {accepted = false}},
		}

		-- Return table of options
		-- statement : String shown to player
		-- topicID : should be identical to addTopic id
		-- dyndata : arbitrary table that will be passed to ResolveDynamicOption
		return dynopts
	end,
	ResolveDynamicOption = function(self, client, target, dyndata)
		if( SERVER and dyndata.accepted ) then
			ix.dialogue.notifyMoneyLost(client, target.repairstruct[2])
			client:GetCharacter():TakeMoney(target.repairstruct[2])


			ix.item.instances[target.repairstruct[1]]:SetData(target.repairstruct[3], 100)

		end
		if(SERVER)then
			target.repairstruct = nil
		end
		-- Return the next topicID
		return "BackTopic"
	end,
})

DIALOGUE.addTopic("NotEnoughMoneyRepair", {
	statement = "",
	response = "Nie masz tyle pieniędzy.",
	options = {
		"BackTopic"
	}
})

----------------------------------------------------------------
----------------------END-TECHNICIAN-END------------------------
----------------------------------------------------------------


----------------------------------------------------------------
---------------------START-INTEREST-START-----------------------
----------------------------------------------------------------

DIALOGUE.addTopic("InterestTopic", {
    statement = "Możesz opowiedzieć mi coś ciekawego?",
    response = "",
    options = {
    	"InterestMoreTopic",
        "BackTopic"
    },
    preCallback = function(self, client, target)
        if (CLIENT) then
            local tbl = {	"The Zone is a dangerous place. Anomalies are everywhere, and all the mutants here are out to get you, I swear.",
							"Did you know people stash their stuff everywhere? If you have a keen eye, you can find some interesting things.",
							"We STALKERS, as we call ourselves, are incredibly creative. I don't think any other place in the world has our level of craftiness and ability to survive even the harshest conditions. Who would have thought of using cutlery as makeshift digging tools, for instance?",
							"I've heard rumours of creatures out there, who can mess you up. Not in the sense that they gnaw and tear you apart, but that they send even the strongest willed men into the deepest hole - if they can make it away. I'm not going out there...",
							"The mutants in here are, to nobodys surprise, very irradiated. If you ever do plan to eat them, I suggest cooking them first, as it takes away a lot of their radiation.",
							"I'm still having trouble believing this place is not more well known, but I assume it's because everyone in the surrounding areas are being told not to say a word, and the military are not too keen on rulebreakers around here.",
							"If you ever encounter something that shakes you up, I suggest smoking a couple of cigarettes. They calm the mind, and help you think clearer."}

            self.response = table.Random(tbl)
        end
    end,
} )

DIALOGUE.addTopic("InterestMoreTopic", {
    statement = "Interesujące, coś jeszcze?",
    response = "",
    options = {
    	"InterestMoreTopic",
        "BackTopic"
    },
    preCallback = function(self, client, target)
        if (CLIENT) then
          	local tbl = {	"The Zone is a dangerous place. Anomalies are everywhere, and all the mutants here are out to get you, I swear.",
							"Did you know people stash their stuff everywhere? If you have a keen eye, you can find some interesting things.",
							"We STALKERS, as we call ourselves, are incredibly creative. I don't think any other place in the world has our level of craftiness and ability to survive even the harshest conditions. Who would have thought of using cutlery as makeshift digging tools, for instance?",
							"I've heard rumours of creatures out there, who can mess you up. Not in the sense that they gnaw and tear you apart, but that they send even the strongest willed men into the deepest hole - if they can make it away. I'm not going out there...",
							"The mutants in here are, to nobodys surprise, very irradiated. If you ever do plan to eat them, I suggest cooking them first, as it takes away a lot of their radiation.",
							"I'm still having trouble believing this place is not more well known, but I assume it's because everyone in the surrounding areas are being told not to say a word, and the military are not too keen on rulebreakers around here.",
							"If you ever encounter something that shakes you up, I suggest smoking a couple of cigarettes. They calm the mind, and help you think clearer."}

            self.response = table.Random(tbl)
        end
    end,
} )



----------------------------------------------------------------
-----------------------END-INTEREST-END-------------------------
----------------------------------------------------------------
local randomWep = {}
randomWep["arccw_firearms2_an94"] = "545x39"
randomWep["arccw_firearms2_fnfal"] = "762x51"
randomWep["arccw_firearms2_lr300"] = "556x45"
randomWep["arccw_firearms2_svd"] = "762x54"
randomWep["arccw_firearms2_galil"] = "556x45"

local items ={"plecakzbieracza","fas2_sight_compm4","fas2_muzzle_muzzlebrake","armor_medium","bandage","bandage","rushelmet2","drink_energy_drink","drink_energy_drink"}

DIALOGUE.addTopic("DailyItems", {
    statement = "Potrzebuję sprzętu, załatwisz mi coś na krechę??",
    response = "Zobaczę, jak coś będę miał to Ci dam.",
    preCallback = function(self, client, target)
		if(SERVER) then
			if(client:GetCharacter() and client:GetCharacter():GetData("nextFreeItems",os.time())<=os.time()) then
				client:GetCharacter():SetData("nexFreeItems",os.time()+(60*60*24))
				local inv = client:GetCharacter():GetInventory()
				local k,v = table.Random(randomWep)
				inv:Add(k,1)
				inv:Add(v,10)
				for _,v in pairs(items) do
					inv:Add(v)
				end
        	end
		end
    end,
} )