local oUF = Tukui.oUF or oUF
assert(oUF, "Tukui was unable to locate oUF install.")

local _, ns = ...
local T, C, L = Tukui:unpack() 
local TukuiUnitFrames = T.UnitFrames

local Tukui_Raid_Healbot = ns.Tukui_Raid_Healbot

local config = ns.config
local font = config.font
local normTex = config.normTex
local Class = select(2, UnitClass("player"))

function Tukui_Raid_Healbot.createHealth(unit, config)
    local health = CreateFrame("StatusBar", nil, unit)
    health:SetPoint("TOPLEFT")
    health:SetPoint("TOPRIGHT")
    health:Height(config.height)
    health:SetStatusBarTexture(normTex)
    health:SetStatusBarColor(.2, .2, .2, 1)
    
    local bg = health:CreateTexture(nil, "BORDER")
    bg:SetAllPoints(health)
    bg:SetTexture(normTex)
    bg:SetVertexColor((178/225), (34/225), (34/225), 1)
    
    local name = health:CreateFontString(nil, "OVERLAY")
    name:SetPoint("TOP", health, 0, -2)
    name:SetFontObject(font)
    unit:Tag(name, "[Tukui:GetNameColor][Tukui:NameShort]")

    local value = health:CreateFontString(nil, "OVERLAY")
    value:SetPoint("BOTTOM", health, 0, 2)
    value:SetFontObject(font)
    value:SetTextColor(1, 1, 1)
    
    health.colorHappiness = false
    health.colorTapping = false
    health.colorDisconnected = false
    health.colorClass = false
    health.colorClassNPC = false
    health.colorClassPet = false
    health.colorReaction = false
    health.colorSmooth = false
    
    health.frequentUpdates = true 
    health.Smooth = config.showsmooth
    
    health.PostUpdate = Tukui_Raid_Healbot.PostUpdateHealth
    
    unit.Health = health
    unit.Health.bg = bg
    unit.Name = name
    unit.Health.value = value
end

function Tukui_Raid_Healbot.createPower(unit, config)
    local power = CreateFrame("StatusBar", nil, unit)
    power:Point("TOPLEFT", unit.Health, "BOTTOMLEFT", 0, -1)
    power:Point("TOPRIGHT", unit.Health, "BOTTOMRIGHT", 0, -1)
    power:SetHeight(config.height)
    power:SetStatusBarTexture(normTex)
    
    local bg = power:CreateTexture(nil, "BORDER")
    bg:SetAllPoints(power)
    bg:SetTexture(normTex)
    bg:SetAlpha(1)
    bg.multiplier = 0.4
    
    power.colorDisconnected = true
    power.colorPower = true
    power.frequentUpdates = true
    
    unit.Power = power
    unit.Power.bg = bg
end

function Tukui_Raid_Healbot.createDebuffWatch(unit, config)
	unit.DebuffHighlight = unit.Health:GetStatusBarTexture()
    unit.DebuffHighlightAlpha = 1
    unit.DebuffHighlightFilter = true
end

function Tukui_Raid_Healbot.createAuraWatch(unit, config)
    local auras = {}
    local spellIDs = ns.auras[Class]
    
    if not spellIDs then return end
    
    auras.presentAlpha = 1
    auras.missingAlpha = 0
    auras.PostCreateIcon = Tukui_Raid_Healbot.PostCreateIcon
    auras.strictMatching = false
    
    auras.icons = {}
    for spellId, settings in pairs(spellIDs) do
        local icon = CreateFrame("Frame", nil, unit)
        icon.spellID = spellId
        icon:SetSize(config.width, config.height)
        icon:SetPoint(settings[1], unit, settings[1], settings[2], settings[3])
        icon.anyUnit = settings[4] or nil
		
        icon.cd = ns:newTimer(icon, font, {14, 14}, {"CENTER", "BOTTOMRIGHT", 0, 4}, 0.3, {10, 4})
        -- add function used by oUF_AuraWatch
        icon.cd.SetCooldown = function(self, starttime, duration) self:setExpiryTime(starttime + duration) end
    
        auras.icons[spellId] = icon
    end
    unit.AuraWatch = auras
end

function Tukui_Raid_Healbot.createRaidIconWatch(unit, config)
    local RaidIcon = unit.Health:CreateTexture(nil, "OVERLAY")
    RaidIcon:SetSize(config.width, config.height)
    RaidIcon:SetPoint(config.anchor)
    RaidIcon:SetTexture(config.raidicons) -- thx hankthetank for texture
    unit.RaidIcon = RaidIcon
end

function Tukui_Raid_Healbot.createReadyCheckWatch(unit, config)
    local ReadyCheck = unit.Power:CreateTexture(nil, "OVERLAY")
    ReadyCheck:SetSize(config.width, config.height)
    ReadyCheck:SetPoint(config.anchor)     
    unit.ReadyCheck = ReadyCheck
end

