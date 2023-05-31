PLUGIN.name = "Npc attention"
PLUGIN.description = "Running moves npc attention at you"

local distance = 900*900
if(timer.Exists("ixPlayerAttentionTimer")) then
    timer.Remove("ixPlayerAttentionTimer")
end
    timer.Create("ixPlayerAttentionTimer", 5, 0, function()
        local nextBotList = {}
        for _,v in pairs(ents.GetAll()) do
            
            if(v.NEXTBOTZOMBIE and !IsValid(v.Enemy)) then
                nextBotList[#nextBotList+1] = v

            end
        end
        for _,player in pairs(player.GetAll()) do
            //print(player:IsRunning())
            if( player:Alive() and player:IsRunning() and player:GetMoveType() ~= MOVETYPE_NOCLIP) then
                for index,bot in pairs(nextBotList) do
                    //print(bot,bot:GetRangeSquaredTo(player))
                    if(bot:GetRangeSquaredTo(player)<=distance) then
                        bot:SetEnemy(player)

                        nextBotList[index] = nil
                    end
                end
            end
        end
    
    end)

