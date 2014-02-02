local ADDON_NAME, ns = ...

local _, C, _ = unpack(Tukui) -- Import: T - functions, constants, variables; C - config; L - locales

ns.font = C.media.font

ns.texture = {
	norm = C.media.normTex,
	blank = C.media.blank,
	raidicons = "Interface\\AddOns\\Tukui\\medias\\textures\\raidicons.blp"
}

ns.color = {
	backdropcolor = C.media.backdropcolor
}

ns.config = {
    showPlayer = true,
    showSolo = true,
    showParty = true,
    showRaid = true,
    width = 138,
    height = 41,
	anchor = { "TOPLEFT", TukuiTarget, "TOP", 0, 450 },
    
    health = { width=138, height=34, fontsize=12, showsmooth=true },
    power = { width=138, height=7 },
    raidicon = { width=18, height=18, anchor="BOTTOMLEFT" },
    readycheck = { width=12, height=12, anchor="CENTER" },
    debuff = {},
    aura = { width=14, height=14 },
    roleicon = { width=10, height=10, anchor="TOPLEFT" },
    range = { insideAlpha = 1, outsideAlpha = 0.5 }, 
}