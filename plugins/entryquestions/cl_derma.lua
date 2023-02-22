net.Receive("EntryQuestionRequest", function()
    EntryQuestionTable = net.ReadTable()

    CreateEntryQuestionsPanel()
    ChooseQuestion(1,EntryQuestionTable.Question,EntryQuestionTable.Answers)
end)
function CreateEntryQuestionsPanel()
    if(EntryQuestionsDerma)  then
        EntryQuestionsDerma:Remove()
        EntryQuestionsDerma = nil
    end
    local background = vgui.Create("DPanel")
    background:SetSize(ScrW(),ScrH())
    EntryQuestionsDerma = vgui.Create("DFrame")
    background:SetParent(EntryQuestionsDerma)
    EntryQuestionsDerma.holder = {}
    local panel =  EntryQuestionsDerma
    function panel:Think()
        self:RequestFocus()
        self:SetZPos(99999)
        if(ix.gui.characterMenu and ix.gui.characterMenu:IsVisible()) then
            ix.gui.characterMenu:SetVisible(false)
        end
    end
    panel:ShowCloseButton(false)
    panel:SetSize(ScrW()*.4,ScrH()*.7)
    panel:Center()
    panel:MakePopup()
    panel:SetZPos(99999)
end
function ChooseQuestion(number)

    if(number>#EntryQuestionTable) then 
        EntryQuestionsDerma:Remove()
        EntryQuestionsDerma = nil
        if(ix.gui.characterMenu and ix.gui.characterMenu:IsVisible()) then
            ix.gui.characterMenu:SetVisible(true)
        end
        return
    end
    EntryQuestionsDerma:SetTitle(string.format("%s/%s",number,#EntryQuestionTable))
    for k,v in pairs(EntryQuestionsDerma.holder) do
        v:Remove()
    end
    local question = EntryQuestionTable[number].Question
    local answers  =  EntryQuestionTable[number].Answers
    EntryQuestionsDerma.holder["question"] = EntryQuestionsDerma:Add("DLabel")
    local label = EntryQuestionsDerma.holder["question"]
    label:Dock(TOP)
    label:SetFontInternal("ixMenuButtonFontThick")
    label:SetText(question)
	label:SetWrap(true)
	label:SetAutoStretchVertical(true)
	label:SizeToContents()

    for k,_ in pairs(answers)  do
        EntryQuestionsDerma.holder[k] =  EntryQuestionsDerma:Add("DButton")
        local button = EntryQuestionsDerma.holder[k]
        button:Dock(TOP)
        button:DockMargin(0, 0, 0, 8)
        button:SetFontInternal("ixMenuButtonFont")
        button:SetText(k)
        button:SetWrap(true)
        button:SetAutoStretchVertical(true)
        button:SizeToContents()
        button:SetTextInset(20,0)
        button.DoClick = function()

            net.Start("EntryQuestionRequest")
            net.WriteString(question)
            net.WriteString(k)
            net.SendToServer()

            ChooseQuestion(number+1)
        end
    end
 
    
end
local PANEL = {}




function PLUGIN:InitPostEntity()
	net.Start( "EntryQuestionClientRequest" )
	net.SendToServer()
end