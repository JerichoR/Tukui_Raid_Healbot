local ADDON_NAME, ns = ...
local config = ns.config

ns.Tukui_Raid_Healbot.ShortValue = function(value)
    if value >= 1000000 then return ("%.1fm"):format(value / 1000000):gsub("%.?0+([km])$", "%1") end
    if value >= 1000 or value <= -1000 then return ("%.1fk"):format(value / 1000):gsub("%.?0+([km])$", "%1") end
    return value
end

ns.Tukui_Raid_Healbot.PostUpdateHealth = function(health, unit, min, max)
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
    
    health.value:SetText(ns.Tukui_Raid_Healbot.ShortValue(min))
end

ns.Tukui_Raid_Healbot.PostCreateIcon = function(AuraWatchTable, spellFrame, spellID, spellName, unit)
	spellFrame.icon:SetDrawLayer("OVERLAY")
    spellFrame.count:SetFont(config.font, 12, "THINOUTLINE")
    spellFrame.count:SetPoint("TOPLEFT", spellFrame, "TOPLEFT", -4, 4)
end

ns.Tukui_Raid_Healbot.unitspecific = {}
ns.Tukui_Raid_Healbot.unitspecific.PRIEST = function(unitframe)
    local ws = CreateFrame("StatusBar", unitframe:GetName().."_WeakenedSoul", unitframe.Power)
    ws:SetAllPoints(unitframe.Power)
    ws:SetStatusBarTexture(config.normTex)
    ws:SetBackdrop(config.backdrop)
    ws:SetBackdropColor(unpack(ns.config.backdropcolor))
    ws:SetStatusBarColor(191/255, 10/255, 10/255)
    
    unitframe.WeakenedSoul = ws
end