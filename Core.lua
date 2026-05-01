SSC = {}
SSC.modules = {}
SSC.commands = {}

local function GetSortedCommandNames(commands)
    local names = {}

    for name in pairs(commands) do
        table.insert(names, name)
    end

    table.sort(names)

    return names
end

local frame = CreateFrame("Frame")
local ADDON_NAMES = {
    SageSlashCommands = true
}

-- Register a module
function SSC:NewModule(name)
    local module = {}
    module.name = name
    self.modules[name] = module
    return module
end

-- Initialize all modules
function SSC:Initialize()
    for _, module in pairs(self.modules) do
        if module.OnInitialize then
            module:OnInitialize()
        end
    end
end

-- Enable all modules
function SSC:Enable()
    for _, module in pairs(self.modules) do
        if module.OnEnable then
            module:OnEnable()
        end
    end
end

function SSC:RegisterCommand(name, func, helpText)
    self.commands[name] = {
        handler = func,
        helpText = helpText,
    }
end

function SSC:PrintHelp()
    SSC:Print("Commands:")

    for _, name in ipairs(GetSortedCommandNames(self.commands)) do
        local command = self.commands[name]

        if command.helpText then
            for _, line in ipairs(command.helpText) do
                SSC:Print("/ssc " .. line)
            end
        else
            SSC:Print("/ssc " .. name)
        end
    end
end

-- Event bootstrap
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" and ADDON_NAMES[arg1] then
        SSC:Initialize()
        SSC:Enable()
    end
end)

SLASH_SSC1 = "/ssc"

SlashCmdList["SSC"] = function(msg)
    local cmd, arg = msg:match("^(%S*)%s*(.-)$")
    cmd = (cmd or ""):lower()

    local command = SSC.commands[cmd]

    if command then
        command.handler(arg)
    else
        SSC:PrintHelp()
    end
end
