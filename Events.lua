SSC.events = {}
local eventFrame = CreateFrame("Frame")

function SSC:RegisterEvent(event, handler)
    if not self.events[event] then
        self.events[event] = {}
        eventFrame:RegisterEvent(event)
    end
    table.insert(self.events[event], handler)
end

eventFrame:SetScript("OnEvent", function(_, event, ...)
    if SSC.events[event] then
        for _, handler in ipairs(SSC.events[event]) do
            handler(...)
        end
    end
end)
