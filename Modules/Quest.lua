local Quest = SS:NewModule("Quest")

function Quest:Execute(arg)
    if arg == "abandonall" then
        Quest:AbandonAll()
    else
        SS:Print("Unknown slash command for Quest Module.")
    end
end

function Quest:AbandonAll()
    local questEntries = GetNumQuestLogEntries()

    if questEntries == 0 then
        SS:Print("No quests to abandon.")
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
            SS:Print("Abandoned: " .. title)
        end
    end
end

function Quest:OnEnable()
    local helpText = { "quest abandonall" }

    SS:RegisterCommand("quest", 
        function(arg) Quest:Execute(arg) end, 
        helpText)
end
