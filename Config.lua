local defaults = {
    pull = {
        countdownInterval = 5,
        spamUnder = 5
    }
}

local function CopyDefaults(src, dst)
    if type(src) ~= "table" then return {} end
    if type(dst) ~= "table" then dst = {} end

    for k, v in pairs(src) do
        if type(v) == "table" then
            dst[k] = CopyDefaults(v, dst[k])
        elseif dst[k] == nil then
            dst[k] = v
        end
    end
    return dst
end

function SS:InitDB()
    SSCDB = SSCDB or {}
    self.db = CopyDefaults(defaults, SSCDB)
end

-- Hook into lifecycle
local module = SS:NewModule("Config")

function module:OnInitialize()
    SS:InitDB()
end
