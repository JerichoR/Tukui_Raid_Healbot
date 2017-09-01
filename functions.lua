local _, ns = ...
local T, C, L = Tukui:unpack() 
local config = ns.config

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
    
    health.value:SetText(T.ShortValue(min))
end

ns.Tukui_Raid_Healbot.PostCreateIcon = function(AuraWatchTable, spellFrame, spellID, spellName, unit)
	spellFrame.icon:SetDrawLayer("OVERLAY")
    spellFrame.count:SetFont(config.font, 12, "THINOUTLINE")
    spellFrame.count:SetPoint("TOPLEFT", spellFrame, "TOPLEFT", -4, 4)
end

ns.Tukui_Raid_Healbot.unitspecific = {}
ns.Tukui_Raid_Healbot.unitspecific.PRIEST = function(unitframe)
    local ws = CreateFrame("StatusBar", nil, unitframe.Power)
    ws:SetAllPoints(unitframe.Power)
    ws:SetStatusBarTexture(config.normTex)
    ws:SetBackdrop(config.backdrop)
    ws:SetBackdropColor(unpack(ns.config.backdropcolor))
    ws:SetStatusBarColor(0.75, 0.04, 0.04)
    
    unitframe.WeakenedSoul = ws
end