function Tukui_Raid_Healbot.createHealcomm(unit, config)
    local myHealBar = CreateFrame("StatusBar", nil, unit.Health)
    myHealBar:SetSize(config.width, config.height)
    myHealBar:SetPoint("LEFT", unit.Health:GetStatusBarTexture(), "RIGHT", 0, 0)
    myHealBar:SetStatusBarTexture(normTex)
    myHealBar:SetStatusBarColor(0, 1, 0.5, 0.25)

    local othersHealBar = CreateFrame("StatusBar", nil, unit.Health)
    othersHealBar:SetSize(config.width, config.height)
    othersHealBar:SetPoint("LEFT", unit.Health:GetStatusBarTexture(), "RIGHT", 0, 0)
    othersHealBar:SetStatusBarTexture(normTex)
    othersHealBar:SetStatusBarColor(0, 1, 0, 0.25)

    local absorbBar = CreateFrame("StatusBar", nil, unit.Health)
    absorbBar:SetSize(config.width, config.height)
    absorbBar:SetPoint("LEFT", unit.Health:GetStatusBarTexture(), "RIGHT", 0, 0)
    absorbBar:SetStatusBarTexture(normTex)
    absorbBar:SetStatusBarColor(0, 1, 1, 0.25)

    local healAbsorbBar = CreateFrame("StatusBar", nil, unit.Health)
    healAbsorbBar:SetSize(config.width, config.height)
    healAbsorbBar:SetPoint("LEFT", unit.Health:GetStatusBarTexture(), "RIGHT", 0, 0)
    healAbsorbBar:SetStatusBarTexture(normTex)
    healAbsorbBar:SetStatusBarColor(0.8, 0.52, 0.25, 0.25)
    
    absorbBar:SetFrameLevel(unit.Health:GetFrameLevel())
    othersHealBar:SetFrameLevel(absorbBar:GetFrameLevel() + 1)
    myHealBar:SetFrameLevel(absorbBar:GetFrameLevel() + 2)
    healAbsorbBar:SetFrameLevel(absorbBar:GetFrameLevel() + 3)
    
    unit.HealPrediction = {
        myBar = myHealBar,
        otherBar = othersHealBar,
        absorbBar = absorbBar,
        healAbsorbBar = healAbsorbBar,
        maxOverflow = 1,
    }
end

function Tukui_Raid_Healbot.createRoleIconWatch(unit, config)
    local RoleIcon = unit.Health:CreateTexture(nil, "OVERLAY")
    RoleIcon:SetSize(config.width, config.height)
    RoleIcon:SetPoint(config.anchor)     
    unit.LFDRole = RoleIcon
end

function Tukui_Raid_Healbot.Raid(unitframe, unit) 
    unitframe.colors = oUF.oUF_colors
    unitframe:RegisterForClicks("AnyUp")
    unitframe:SetScript('OnEnter', UnitFrame_OnEnter)
    unitframe:SetScript('OnLeave', UnitFrame_OnLeave)
    
    unitframe.menu = oUF.SpawnMenu
    
    unitframe:SetBackdrop(config.backdrop)
    unitframe:SetBackdropColor(unpack(config.backdropcolor))
    
    Tukui_Raid_Healbot.createHealth(unitframe, config.health)
    Tukui_Raid_Healbot.createPower(unitframe, config.power)
    
    Tukui_Raid_Healbot.createDebuffWatch(unitframe, config.debuff)
    Tukui_Raid_Healbot.createAuraWatch(unitframe, config.aura)
    Tukui_Raid_Healbot.createRaidIconWatch(unitframe, config.raidicon)
    Tukui_Raid_Healbot.createReadyCheckWatch(unitframe, config.readycheck)
    Tukui_Raid_Healbot.createHealcomm(unitframe, config.health)
    Tukui_Raid_Healbot.createRoleIconWatch(unitframe, config.roleicon)
    
    unitframe.Range = config.range
    
    if Tukui_Raid_Healbot.unitspecific[Class] then
        Tukui_Raid_Healbot.unitspecific[Class](unitframe)
    end
    
    return unitframe
end

TukuiUnitFrames.Raid = Tukui_Raid_Healbot.Raid

function TukuiUnitFrames:GetRaidFramesAttributes()
    return 
        "Tukui_Raid_Healbot",
        nil, 
        "raid,party,solo",
        'oUF-initialConfigFunction', [[
            local header = self:GetParent()
            self:SetWidth(header:GetAttribute('initial-width'))
            self:SetHeight(header:GetAttribute('initial-height'))
        ]],
        -- attributes
        "point", "TOP",
        "xoffset", 3,
        "yOffset", -3,
        "maxColumns", 5,
        "unitsPerColumn", 5,
        "columnSpacing", 3,
        "columnAnchorPoint", "LEFT",
        'initial-width', config.width,
        'initial-height', config.height,
        
        -- filtering
        "showRaid", config.showRaid, 
        "showParty", config.showParty,
        "showPlayer", config.showPlayer, 
        "showSolo", config.showSolo,
        
        -- grouping
        "groupBy", "ASSIGNEDROLE",
        "groupingOrder", "TANK, HEALER, DAMAGER, NONE",
        
        "growth", "DOWN"
end

local function CreateUnits()
    local Raid = TukuiUnitFrames.Headers.Raid
    Raid:ClearAllPoints()
    Raid:SetPoint(unpack(config.anchor))
end

hooksecurefunc(TukuiUnitFrames, "CreateUnits", CreateUnits)