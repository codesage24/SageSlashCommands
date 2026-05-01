SS.events = {}
local eventFrame = CreateFrame("Frame")

function SS:RegisterEvent(event, handler)
    if not self.events[event] then
        self.events[event] = {}
        eventFrame:RegisterEvent(event)
    end
    table.insert(self.events[event], handler)
end

eventFrame:SetScript("OnEvent", function(_, event, ...)
    if SS.events[event] then
        for _, handler in ipairs(SS.events[event]) do
            handler(...)
        end
    end
end)
