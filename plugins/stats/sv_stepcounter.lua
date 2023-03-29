function PLUGIN:PlayerFootstep(client)
    client.footsteps = client.footsteps+1
end

function PLUGIN:OnCharacterDisconnect(client, character)
    character:SetSteps(character:GetSteps()+client.footsteps)
end

function PLUGIN:PlayerLoadedCharacter(client, character, currentChar)
    if(currentChar) then
        currentChar:SetSteps(currentChar:GetSteps()+client.footsteps)
    end
    client.footsteps = 0
end