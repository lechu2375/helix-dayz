--[[
  --TestJob
  local tempJob = {}

  tempJob.name = "Hand over Say sneed %d times."                  --Name that will be shown in dialogue when selecting tasks
  tempJob.desc = "I need you to sneed %d times for me." --Description of task, will be shown to the player when deciding to take quest or not
  tempJob.icon = "propic/event/loot"          --Icon, unused?
  tempJob.tier = 1                                      --Tier, unused?
  tempJob.listenTrigger = "chatSayTest"                 --trigger word to listen for in the ix_JobTrigger hook, see sh_listeners
  tempJob.numberRec = 5                                 --integer amount of times the listenTrigger must be run through the ix_JobTrigger hook
  tempJob.reward = {{"tokarev"}}                     --table of item ids for rewarding the player with
  tempJob.rewardCount = 1                               --how many items should the player get
  tempJob.repReward = 80                                --how much reputation should be awarded for completion
  tempJob.categories = {"mutantkilleasy"}               --table of category identifiers, used for when npc gets tasks
  tempJob.moneyReward = {2000,4000} OR 3000             --for adding money to the player, can technically be done through itemreward as well

  ix.jobs.register(tempJob, "TestJob")                  --If item delivery quest, the final part of the quest identifier should read "_<uniqueid>" for proper operation

]]--



