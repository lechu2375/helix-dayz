function PLUGIN:CharacterLoaded(character)
    local id = character:GetID()
    local player = character:GetPlayer()
    if(!timer.Exists("cplaytime"..player:SteamID64())) then
        timer.Create("cplaytime"..player:SteamID64(),60,0, function()
            if(IsValid(player) and character) then
                local character = player:GetCharacter()
                character:SetPlaytime(character:GetPlaytime()+1)
                print("Grasz na postaci już: "..character:GetPlaytime().." minut!")
            else
                //print("kurwoo nie ma chara")
                timer.Destroy(cplaytime..id)
            end
        end)
    end
end