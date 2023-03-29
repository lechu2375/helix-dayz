--[[
  --TestJob
  local tempJob = {}

  tempJob.name = "Kill Say sneed %d times."                  --Name that will be shown in dialogue when selecting tasks
  tempJob.desc = "I need you to sneed %d times for me." --Description of task, will be shown to the player when deciding to take quest or not
  tempJob.icon = "stalker/questpaper_item.png"          --Icon, unused?
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
  --random amount of mutants
  local tempJob = {}

  tempJob.name = "Zabij %d zombie."
  tempJob.desc = "%d zombie."
  tempJob.icon = "propic/event/mutanthunt"
  tempJob.tier = 1
  tempJob.listenTrigger = "zombieKilled"
  tempJob.numberRec = 12
  tempJob.reward = {{"545x39", { ["quantity"] = 30 }}, {"556x45", { ["quantity"] = 30 }}, {"9x18", { ["quantity"] = 40 }}, {"9x19", { ["quantity"] = 40 }}, {"762x39", { ["quantity"] = 25 }}}
  tempJob.rewardCount = 2
  tempJob.repReward = 12
  tempJob.moneyReward = {750, 1100}
  tempJob.categories = {"mutantkillgroupeasy"}

  ix.jobs.register(tempJob, "killMutantsLow")

  tempJob = nil

  local tempJob = {}

  tempJob.name = "Zabij %d zombie."
  tempJob.desc = "%d zombie."
  tempJob.icon = "propic/event/mutanthunt"
  tempJob.tier = 1
  tempJob.listenTrigger = "zombieKilled"
  tempJob.numberRec = 5
  tempJob.reward = {{"545x39", { ["quantity"] = 15 }}, {"556x45", { ["quantity"] = 15 }}, {"9x18", { ["quantity"] = 20 }}, {"9x19", { ["quantity"] = 20 }}, {"762x39", { ["quantity"] = 10 }}}
  tempJob.rewardCount = 2
  tempJob.repReward = 12
  tempJob.moneyReward = {750, 1100}
  tempJob.categories = {"mutantkillgroupeasy"}

  ix.jobs.register(tempJob, "killMutants5")

  tempJob = nil
  
end
