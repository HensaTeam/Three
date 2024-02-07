fx_version "bodacious"
game "gta5"

ui_page "gui/index.html"

server_scripts {
	"lib/utils.lua",
	"base.lua",
	"queue.lua",
	"modules/gui.lua",
	"modules/group.lua",
	"modules/drugs.lua",
	"modules/player_state.lua",
	"modules/map.lua",
	"modules/garages.lua",
	"modules/money.lua",
	"modules/inventory.lua",
	"modules/identity.lua",
	"modules/experience.lua",
	"modules/prepares.lua"
}

client_scripts {
	"lib/utils.lua",
	"client/base.lua",
	"client/garages.lua",
	"client/iplloader.lua",
	"client/gui.lua",
	"client/player_state.lua",
	"client/map.lua",
	"client/police.lua"
}

files {
	"loading/index.html",
	"loading/video.mp4",
	"loading/style.css",
	"lib/Tunnel.lua",
	"lib/Proxy.lua",
	"lib/Luaseq.lua",
	"lib/Tools.lua",
	"gui/index.html",
	"gui/design.css",
	"gui/main.js",
	"gui/WPrompt.js",
	"gui/RequestManager.js",
	"gui/dynamic_classes.js"
}

loadscreen "loading/index.html"