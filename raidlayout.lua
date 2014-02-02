local ADDON_NAME, ns = ...
local oUF = oUFTukui or oUF
assert(oUF, "Tukui was unable to locate oUF install.")

local T = select(1, unpack(Tukui)) -- Import: T - functions, constants, variables; C - config; L - locales

local font = ns.font
local texture = ns.texture
local color = ns.color
local config = ns.config

local backdrop = {
    bgFile = texture.blank,
    insets = {top = -T.mult, left = -T.mult, bottom = -T.mult, right = -T.mult},
}

local function createHealth(unit, config)
    local health = CreateFrame("StatusBar", nil, unit)
    health:SetPoint("TOPLEFT")
    health:SetPoint("TOPRIGHT")
    health:Height(config.height)
    health:SetStatusBarTexture(texture.norm)
    health:SetStatusBarColor(.2, .2, .2, 1)
    
    local bg = health:CreateTexture(nil, "BORDER")
    bg:SetAllPoints(health)
    bg:SetTexture(texture.norm)
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
    
    health.PostUpdate = ns.PostUpdateHealth
    
    unit.Health = health
    unit.Health.bg = bg
    unit.Name = name
    unit.Health.value = value
end

local function createPower(unit, config)
    local power = CreateFrame("StatusBar", nil, unit)
    power:Point("TOPLEFT", unit.Health, "BOTTOMLEFT", 0, -1)
    power:Point("TOPRIGHT", unit.Health, "BOTTOMRIGHT", 0, -1)
    power:SetHeight(config.height)
    power:SetStatusBarTexture(texture.norm)
    
    local bg = power:CreateTexture(nil, "BORDER")
    bg:SetAllPoints(power)
    bg:SetTexture(texture.norm)
    bg:SetAlpha(1)
    bg.multiplier = 0.4
    
    power.colorDisconnected = true
    power.colorPower = true
    power.frequentUpdates = true
    
    unit.Power = power
    unit.Power.bg = bg
end

local function createDebuffWatch(unit, config)
    local dbh = unit.Health:CreateTexture(nil)
    dbh:SetAllPoints(unit.Health:GetStatusBarTexture())
    dbh:SetTexture(texture.norm)
    dbh:SetBlendMode("BLEND")
    dbh:SetVertexColor(0,0,0,0) -- set alpha to 0 to hide the texture
    unit.DebuffHighlight = dbh
    unit.DebuffHighlightAlpha = 1
    unit.DebuffHighlightFilter = true
end

local function createAuraWatch(unit, config)
    local auras = {}
    local spellIDs = ns.auras[T.myclass]
    
    if not spellIDs then return end
    
    auras.presentAlpha = 1
    auras.missingAlpha = 0
    auras.PostCreateIcon = ns.PostCreateIcon
    auras.strictMatching = false
    
    auras.icons = {}
    for sid, pos in pairs(spellIDs) do
        local icon = CreateFrame("Frame", nil, unit)
        icon.spellID = sid
        icon:SetWidth(config.width)
        icon:SetHeight(config.height)
        icon:SetPoint(pos[1], unit, pos[1], pos[2], pos[3])
        
        icon.cd = ns:newTimer(icon, {font, 12, "THINOUTLINE"}, {14, 14}, {"CENTER", "BOTTOMRIGHT", 0, 4}, 0.3, {10, 4})
        -- add function used by oUF_AuraWatch
        icon.cd.SetCooldown = function(self, starttime, duration) self:setExpiryTime(starttime + duration) end
    
        auras.icons[sid] = icon
    end
    unit.AuraWatch = auras
end

local function createRaidIconWatch(unit, config)
    local RaidIcon = unit.Health:CreateTexture(nil, "OVERLAY")
    RaidIcon:Height(config.height)
    RaidIcon:Width(config.width)
    RaidIcon:SetPoint(config.anchor)
    RaidIcon:SetTexture(texture.raidicons) -- thx hankthetank for texture
    unit.RaidIcon = RaidIcon
end

local function createReadyCheckWatch(unit, config)
    local ReadyCheck = unit.Power:CreateTexture(nil, "OVERLAY")
    ReadyCheck:Height(config.height)
    ReadyCheck:Width(config.width)
    ReadyCheck:SetPoint(config.anchor)     
    unit.ReadyCheck = ReadyCheck
end

local function createHealcomm(unit, config)
    local mhpb = CreateFrame("StatusBar", nil, unit.Health)
    mhpb:SetPoint("TOPLEFT", unit.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
    mhpb:SetPoint("BOTTOMLEFT", unit.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
    mhpb:Width(config.width)
    mhpb:SetStatusBarTexture(texture.norm)
    mhpb:SetStatusBarColor(0, 1, 0.5, 0.25)

    local ohpb = CreateFrame("StatusBar", nil, unit.Health)
    ohpb:SetPoint("TOPLEFT", unit.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
    ohpb:SetPoint("BOTTOMLEFT", unit.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
    ohpb:Width(config.width)
    ohpb:SetStatusBarTexture(texture.norm)
    ohpb:SetStatusBarColor(0, 1, 0, 0.25)

    local absb = CreateFrame("StatusBar", nil, unit.Health)
    absb:SetPoint("TOPLEFT", unit.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
    absb:SetPoint("BOTTOMLEFT", unit.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
    absb:SetWidth(config.width)
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

local function createRoleIconWatch(unit, config)
    local RoleIcon = unit.Health:CreateTexture(nil, "OVERLAY")
    RoleIcon:Height(config.height)
    RoleIcon:Width(config.width)
    RoleIcon:SetPoint(config.anchor)     
    unit.LFDRole = RoleIcon
end

local unitspecific = {}
unitspecific.PRIEST = function(self)
    local ws = CreateFrame("StatusBar", self:GetName().."_WeakenedSoul", self.Power)
    ws:SetAllPoints(self.Power)
    ws:SetStatusBarTexture(texture.norm)
    ws:GetStatusBarTexture():SetHorizTile(false)
    ws:SetBackdrop(backdrop)
    ws:SetBackdropColor(unpack(color.backdropcolor))
    ws:SetStatusBarColor(191/255, 10/255, 10/255)
    
    self.WeakenedSoul = ws
end

local function Shared(self, unit)
    self.colors = T.oUF_colors
    self:RegisterForClicks("AnyUp")
    self:SetScript('OnEnter', UnitFrame_OnEnter)
    self:SetScript('OnLeave', UnitFrame_OnLeave)
    
    self.menu = T.SpawnMenu
    
    self:SetBackdrop({bgFile = texture.blank, insets = {top = -T.mult, left = -T.mult, bottom = -T.mult, right = -T.mult}})
    self:SetBackdropColor(0.1, 0.1, 0.1)
    
    createHealth(self, config.health)
    createPower(self, config.power)
    
    createDebuffWatch(self, config.debuff)
    createAuraWatch(self, config.aura)
    createRaidIconWatch(self, config.raidicon)
    createReadyCheckWatch(self, config.readycheck)
    createHealcomm(self, config.health)
    createRoleIconWatch(self, config.roleicon)
    
    self.Range = config.range
    
    if unitspecific[T.myclass] then
        unitspecific[T.myclass](self)
    end
    
    return self
end

oUF:RegisterStyle('TukuiJericho', Shared)
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
        "groupBy", "ROLE",
        "groupingOrder", "MAINTANK,MAINASSIST,nil",
        
        "growth", "DOWN"
    )
    raid:SetPoint(unpack(config.anchor))
end)