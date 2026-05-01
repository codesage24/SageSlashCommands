SSC = SSC or {}

-- Updated permission check (raid OR party leader)
function SSC:HasPermission()
    if IsInRaid() then
        return self:HasRaidWarningPermission()
    elseif IsInGroup() then
        return GetNumPartyMembers() > 0 and UnitIsPartyLeader("player")
    else
        return false -- disallow solo usage
    end
end

function SSC:HasRaidWarningPermission()
    return IsRaidLeader() or IsRaidOfficer()
end

function SSC:SendRW(msg)
    if IsInRaid() then
        SendChatMessage(msg, "RAID_WARNING")
    else
        SendChatMessage(msg, "PARTY")
    end
end

function SSC:Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99SSC|r: " .. msg)
end

function SSC:IsNumber(value)
    return tonumber(value) ~= nil
end
