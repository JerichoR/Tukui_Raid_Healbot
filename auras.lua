local ADDON_NAME, ns = ...

ns.auras = {
    PRIEST = {
        [139] = { "BOTTOMRIGHT", -2, 9 }, -- Renew
        [41635] = { "BOTTOMRIGHT", -18, 9 }, -- Prayer of Mending
        [17] = { "TOPRIGHT", -2, -2 }, -- Power Word: Shield
    },
    PALADIN = {
        [53563] = { "TOPRIGHT", -2, -2 }, -- Beacon of Light
        [86273] = { "BOTTOMRIGHT", -2, 9 }, -- Illuminated Healing
    },
}
