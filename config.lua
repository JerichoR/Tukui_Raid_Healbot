local ADDON_NAME, ns = ...
local T, C, L, G = unpack(Tukui) -- Import: T - functions, constants, variables; C - config; L - locales; G - Globals

ns.Tukui_Raid_Healbot = {}
_G.Tukui_Raid_Healbot = ns.Tukui_Raid_Healbot

ns.config = {
	font = C.media.font,
	normTex = C.media.normTex,
	raidicons = "Interface\\AddOns\\Tukui\\medias\\textures\\raidicons.blp",
	backdrop = {
		bgFile = C.media.normTex,
		insets = {top = -T.mult, left = -T.mult, bottom = -T.mult, right = -T.mult},
	},
	backdropcolor = C.media.backdropcolor,

    showPlayer = true,
    showSolo = true,
    showParty = true,
    showRaid = true,
    width = 138,
    height = 41,
	anchor = { "TOPLEFT", TukuiTarget, "TOP", 0, 450 },
    
    health = { 
		width = 138, height=34, 
		fontsize=12, 
		showsmooth=true 
	},
    power = { 
		width=138, height=7 
	},
    raidicon = { 
		width=18, height=18, 
		anchor="BOTTOMLEFT" 
	},
    readycheck = { 
		width=12, height=12, 
		anchor="CENTER" 
	},
    debuff = {},
    aura = { 
		width=14, height=14 
	},
    roleicon = { 
		width=10, height=10, 
		anchor="TOPLEFT" 
	},
    range = { 
		insideAlpha = 1, outsideAlpha = 0.5 
	}, 
}