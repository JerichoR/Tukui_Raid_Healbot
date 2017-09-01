local _, ns = ...
local T, C, L = Tukui:unpack() 

ns.Tukui_Raid_Healbot = {}

ns.config = {
	font = T.GetFont("Calibri"),
	normTex = C.Medias.Normal,
	raidicons = "Interface\\Addons\\Tukui\\Medias\\Textures\\raidicons.blp",
	backdrop = {
		bgFile = C.Medias.Normal,
		insets = {top = 0, left = 0, bottom = 0, right = 0},
	},
	backdropcolor = C.Medias.BackdropColor,

    showPlayer = true,
    showSolo = true,
    showParty = true,
    showRaid = true,
    width = 138,
    height = 41,
	anchor = { "TOPLEFT", UIParent, "RIGHT", -700, 0 },
    
    health = { 
		width = 138, height=34, 
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