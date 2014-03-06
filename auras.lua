local ADDON_NAME, ns = ...

ns.auras = {
    PRIEST = {
		-- [SpellId] = { AnchorPoint, xOffset, yOffset, anyUnit } -- set anyUnit to true if source of spell is not the player
		[142865] = { "TOPRIGHT", -18, -2, true },   -- Strong Ancient Barrier => green
		[142864] = { "TOPRIGHT", -18, -2, true },   -- Ancient Barrier => yellow
		[142863] = { "TOPRIGHT", -18, -2, true },   -- Weak Ancient Barrier => red
		
        [139]    = { "BOTTOMRIGHT", -2, 9 },  -- Renew
        [41635]  = { "BOTTOMRIGHT", -18, 9 }, -- Prayer of Mending
        [17]     = { "TOPRIGHT", -2, -2 },    -- Power Word: Shield
    },
    PALADIN = {
		[142865] = { "TOPRIGHT", -18, -2, true },   -- Strong Ancient Barrier => green
		[142864] = { "TOPRIGHT", -18, -2, true },   -- Ancient Barrier => yellow
		[142863] = { "TOPRIGHT", -18, -2, true },   -- Weak Ancient Barrier => red
		
        [53563]  = { "TOPRIGHT", -2, -2 },    -- Beacon of Light
        [86273]  = { "BOTTOMRIGHT", -2, 9 },  -- Illuminated Healing
    },
}
