local _, ns = ...

ns.auras = {
    PRIEST = {
		-- [SpellId] = { AnchorPoint, xOffset, yOffset, anyUnit } -- set anyUnit to true if source of spell is not the player
		--[139]    = { "TOPRIGHT", -18, -2 },   -- Renew
		[17]     = { "TOPRIGHT", -2, -2 },    -- Power Word: Shield
        [41635]  = { "BOTTOMRIGHT", -18, 9 }, -- Prayer of Mending
		[47753]  = { "BOTTOMRIGHT", -2, 9 },  -- Divine Aegis
    },
    PALADIN = {
		[114163] = { "TOPRIGHT", -18, -2 },   -- Eternal Flame
        [53563]  = { "TOPRIGHT", -2, -2 },    -- Beacon of Light
    },
}
