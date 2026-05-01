local Pull = SS:NewModule("Pull")

Pull.timerFrame = nil
Pull.timeLeft = 0

function Pull:Execute(arg)
    if arg == "cancel" then
        Pull:Cancel()
    else
        Pull:Start(arg)
    end
end

function Pull:Start(arg)
    if arg == "cancel" then
        Pull:Cancel()
        return
    end

    local seconds = tonumber(arg)
    if not seconds or seconds <= 0 then
        -- SS:Print("Usage: /ss pull <seconds>")
        -- return
        seconds = 10 -- default to 10 seconds if invalid input
    end

    if not SS:HasPermission() then
        SS:Print("You must be raid leader/assist or party leader.")
        return
    end

    self:Cancel()

    self.timeLeft = seconds
    local elapsed = 0

    self.timerFrame = CreateFrame("Frame")

    SS:SendRW("Pull in " .. seconds .. " seconds!")

    self.timerFrame:SetScript("OnUpdate", function(_, delta)
        elapsed = elapsed + delta

        if elapsed >= 1 then
            elapsed = 0
            Pull.timeLeft = Pull.timeLeft - 1

            if Pull.timeLeft <= 0 then
                SS:SendRW("PULL NOW!")
                PlaySoundFile("Sound\\Interface\\RaidWarning.wav")
                Pull:Clear()
                return
            end

            local db = SS.db.pull

            if Pull.timeLeft <= db.spamUnder or Pull.timeLeft % db.countdownInterval == 0 then
                SS:SendRW(Pull.timeLeft .. "...")
            end
        end
    end)
end

function Pull:Cancel()
    if self.timerFrame then
        Pull:Clear()
        SS:SendRW("PULL TIMER CANCELLED!")
    else
        SS:Print("No active timer exists.")
    end
end

function Pull:Clear()
    if self.timerFrame then
        self.timerFrame:SetScript("OnUpdate", nil)
        self.timerFrame = nil
        self.timeLeft = 0
    end
end

function Pull:OnEnable()
    local helpText = { "pull <seconds>", "pull cancel" }

    SS:RegisterCommand("pull", 
        function(arg) Pull:Execute(arg) end, 
        helpText)
end
