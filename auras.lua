local _, ns = ...

ns.auras = {
    PRIEST = {
		-- [SpellId] = { AnchorPoint, xOffset, yOffset, anyUnit } -- set anyUnit to true if source of spell is not the player
		--[139]    = { "TOPRIGHT", -18, -2 },   -- Renew
		[17]     = { "TOPRIGHT", -2, -2 },    -- Power Word: Shield
        [81749]  = { "BOTTOMRIGHT", -2, 9 }, -- Atonement
    },
    PALADIN = {
		[114163] = { "TOPRIGHT", -2, -2 },   -- Eternal Flame
        [223306] = { "BOTTOMRIGHT", -2, 9 },   -- Bestow Faith
    },
}
