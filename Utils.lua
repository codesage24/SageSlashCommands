SS = SS or {}

-- Updated permission check (raid OR party leader)
function SS:HasPermission()
    if IsInRaid() then
        return self:HasRaidWarningPermission()
    elseif IsInGroup() then
        return GetNumPartyMembers() > 0 and UnitIsPartyLeader("player")
    else
        return false -- disallow solo usage
    end
end

function SS:HasRaidWarningPermission()
    return IsRaidLeader() or IsRaidOfficer()
end

function SS:SendRW(msg)
    if IsInRaid() then
        SendChatMessage(msg, "RAID_WARNING")
    else
        SendChatMessage(msg, "PARTY")
    end
end

function SS:Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99SSC|r: " .. msg)
end
