function PLUGIN:CharacterLoaded(character)
    local id = character:GetID()
    local player = character:GetPlayer()
    if(!timer.Exists("cplaytime"..player:SteamID64())) then
        timer.Create("cplaytime"..player:SteamID64(),60,0, function()
            if(IsValid(player) and character) then
                local character = player:GetCharacter()
                if(character) then
                    character:SetPlaytime(character:GetPlaytime()+1)
                    if(character:GetPlaytime()==60) then  
                        ix.discordrelay.RelayChatToDiscord(character:GetName(), "Właśnie przegrał swoją pierwszą godzinę na postaci!")
                    end
                end
            else
                //print("kurwoo nie ma chara")
                timer.Destroy("cplaytime"..player:SteamID64())
            end
        end)
    end
end