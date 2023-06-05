    function updateDistance(client)
        local character = client:GetCharacter()
        if(!character) then
            return
        end
        if(!client.distancePos) then
            client.distancePos = client:GetPos()
            return
        end
        if(client.distanceCharID~=character:GetID()) then
            client.distanceCharID = character:GetID()
            client.distancePos = client:GetPos()
            return 
        end
        local currentPos = client:GetPos()

        character:SetDistance(character:GetDistance()+math.Round(client.distancePos:Distance(currentPos)))
        client.distancePos = nil
    end

    function PLUGIN:OnCharacterDisconnect(client, character)
        updateDistance(client)
        timer.Destroy("distanceTimer"..client:SteamID64())
    end

    function PLUGIN:DoPlayerDeath(client)
        updateDistance(client)
    end



    function PLUGIN:PlayerSpawn(client)
        local character = client:GetCharacter()
        if(!character) then return end
        if(!timer.Exists("distanceTimer"..client:SteamID64())) then

            client.distanceCharID = character:GetID()
            timer.Create("distanceTimer"..client:SteamID64(),30,0, function()
                updateDistance(client)
                
            end)
        end
    end

