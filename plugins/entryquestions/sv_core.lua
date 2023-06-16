util.AddNetworkString("EntryQuestionRequest")
util.AddNetworkString("EntryQuestionClientRequest")
ix.log.AddType("questionResult", function(client,state)
	return string.format("%s has %s the RolePlay test", client:Name(),state)
end,FLAG_DANGER)
EntryQuestions = EntryQuestions or {}
function AddEntryQuestion(question,answer,...)
    for k,v in pairs(EntryQuestions) do
        if(v.Question==question) then
            return
        end
    end
    local qID = #EntryQuestions+1
    EntryQuestions[qID] = {}
    local tbl = EntryQuestions[qID]
    tbl.Question = question
    tbl.GoodAnswer = answer
    tbl.Answers = {}
    local answers = {...}
    for _,v in pairs(answers) do
        EntryQuestions[qID]["Answers"][v] = true
    end

end
function PLUGIN:InitializedPlugins()
    AddEntryQuestion("Co to jest RP?","RolePlay","Riot Points","Nie wiem")
    AddEntryQuestion("Co to MG?","Używanie informacji z OOC w IC","Master Game","Używanie informacji IC w OOC")
    AddEntryQuestion("Możesz atakować graczy bez powodu?","Tak","Nie","Nie wiem")
    AddEntryQuestion("Co powinieneś zrobić gdy ktoś Cię zaatakuje bez powodu?","Spróbować go zabić","Zgłosić go do administracji","Zwyzywać go na OOC")
    AddEntryQuestion("Ktoś wyzywa kogoś innego na radiowęźle, co możesz zrobić?","Nie interesuje mnie to, sprawa jest IC.","Zgłaszam go do administracji","Wyzywam go na czacie OOC")
end



function RequestEntryQuestionAnswer(client)
    net.Start("EntryQuestionRequest")
        local ToSend = {}
        for k,v in pairs(EntryQuestions) do
            ToSend[k] = {}
            ToSend[k].Question = v.Question
            ToSend[k].Answers = {}
            ToSend[k].Answers[v.GoodAnswer] = true
            for answer,_ in pairs(v.Answers) do
                ToSend[k].Answers[answer] = true 
            end
        end
        //PrintTable(ToSend)
        net.WriteTable(ToSend)
    net.Send(client)
    client.AnswerTable = {}
end
local RequiredPercentage = 50
function CheckQuestions(client)
    local correct,bad = 0,0
    local AnswerTable = client.AnswerTable
    for k,v in pairs(AnswerTable) do
        for i,s in pairs(EntryQuestions) do
            if(s.Question==k) then
                if(s.GoodAnswer==v) then
                   correct=correct+1
                else
                    bad=bad+1
                end
            end
        end
    end

    local questions = correct+bad
    local percentage = (correct/questions)*100
    local passed
    if(percentage<RequiredPercentage)then
        ix.log.Add(client, "questionResult","not passed")
        SavePlayerQuestionAnswer(client,false)
        passed  = false
    else
        passed = true
        SavePlayerQuestionAnswer(client,true)
    end
    client:Notify(string.format("Masz %s dobrych odpowiedzi i %s złych",correct,bad))
    AnswerTable = {}
    if(!passed)then
        client:Kick("Nie zdałeś testu, przeczytaj regulamin na discordzie. Link znajduje się w nazwie serwera.")
    end
end
net.Receive("EntryQuestionRequest", function(len,ply)
    local question = net.ReadString()
    local answer = net.ReadString()
    ply.AnswerTable[question] = answer
    if(table.Count(ply.AnswerTable)>=#EntryQuestions)then
        CheckQuestions(ply)
    end
end)


function SavePlayerQuestionAnswer(client,state)
    local steamid = client:SteamID64()
	local query = mysql:Select("entryquestion")
		query:Select("steamid")
		query:Where("steamid", steamid)
		query:Callback(function(result)
			if(!result or table.IsEmpty(result)) then
                local insertQuery = mysql:Insert("entryquestion")
                    insertQuery:Insert("steamid", steamid)
                    insertQuery:Insert("passed", state)
                insertQuery:Execute()    
            else
                local updateQuery = mysql:Update("entryquestion")
                    updateQuery:Update("passed", state)
                    updateQuery:Where("steamid", steamid)
                updateQuery:Execute()
            end
		end)
	query:Execute()    
end
function PLUGIN:DatabaseConnected()
	local query = mysql:Create("entryquestion")
		query:Create("steamid", "VARCHAR(64) NOT NULL")
		query:Create("passed", "VARCHAR(64) NOT NULL")
		query:PrimaryKey("steamid")
	query:Execute()
end

local PLAYER = FindMetaTable("Player")
function PLAYER:HasPassedTest()
    local passed = false
    local steamid = self:SteamID64()
	local query = mysql:Select("entryquestion")
		query:Select("passed")
		query:Where("steamid", steamid)
		query:Callback(function(result)
            if(!result or table.IsEmpty(result)) then
                passed = false
            else
                passed=result[1].passed
            end
		end)
	query:Execute() 
    passed = tobool(passed)
    return passed
end
function PLUGIN:CanPlayerUseCharacter(client, character)
    local bCanUse =  client:HasPassedTest()
    return bCanUse
end
net.Receive("EntryQuestionClientRequest", function(len,ply)
    //print(ply,"passed?:",ply:HasPassedTest())
    if(!ply:HasPassedTest()) then
        RequestEntryQuestionAnswer(ply)
    end
end)