local ADDON_NAME, ns = ...
local config = ns.config

local font = ns.font

local function ShortValue(value)
    if value >= 1000000 then return ("%.1fm"):format(value / 1000000):gsub("%.?0+([km])$", "%1") end
    if value >= 1000 or value <= -1000 then return ("%.1fk"):format(value / 1000):gsub("%.?0+([km])$", "%1") end
    return value
end

ns.PostUpdateHealth = function(health, unit, min, max)
    if not UnitIsConnected(unit) then
        health.value:SetText("|cffD7BEA5OFFLINE|r")
        return
    elseif UnitIsDead(unit) then
        health.value:SetText("|cffD7BEA5DEAD|r")
        return
    elseif UnitIsGhost(unit) then
        health.value:SetText("|cffD7BEA5GHOST|r")
        return
    end
    
    health.value:SetText(ShortValue(min))
end

ns.PostCreateIcon = function(AuraWatchTable, spellFrame, spellID, spellName, unit)
	spellFrame.icon:SetDrawLayer("OVERLAY")
    spellFrame.count:SetFont(font, 12, "THINOUTLINE")
    spellFrame.count:SetPoint("TOPLEFT", spellFrame, "TOPLEFT", -4, 4)
end
