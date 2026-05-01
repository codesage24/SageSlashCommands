local Quest = SSC:NewModule("Quest")

function Quest:Execute(arg)
    if arg == "abandonall" then
        Quest:AbandonAll()
    else
        SSC:Print("Unknown slash command for Quest Module.")
    end
end

function Quest:AbandonAll()
    local questEntries = GetNumQuestLogEntries()

    if questEntries == 0 then
        SSC:Print("No quests to abandon.")
        return
    end

    for index = 1, 25 do
        if index > questEntries then
            break
        end
        
        SelectQuestLogEntry(index)
        SetAbandonQuest()

        local title = GetQuestLogTitle(index)
        AbandonQuest()

        if title then
            SSC:Print("Abandoned: " .. title)
        end
    end
end

function Quest:OnEnable()
    local helpText = { "quest abandonall" }

    SSC:RegisterCommand("quest", 
        function(arg) Quest:Execute(arg) end, 
        helpText)
end
