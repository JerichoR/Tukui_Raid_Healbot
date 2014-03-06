local ADDON_NAME, ns = ...
local oUF = oUFTukui or oUF
assert(oUF, "Tukui was unable to locate oUF install.")

local T, C, L, G = unpack(Tukui) -- Import: T - functions, constants, variables; C - config; L - locales; G - Globals

local Tukui_Raid_Healbot = ns.Tukui_Raid_Healbot

local config = ns.config
local font = config.font
local normTex = config.normTex

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
    name:SetFont(font, config.fontsize)
    unit:Tag(name, "[Tukui:getnamecolor][Tukui:nameshort]")
    
    local value = health:CreateFontString(nil, "OVERLAY")
    value:SetPoint("BOTTOM", health, 0, 2)
    value:SetFont(font, config.fontsize, nil)
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
    local spellIDs = ns.auras[T.myclass]
    
    if not spellIDs then return end
    
    auras.presentAlpha = 1
    auras.missingAlpha = 0
    auras.PostCreateIcon = Tukui_Raid_Healbot.PostCreateIcon
    auras.strictMatching = false
    
    auras.icons = {}
    for spellId, settings in pairs(spellIDs) do
        local icon = CreateFrame("Frame", nil, unit)
        icon.spellID = spellId
        icon:SetWidth(config.width)
        icon:SetHeight(config.height)
        icon:SetPoint(settings[1], unit, settings[1], settings[2], settings[3])
        icon.anyUnit = settings[4] or nil
		
        icon.cd = ns:newTimer(icon, {font, 12, "THINOUTLINE"}, {14, 14}, {"CENTER", "BOTTOMRIGHT", 0, 4}, 0.3, {10, 4})
        -- add function used by oUF_AuraWatch
        icon.cd.SetCooldown = function(self, starttime, duration) self:setExpiryTime(starttime + duration) end
    
        auras.icons[spellId] = icon
    end
    unit.AuraWatch = auras
end

function Tukui_Raid_Healbot.createRaidIconWatch(unit, config)
    local RaidIcon = unit.Health:CreateTexture(nil, "OVERLAY")
    RaidIcon:Height(config.height)
    RaidIcon:Width(config.width)
    RaidIcon:SetPoint(config.anchor)
    RaidIcon:SetTexture(config.raidicons) -- thx hankthetank for texture
    unit.RaidIcon = RaidIcon
end

function Tukui_Raid_Healbot.createReadyCheckWatch(unit, config)
    local ReadyCheck = unit.Power:CreateTexture(nil, "OVERLAY")
    ReadyCheck:Height(config.height)
    ReadyCheck:Width(config.width)
    ReadyCheck:SetPoint(config.anchor)     
    unit.ReadyCheck = ReadyCheck
end

function Tukui_Raid_Healbot.createHealcomm(unit, config)
    local mhpb = CreateFrame("StatusBar", nil, unit.Health)
    mhpb:SetPoint("TOPLEFT", unit.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
    mhpb:SetPoint("BOTTOMLEFT", unit.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
    mhpb:Width(config.width)
    mhpb:SetStatusBarTexture(normTex)
    mhpb:SetStatusBarColor(0, 1, 0.5, 0.25)

    local ohpb = CreateFrame("StatusBar", nil, unit.Health)
    ohpb:SetPoint("TOPLEFT", unit.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
    ohpb:SetPoint("BOTTOMLEFT", unit.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
    ohpb:Width(config.width)
    ohpb:SetStatusBarTexture(normTex)
    ohpb:SetStatusBarColor(0, 1, 0, 0.25)

    local absb = CreateFrame("StatusBar", nil, unit.Health)
    absb:SetPoint("TOPLEFT", unit.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
    absb:SetPoint("BOTTOMLEFT", unit.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
    absb:Width(config.width)
    absb:SetStatusBarTexture(normTex)
    absb:SetStatusBarColor(0, 1, 1, 0.25)
    
    absb:SetFrameLevel(unit.Health:GetFrameLevel())
    ohpb:SetFrameLevel(absb:GetFrameLevel() + 1)
    mhpb:SetFrameLevel(absb:GetFrameLevel() + 2)
    
    unit.HealPrediction = {
        myBar = mhpb,
        otherBar = ohpb,
        absBar = absb,
        maxOverflow = 1,
    }
end

function Tukui_Raid_Healbot.createRoleIconWatch(unit, config)
    local RoleIcon = unit.Health:CreateTexture(nil, "OVERLAY")
    RoleIcon:Height(config.height)
    RoleIcon:Width(config.width)
    RoleIcon:SetPoint(config.anchor)     
    unit.LFDRole = RoleIcon
end

function Tukui_Raid_Healbot.Shared(unitframe, unit) 
    unitframe.colors = T.oUF_colors
    unitframe:RegisterForClicks("AnyUp")
    unitframe:SetScript('OnEnter', UnitFrame_OnEnter)
    unitframe:SetScript('OnLeave', UnitFrame_OnLeave)
    
    unitframe.menu = T.SpawnMenu
    
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
    
    if Tukui_Raid_Healbot.unitspecific[T.myclass] then
        Tukui_Raid_Healbot.unitspecific[T.myclass](unitframe)
    end
    
    return unitframe
end

oUF:RegisterStyle('TukuiJericho', Tukui_Raid_Healbot.Shared)
oUF:Factory(function(self)
    oUF:SetActiveStyle("TukuiJericho")    
    
    local raid = self:SpawnHeader("TukuiGrid", nil, "raid,party,solo",
        'oUF-initialConfigFunction', [[
            local header = self:GetParent()
            self:SetWidth(header:GetAttribute('initial-width'))
            self:SetHeight(header:GetAttribute('initial-height'))
        ]],
        -- attributes
        "point", "TOP",
        "xoffset", T.Scale(3),
        "yOffset", T.Scale(-3),
        "maxColumns", 5,
        "unitsPerColumn", 5,
        "columnSpacing", T.Scale(3),
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
    )
    raid:SetPoint(unpack(config.anchor))
end)