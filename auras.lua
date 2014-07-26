local ADDON_NAME, ns = ...

ns.auras = {
    PRIEST = {
		-- [SpellId] = { AnchorPoint, xOffset, yOffset, anyUnit } -- set anyUnit to true if source of spell is not the player
		[142865] = { "BOTTOMRIGHT", -2, 9, true },  -- Strong Ancient Barrier => green
		[142864] = { "BOTTOMRIGHT", -2, 9, true },  -- Ancient Barrier => yellow
		[142863] = { "BOTTOMRIGHT", -2, 9, true },  -- Weak Ancient Barrier => red
		
		[139]    = { "TOPRIGHT", -18, -2 },   -- Renew
		[17]     = { "TOPRIGHT", -2, -2 },    -- Power Word: Shield
        [41635]  = { "BOTTOMRIGHT", -18, 9 }, -- Prayer of Mending
		[47753]  = { "BOTTOMRIGHT", -2, 9 },  -- Divine Aegis
    },
    PALADIN = {
		[142865] = { "BOTTOMRIGHT", -2, 9, true },  -- Strong Ancient Barrier => green
		[142864] = { "BOTTOMRIGHT", -2, 9, true },  -- Ancient Barrier => yellow
		[142863] = { "BOTTOMRIGHT", -2, 9, true },  -- Weak Ancient Barrier => red
		
        [53563]  = { "TOPRIGHT", -2, -2 },    -- Beacon of Light
        [86273]  = { "BOTTOMRIGHT", -2, 9 },  -- Illuminated Healing
    },
}