do
------------------------------------------------
------------- ITEM RETRIEVAL - MEAT ------------
------------------------------------------------

  local tempJob = {}

  tempJob.name = "Przekaż %d sztuk kabli."
  tempJob.desc = "%d sztuk kabli."
  tempJob.icon = "propic/event/loot"
  tempJob.tier = 1
  tempJob.listenTrigger = "itemDeliver_wires"
  tempJob.numberRec = 4
  tempJob.reward = {{"545x39", { ["quantity"] = 30 }}, {"556x45", { ["quantity"] = 30 }}, {"9x18", { ["quantity"] = 40 }}, {"9x19", { ["quantity"] = 40 }}, {"762x39", { ["quantity"] = 25 }}}
  tempJob.rewardCount = 1
  tempJob.repReward = 10
  tempJob.moneyReward = {175, 325}
  tempJob.categories = {"electronicseasy"}

  ix.jobs.register(tempJob, "ItemJob1_wires")

  tempJob = nil


  /*
  local tempJob = {}

  tempJob.name = "Hand over %d pieces of blind dog meat."
  tempJob.desc = "%d pieces of blind dog meat."
  tempJob.icon = "propic/event/loot"
  tempJob.tier = 1
  tempJob.listenTrigger = "itemDeliver_meat_blinddog"
  tempJob.numberRec = 8
  tempJob.reward = {{"762x25"}, {"22lr"}, {"9x18"}, {"9x19"}, {"45acp"}}
  tempJob.rewardCount = 1
  tempJob.repReward = 10
  tempJob.moneyReward = {275, 425}
  tempJob.categories = {"mutantmeateasy"}

  ix.jobs.register(tempJob, "ItemJob2_meat_blinddog")

  tempJob = nil

  local tempJob = {}

  tempJob.name = "Hand over %d pieces of bloodsucker meat."
  tempJob.desc = "%d pieces of bloodsucker meat."
  tempJob.icon = "propic/event/loot"
  tempJob.tier = 1
  tempJob.listenTrigger = "itemDeliver_meat_bloodsucker"
  tempJob.numberRec = 2
  tempJob.reward = {{"762x25"}, {"22lr"}, {"9x18"}, {"9x19"}, {"45acp"}}
  tempJob.rewardCount = 1
  tempJob.repReward = 35
  tempJob.moneyReward = {400, 500}
  tempJob.categories = {"mutantmeatmedium"}

  ix.jobs.register(tempJob, "ItemJob1_meat_bloodsucker")

  tempJob = nil

  image.png


-----------------------------------------------------
-----------------------------------------------------
------------- ITEM RETRIEVAL - ELECTRONICS ----------
-----------------------------------------------------
-----------------------------------------------------

-- mixed kits

  local tempJob = {}

  tempJob.name = "Przekaż %d sztuk kabli."
  tempJob.desc = "%d SSD."
  tempJob.icon = "propic/event/loot"
  tempJob.tier = 1 
  tempJob.listenTrigger = "itemDeliver_value_pcpart_ssd"
  tempJob.numberRec = 1
  tempJob.reward = {{"kit_mixed_low"}}
  tempJob.rewardCount = 1
  tempJob.repReward = 9
  tempJob.moneyReward = {800, 1800}
  tempJob.categories = {"electronics", "information"}

  ix.jobs.register(tempJob, "ItemJob1_value_pcpart_ssd")

  tempJob = nil

  

-----------------------------------------------------
-----------------------------------------------------
-------- ITEM RETRIEVAL - GUNS/REPAIRING  -----------
-----------------------------------------------------
-----------------------------------------------------

  local tempJob = {}

  tempJob.name = "Hand over %d Household Glue."
  tempJob.desc = "%d Household Glue."
  tempJob.icon = "propic/event/loot"
  tempJob.tier = 1
  tempJob.listenTrigger = "itemDeliver_value_glue_1"
  tempJob.numberRec = 1
  tempJob.reward = {{"kit_mixed_low"}}
  tempJob.rewardCount = 1
  tempJob.repReward = 2
  tempJob.moneyReward = {330, 480}
  tempJob.categories = {"repair"}

  ix.jobs.register(tempJob, "ItemJob1_value_glue_1")

  tempJob = nil

  
-----------------------------------------------------
-----------------------------------------------------
-------- ITEM RETRIEVAL - MECHANICAL/TOWN -----------
-----------------------------------------------------
-----------------------------------------------------

-- Mixed kits

  local tempJob = {}

  tempJob.name = "Hand over %d Bolts."
  tempJob.desc = "%d Bolts."
  tempJob.icon = "propic/event/loot"
  tempJob.tier = 1
  tempJob.listenTrigger = "itemDeliver_value_bolts"
  tempJob.numberRec = 4
  tempJob.reward = {{"762x25", { ["quantity"] = 15 }}, {"22lr", { ["quantity"] = 20 }}, {"9x18", { ["quantity"] = 15 }}, {"9x19", { ["quantity"] = 12 }}, {"45acp", { ["quantity"] = 10 }}}
  tempJob.rewardCount = 1
  tempJob.repReward = 2
  tempJob.moneyReward = {100, 150}
  tempJob.categories = {"mechanical", "town"}

  ix.jobs.register(tempJob, "ItemJob1_value_bolts")

  tempJob = nil

  local tempJob = {}

  tempJob.name = "Hand over %d Bolts."
  tempJob.desc = "%d Bolts."
  tempJob.icon = "propic/event/loot"
  tempJob.tier = 1
  tempJob.listenTrigger = "itemDeliver_value_bolts"
  tempJob.numberRec = 20
  tempJob.reward = {{"762x25"}, {"22lr"}, {"9x18"}, {"9x19"}, {"45acp"}}
  tempJob.rewardCount = {1,2}
  tempJob.repReward = 12
  tempJob.moneyReward = {500, 700}
  tempJob.categories = {"mechanical", "town"}

  ix.jobs.register(tempJob, "ItemJob2_value_bolts")

  tempJob = nil


  


-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
-------- ITEM RETRIEVAL - RICHES (Single Item, as they are rare) --------------------
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

-- Lots of money, generic valuables

  local tempJob = {}

  tempJob.name = "Hand over %d Cat Statuette."
  tempJob.desc = "%d Cat Statuette."
  tempJob.icon = "propic/event/loot"
  tempJob.tier = 1
  tempJob.listenTrigger = "itemDeliver_value_statue_cat"
  tempJob.numberRec = 1
  tempJob.reward = {{"kit_mixed_high"}}
  tempJob.rewardCount = {1,1}
  tempJob.repReward = 25
  tempJob.moneyReward = {600, 900}
  tempJob.categories = {"riches"}

  ix.jobs.register(tempJob, "ItemJob1_value_statue_cat")

  tempJob = nil
*/
  
end
