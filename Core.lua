SS = {}
SS.modules = {}
SS.commands = {}

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
    SageSlashCommands = true,
    SSPull = true,
}

-- Register a module
function SS:NewModule(name)
    local module = {}
    module.name = name
    self.modules[name] = module
    return module
end

-- Initialize all modules
function SS:Initialize()
    for _, module in pairs(self.modules) do
        if module.OnInitialize then
            module:OnInitialize()
        end
    end
end

-- Enable all modules
function SS:Enable()
    for _, module in pairs(self.modules) do
        if module.OnEnable then
            module:OnEnable()
        end
    end
end

function SS:RegisterCommand(name, func, helpText)
    self.commands[name] = {
        handler = func,
        helpText = helpText,
    }
end

function SS:PrintHelp()
    SS:Print("Commands:")

    for _, name in ipairs(GetSortedCommandNames(self.commands)) do
        local command = self.commands[name]

        if command.helpText then
            for _, line in ipairs(command.helpText) do
                SS:Print("/ssc " .. line)
            end
        else
            SS:Print("/ssc " .. name)
        end
    end
end

-- Event bootstrap
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" and ADDON_NAMES[arg1] then
        SS:Initialize()
        SS:Enable()
    end
end)

SLASH_SSC1 = "/ssc"

SlashCmdList["SSC"] = function(msg)
    local cmd, arg = msg:match("^(%S*)%s*(.-)$")
    cmd = (cmd or ""):lower()

    local command = SS.commands[cmd]

    if command then
        command.handler(arg)
    else
        SS:PrintHelp()
    end
end
