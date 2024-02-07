-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local itemlist = {
	["bonusDelivery"] = {
		index = "bonusDelivery",
		name = "+ Tacos",
		type = "use",
		weight = 0.5
	},
	["bonusPostOp"] = {
		index = "bonusPostOp",
		name = "+ Entregador",
		type = "use",
		weight = 0.5
	},
	["radio"] = {
		index = "radio",
		name = "Rádio",
		type = "use",
		weight = 1.0
	},
	["vest"] = {
		index = "vest",
		name = "Colete",
		type = "use",
		weight = 5.0
	},
	["bandage"] = {
		index = "bandage",
		name = "Bandagem",
		type = "use",
		weight = 0.5
	},
	["warfarin"] = {
		index = "warfarin",
		name = "Kit Médico",
		type = "use",
		weight = 0.5
	},
	["adrenaline"] = {
		index = "adrenaline",
		name = "Adrenalina",
		type = "use",
		weight = 0.6
	},
	["raceticket"] = {
		index = "raceticket",
		name = "Ticket de Corrida",
		type = "use",
		weight = 0.2
	},
	["pouch"] = {
		index = "pouch",
		name = "Malote",
		type = "use",
		weight = 0.5
	},
	["woodlog"] = {
		index = "woodlog",
		name = "Tora de Madeira",
		type = "use",
		weight = 0.5
	},
	["fishingrod"] = {
		index = "fishingrod",
		name = "Vara de Pescar",
		type = "use",
		weight = 3.0
	},
	["octopus"] = {
		index = "octopus",
		name = "Polvo",
		type = "use",
		weight = 0.6
	},
	["shrimp"] = {
		index = "shrimp",
		name = "Camarão",
		type = "use",
		weight = 0.4
	},
	["carp"] = {
		index = "carp",
		name = "Carpa",
		type = "use",
		weight = 0.5
	},
	["bait"] = {
		index = "bait",
		name = "Isca",
		type = "use",
		weight = 0.3
	},
	["bucket"] = {
		index = "bucket",
		name = "Balde",
		type = "use",
		weight = 1.0
	},
	["compost"] = {
		index = "compost",
		name = "Adubo",
		type = "use",
		weight = 0.3
	},
	["weed"] = {
		index = "weed",
		name = "Maconha",
		type = "use",
		weight = 0.3
	},
	["joint"] = {
		index = "joint",
		name = "Baseado",
		type = "use",
		weight = 0.3
	},
	["lean"] = {
		index = "lean",
		name = "Lean",
		type = "use",
		weight = 0.2
	},
	["ecstasy"] = {
		index = "ecstasy",
		name = "Ecstasy",
		type = "use",
		weight = 0.2
	},
	["cocaine"] = {
		index = "cocaine",
		name = "Cocaina",
		type = "use",
		weight = 0.2
	},
	["meth"] = {
		index = "meth",
		name = "Metanfetamina",
		type = "use",
		weight = 0.4
	},
	["methliquid"] = {
		index = "methliquid",
		name = "Meta Líquida",
		type = "use",
		weight = 0.4
	},
	["silk"] = {
		index = "silk",
		name = "Seda",
		type = "use",
		weight = 0.3
	},
	["backpackp"] = {
		index = "backpackp",
		name = "Mochila P",
		type = "use",
		weight = 1.0
	},
	["backpackm"] = {
		index = "backpackm",
		name = "Mochila M",
		type = "use",
		weight = 2.0
	},
	["backpackg"] = {
		index = "backpackg",
		name = "Mochila G",
		type = "use",
		weight = 3.0
	},
	["backpackx"] = {
		index = "backpackx",
		name = "Mochila X",
		type = "use",
		weight = 4.0
	},
	["premium01"] = {
		index = "premium01",
		name = "Premium 3D",
		type = "use",
		weight = 0.0
	},
	["premium02"] = {
		index = "premium02",
		name = "Premium 7D",
		type = "use",
		weight = 0.0
	},
	["premium03"] = {
		index = "premium03",
		name = "Premium 15D",
		type = "use",
		weight = 0.0
	},
	["premium04"] = {
		index = "premium04",
		name = "Premium 30D",
		type = "use",
		weight = 0.0
	},
	["energetic"] = {
		index = "energetic",
		name = "Energético",
		type = "use",
		weight = 0.5
	},
	["delivery"] = {
		index = "delivery",
		name = "Pacote",
		type = "use",
		weight = 2.5
	},
	["paperbag"] = {
		index = "paperbag",
		name = "Saco de Papel",
		type = "use",
		weight = 3.0
	},
	["water"] = {
		index = "water",
		name = "Água",
		type = "use",
		weight = 0.4
	},
	["dirtywater"] = {
		index = "dirtywater",
		name = "Água Suja",
		type = "use",
		weight = 0.3
	},
	["emptybottle"] = {
		index = "emptybottle",
		name = "Garrafa Vazia",
		type = "use",
		weight = 0.2
	},
	["coffee"] = {
		index = "coffee",
		name = "Café",
		type = "use",
		weight = 0.3
	},
	["cola"] = {
		index = "cola",
		name = "Coca-Cola",
		type = "use",
		weight = 0.3
	},
	["tacos"] = {
		index = "tacos",
		name = "Tacos",
		type = "use",
		weight = 0.5
	},
	["fries"] = {
		index = "fries",
		name = "Fritas",
		type = "use",
		weight = 0.3
	},
	["soda"] = {
		index = "soda",
		name = "Soda",
		type = "use",
		weight = 0.3
	},
	["hamburger"] = {
		index = "hamburger",
		name = "Hamburger",
		type = "use",
		weight = 0.5
	},
	["hotdog"] = {
		index = "hotdog",
		name = "Cachorro-Quente",
		type = "use",
		weight = 0.3
	},
	["donut"] = {
		index = "donut",
		name = "Rosquinha",
		type = "use",
		weight = 0.2
	},
	["plate"] = {
		index = "plate",
		name = "Placa",
		type = "use",
		weight = 5.0
	},
	["premiumplate"] = {
		index = "plate",
		name = "Placa Premium",
		type = "use",
		weight = 5.0
	},
	["lockpick"] = {
		index = "lockpick",
		name = "Lockpick",
		type = "use",
		weight = 5.0
	},
	["toolbox"] = {
		index = "toolbox",
		name = "Caixa de Ferramentas",
		type = "use",
		weight = 5.0
	},
	["postit"] = {
		index = "postit",
		name = "Bloco de Notas",
		type = "use",
		weight = 0.1
	},
	["tires"] = {
		index = "tires",
		name = "Pneus",
		type = "use",
		weight = 2.0
	},
	["cellphone"] = {
		index = "cellphone",
		name = "Telefone",
		type = "use",
		weight = 1.0
	},
	["divingsuit"] = {
		index = "divingsuit",
		name = "Roupa de Mergulho",
		type = "use",
		weight = 5.0
	},
	["handcuff"] = {
		index = "handcuff",
		name = "Algemas",
		type = "use",
		weight = 0.75
	},
	["rope"] = {
		index = "rope",
		name = "Cordas",
		type = "use",
		weight = 1.5
	},
	["hood"] = {
		index = "hood",
		name = "Capuz",
		type = "use",
		weight = 1.5
	},
	["plastic"] = {
		index = "plastic",
		name = "Plástico",
		type = "use",
		weight = 0.05
	},
	["glass"] = {
		index = "glass",
		name = "Vidro",
		type = "use",
		weight = 0.1
	},
	["rubber"] = {
		index = "rubber",
		name = "Borracha",
		type = "use",
		weight = 0.05
	},
	["aluminum"] = {
		index = "aluminum",
		name = "Alúminio",
		type = "use",
		weight = 0.10
	},
	["copper"] = {
		index = "copper",
		name = "Cobre",
		type = "use",
		weight = 0.10
	},
	["eletronics"] = {
		index = "eletronics",
		name = "Eletrônico",
		type = "use",
		weight = 0.01
	},
	["notebook"] = {
		index = "notebook",
		name = "Notebook",
		type = "use",
		weight = 2.0
	},
	["keyboard"] = {
		index = "keyboard",
		name = "Teclado",
		type = "use",
		weight = 0.4
	},
	["mouse"] = {
		index = "mouse",
		name = "Mouse",
		type = "use",
		weight = 0.2
	},
	["ring"] = {
		index = "ring",
		name = "Anel",
		type = "use",
		weight = 0.1
	},
	["watch"] = {
		index = "watch",
		name = "Relógio",
		type = "use",
		weight = 0.3
	},
	["c4"] = {
		index = "c4",
		name = "C4",
		type = "use",
		weight = 3.0
	},
	["ritmoneury"] = {
		index = "ritmoneury",
		name = "Ritmoneury",
		type = "use",
		weight = 0.3
	},
	["sinkalmy"] = {
		index = "sinkalmy",
		name = "Sinkalmy",
		type = "use",
		weight = 0.3
	},
	["cigarette"] = {
		index = "cigarette",
		name = "Cigarro",
		type = "use",
		weight = 0.1
	},
	["lighter"] = {
		index = "lighter",
		name = "Isqueiro",
		type = "use",
		weight = 0.3
	},
	["vape"] = {
		index = "vape",
		name = "Vape",
		type = "use",
		weight = 0.8
	},
	["dollars"] = {
		index = "dollars",
		name = "Dinheiro",
		type = "use",
		weight = 0.0002
	},
	["dollars2"] = {
		index = "dollars2",
		name = "Rolo de Dinheiro",
		type = "use",
		weight = 0.0100
	},
	["blackcard"] = {
		index = "blackcard",
		name = "Cartão Preto",
		type = "use",
		weight = 0.1
	},
	["bluecard"] = {
		index = "bluecard",
		name = "Cartão Azul",
		type = "use",
		weight = 0.1
	},
	["chocolate"] = {
		index = "chocolate",
		name = "Chocolate",
		type = "use",
		weight = 0.2
	},
	["sandwich"] = {
		index = "sandwich",
		name = "Sanduiche",
		type = "use",
		weight = 0.2
	},
	["rose"] = {
		index = "rose",
		name = "Rosa",
		type = "use",
		weight = 0.1
	},
	["teddy"] = {
		index = "teddy",
		name = "Teddy",
		type = "use",
		weight = 0.8
	},
	["absolut"] = {
		index = "absolut",
		name = "Absolut",
		type = "use",
		weight = 0.2
	},
	["chandon"] = {
		index = "chandon",
		name = "Chandon",
		type = "use",
		weight = 0.2
	},
	["dewars"] = {
		index = "dewars",
		name = "Dewars",
		type = "use",
		weight = 0.2
	},
	["hennessy"] = {
		index = "hennessy",
		name = "Hennessy",
		type = "use",
		weight = 0.2
	},
	["identity"] = {
		index = "identity",
		name = "Identidade",
		type = "use",
		weight = 0.2
	},
	["goldbar"] = {
		index = "goldbar",
		name = "Barra de Ouro",
		type = "use",
		weight = 1.0
	},
	["binoculars"] = {
		index = "binoculars",
		name = "Binóculos",
		type = "use",
		weight = 1.0
	},
	["camera"] = {
		index = "camera",
		name = "Câmera",
		type = "use",
		weight = 2.5
	},
	["playstation"] = {
		index = "playstation",
		name = "Playstation",
		type = "use",
		weight = 2.0
	},
	["xbox"] = {
		index = "xbox",
		name = "Xbox",
		type = "use",
		weight = 2.0
	},
	["legos"] = {
		index = "legos",
		name = "Legos",
		type = "use",
		weight = 0.1
	},
	["ominitrix"] = {
		index = "ominitrix",
		name = "Ominitrix",
		type = "use",
		weight = 0.5
	},
	["bracelet"] = {
		index = "bracelet",
		name = "Bracelete",
		type = "use",
		weight = 0.2
	},
	["dildo"] = {
		index = "dildo",
		name = "Vibrador",
		type = "use",
		weight = 0.3
	},
	["WEAPON_KNIFE"] = {
		index = "knife",
		name = "Faca",
		type = "equip",
		weight = 0.50
	},
	["WEAPON_HATCHET"] = {
		index = "hatchet",
		name = "Machado",
		type = "equip",
		weight = 0.75
	},
	["WEAPON_BAT"] = {
		index = "bat",
		name = "Bastão de Beisebol",
		type = "equip",
		weight = 0.75
	},
	["WEAPON_BATTLEAXE"] = {
		index = "battleaxe",
		name = "Machado de Batalha",
		type = "equip",
		weight = 0.75
	},
	["WEAPON_BOTTLE"] = {
		index = "bottle",
		name = "Garrafa",
		type = "equip",
		weight = 0.75
	},
	["WEAPON_CROWBAR"] = {
		index = "crowbar",
		name = "Pé de Cabra",
		type = "equip",
		weight = 0.75
	},
	["WEAPON_DAGGER"] = {
		index = "dagger",
		name = "Adaga",
		type = "equip",
		weight = 0.50
	},
	["WEAPON_GOLFCLUB"] = {
		index = "golfclub",
		name = "Taco de Golf",
		type = "equip",
		weight = 0.75
	},
	["WEAPON_HAMMER"] = {
		index = "hammer",
		name = "Martelo",
		type = "equip",
		weight = 0.75
	},
	["WEAPON_MACHETE"] = {
		index = "machete",
		name = "Facão",
		type = "equip",
		weight = 0.75
	},
	["WEAPON_POOLCUE"] = {
		index = "poolcue",
		name = "Taco de Sinuca",
		type = "equip",
		weight = 0.75
	},
	["WEAPON_STONE_HATCHET"] = {
		index = "stonehatchet",
		name = "Machado de Pedra",
		type = "equip",
		weight = 0.75
	},
	["WEAPON_SWITCHBLADE"] = {
		index = "switchblade",
		name = "Canivete",
		type = "equip",
		weight = 0.50
	},
	["WEAPON_WRENCH"] = {
		index = "wrench",
		name = "Chave Inglesa",
		type = "equip",
		weight = 0.75
	},
	["WEAPON_KNUCKLE"] = {
		index = "knuckle",
		name = "Soco Inglês",
		type = "equip",
		weight = 0.50
	},
	["WEAPON_FLASHLIGHT"] = {
		index = "flashlight",
		name = "Lanterna",
		type = "equip",
		weight = 0.50
	},
	["WEAPON_NIGHTSTICK"] = {
		index = "nightstick",
		name = "Cassetete",
		type = "equip",
		weight = 0.75
	},
	["WEAPON_PISTOL"] = {
		index = "m1911",
		name = "M1911",
		type = "equip",
		ammo = "WEAPON_PISTOL_AMMO",
		weight = 1.25
	},
	["WEAPON_PISTOL_MK2"] = {
		index = "fiveseven",
		name = "FN Five Seven",
		type = "equip",
		ammo = "WEAPON_PISTOL_AMMO",
		weight = 1.50
	},
	["WEAPON_COMPACTRIFLE"] = {
		index = "akcompact",
		name = "AK Compact",
		type = "equip",
		ammo = "WEAPON_SMG_AMMO",
		weight = 2.25
	},
	["WEAPON_APPISTOL"] = {
		index = "kochvp9",
		name = "Koch Vp9",
		type = "equip",
		ammo = "WEAPON_PISTOL_AMMO",
		weight = 1.25
	},
	["WEAPON_HEAVYPISTOL"] = {
		index = "atifx45",
		name = "Ati FX45",
		type = "equip",
		ammo = "WEAPON_PISTOL_AMMO",
		weight = 1.50
	},
	["WEAPON_MACHINEPISTOL"] = {
		index = "tec9",
		name = "Tec-9",
		type = "equip",
		ammo = "WEAPON_SMG_AMMO",
		weight = 1.75
	},
	["WEAPON_MICROSMG"] = {
		index = "uzi",
		name = "Uzi",
		type = "equip",
		ammo = "WEAPON_SMG_AMMO",
		weight = 1.25
	},
	["WEAPON_MINISMG"] = {
		index = "skorpionv61",
		name = "Skorpion V61",
		type = "equip",
		ammo = "WEAPON_SMG_AMMO",
		weight = 1.75
	},
	["WEAPON_SNSPISTOL"] = {
		index = "amt380",
		name = "AMT 380",
		type = "equip",
		ammo = "WEAPON_PISTOL_AMMO",
		weight = 1.0
	},
	["WEAPON_SNSPISTOL_MK2"] = {
		index = "hkp7m10",
		name = "HK P7M10",
		type = "equip",
		ammo = "WEAPON_PISTOL_AMMO",
		weight = 1.0
	},
	["WEAPON_VINTAGEPISTOL"] = {
		index = "m1922",
		name = "M1922",
		type = "equip",
		ammo = "WEAPON_PISTOL_AMMO",
		weight = 1.0
	},
	["WEAPON_PISTOL50"] = {
		index = "desert",
		name = "Desert Eagle",
		type = "equip",
		ammo = "WEAPON_PISTOL_AMMO",
		weight = 1.50
	},
	["WEAPON_REVOLVER"] = {
		index = "magnum",
		name = "Magnum 44",
		type = "equip",
		ammo = "WEAPON_PISTOL_AMMO",
		weight = 1.50
	},
	["WEAPON_COMBATPISTOL"] = {
		index = "glock",
		name = "Glock",
		type = "equip",
		ammo = "WEAPON_PISTOL_AMMO",
		weight = 1.0
	},
	["WEAPON_CARBINERIFLE"] = {
		index = "m4a1",
		name = "M4A1",
		type = "equip",
		ammo = "WEAPON_RIFLE_AMMO",
		weight = 8.0
	},
	["WEAPON_PUMPSHOTGUN"] = {
		index = "remington",
		name = "Remington",
		type = "equip",
		ammo = "WEAPON_SHOTGUN_AMMO",
		weight = 6.0
	},
	["WEAPON_SAWNOFFSHOTGUN"] = {
		index = "mossberg590",
		name = "Mossberg 590",
		type = "equip",
		ammo = "WEAPON_SHOTGUN_AMMO",
		weight = 6.0
	},
	["WEAPON_SMG"] = {
		index = "mp5",
		name = "MP5",
		type = "equip",
		ammo = "WEAPON_SMG_AMMO",
		weight = 4.0
	},
	["WEAPON_ASSAULTRIFLE"] = {
		index = "ak103",
		name = "AK-103",
		type = "equip",
		ammo = "WEAPON_RIFLE_AMMO",
		weight = 8.0
	},
	["WEAPON_ASSAULTRIFLE_MK2"] = {
		index = "ak74",
		name = "AK-74",
		type = "equip",
		ammo = "WEAPON_RIFLE_AMMO",
		weight = 8.0
	},
	["WEAPON_ASSAULTSMG"] = {
		index = "mtar21",
		name = "MTAR-21",
		type = "equip",
		ammo = "WEAPON_SMG_AMMO",
		weight = 5.0
	},
	["WEAPON_GUSENBERG"] = {
		index = "thompson",
		name = "Thompson",
		type = "equip",
		ammo = "WEAPON_SMG_AMMO",
		weight = 6.0
	},
	["WEAPON_PETROLCAN"] = {
		index = "gallon",
		name = "Galão",
		type = "equip",
		ammo = "WEAPON_PETROLCAN_AMMO",
		weight = 1.25
	},
	["GADGET_PARACHUTE"] = {
		index = "parachute",
		name = "Paraquedas",
		type = "use",
		weight = 2.25
	},
	["WEAPON_STUNGUN"] = {
		index = "stungun",
		name = "Tazer",
		type = "equip",
		weight = 0.75
	},
	["WEAPON_FIREEXTINGUISHER"] = {
		index = "extinguisher",
		name = "Extintor",
		type = "equip",
		weight = 2.25
	},
	["WEAPON_PISTOL_AMMO"] = {
		index = "pistolammo",
		name = "M. Pistola",
		type = "recharge",
		weight = 0.02
	},
	["WEAPON_SMG_AMMO"] = {
		index = "smgammo",
		name = "M. Sub Metralhadora",
		type = "recharge",
		weight = 0.03
	},
	["WEAPON_RIFLE_AMMO"] = {
		index = "rifleammo",
		name = "M. Rifle",
		type = "recharge",
		weight = 0.04
	},
	["WEAPON_SHOTGUN_AMMO"] = {
		index = "shotgunammo",
		name = "M. Escopeta",
		type = "recharge",
		weight = 0.05
	},
	["WEAPON_PETROLCAN_AMMO"] = {
		index = "fuel",
		name = "Combustível",
		type = "recharge",
		weight = 0.001
	},
	["pager"] = {
		index = "pager",
		name = "Pager",
		type = "use",
		weight = 1.0
	},
	["firecracker"] = {
		index = "firecracker",
		name = "Fogos de Artificio",
		type = "use",
		weight = 2.0
	},
	["analgesic"] = {
		index = "analgesic",
		name = "Analgésico",
		type = "use",
		weight = 0.20
	},
	["gauze"] = {
		index = "gauze",
		name = "Gaze",
		type = "use",
		weight = 0.20
	},
	["gsrkit"] = {
		index = "gsrkit",
		name = "Kit Residual",
		type = "use",
		weight = 0.75
	},
	["gdtkit"] = {
		index = "gdtkit",
		name = "Kit Químico",
		type = "use",
		weight = 0.75
	},
	["fueltech"] = {
		index = "fueltech",
		name = "Fueltech",
		type = "use",
		weight = 3.00
	},
	["cpuchip"] = {
		index = "cpuchip",
		name = "Processador",
		type = "use",
		weight = 0.75
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATE:ADVTOOLBOX
-----------------------------------------------------------------------------------------------------------------------------------------
for i = 1,99 do
	itemlist["toolboxes"..i] = {
		index = "toolbox",
		name = "+ Caixa de Ferramentas",
		type = "use",
		weight = 5.0
	}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMBODYLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.itemBodyList(item)
	if itemlist[item] then
		return itemlist[item]
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMINDEXLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.itemIndexList(item)
	if itemlist[item] then
		return itemlist[item].index
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMNAMELIST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.itemNameList(item)
	if itemlist[item] then
		return itemlist[item].name
	end
	return "Deleted"
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMTYPELIST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.itemTypeList(item)
	if itemlist[item] then
		return itemlist[item].type
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMAMMOLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.itemAmmoList(item)
	if itemlist[item] then
		return itemlist[item].ammo
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMWEIGHTLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.itemWeightList(item)
	if itemlist[item] then
		return itemlist[item].weight
	end
	return 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMPUTEINVWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.computeInvWeight(user_id)
	local weight = 0
	local inventory = vRP.getInventory(user_id)
	if inventory then
		for k,v in pairs(inventory) do
			if vRP.itemBodyList(v.item) then
				weight = weight + vRP.itemWeightList(v.item) * parseInt(v.amount)
			end
		end
		return weight
	end
	return 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMPUTECHESTWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.computeChestWeight(items)
	local weight = 0
	for k,v in pairs(items) do
		if vRP.itemBodyList(k) then
			weight = weight + vRP.itemWeightList(k) * parseInt(v.amount)
		end
	end
	return weight
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETINVENTORYITEMAMOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getInventoryItemAmount(user_id,idname)
	local data = vRP.getInventory(user_id)
	if data then
		for k,v in pairs(data) do
			if v.item == idname then
				return parseInt(v.amount)
			end
		end
	end
	return 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SWAPSLOT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.swapSlot(user_id,slot,target)
	local data = vRP.getInventory(user_id)
	if data then
		local temp = data[tostring(slot)]
		data[tostring(slot)] = data[tostring(target)]
		data[tostring(target)] = temp
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GIVEINVENTORYITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.giveInventoryItem(user_id,idname,amount,notify,slot)
	local data = vRP.getInventory(user_id)
	if data and parseInt(amount) > 0 then
		if not slot then
			local initial = 0
			repeat
				initial = initial + 1
			until data[tostring(initial)] == nil or (data[tostring(initial)] and data[tostring(initial)].item == idname)
			initial = tostring(initial)
			
			if data[initial] == nil then
				data[initial] = { item = idname, amount = parseInt(amount) }
			elseif data[initial] and data[initial].item == idname then
				data[initial].amount = parseInt(data[initial].amount) + parseInt(amount)
			end

			if notify and vRP.itemBodyList(idname) then
				TriggerClientEvent("itensNotify",vRP.getUserSource(user_id),{ "+",vRP.itemIndexList(idname),vRP.format(parseInt(amount)),vRP.itemNameList(idname) })
			end
		else
			slot = tostring(slot)

			if data[slot] then
				if data[slot].item == idname then
					local oldAmount = parseInt(data[slot].amount)
					data[slot] = { item = idname, amount = parseInt(oldAmount) + parseInt(amount) }
				end
			else
				data[slot] = { item = idname, amount = parseInt(amount) }
			end

			if notify and vRP.itemBodyList(idname) then
				TriggerClientEvent("itensNotify",vRP.getUserSource(user_id),{ "+",vRP.itemIndexList(idname),vRP.format(parseInt(amount)),vRP.itemNameList(idname) })
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYGETINVENTORYITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.tryGetInventoryItem(user_id,idname,amount,notify,slot)
	local data = vRP.getInventory(user_id)
	if data then
		if not slot then
			for k,v in pairs(data) do
				if v.item == idname and parseInt(v.amount) >= parseInt(amount) then
					v.amount = parseInt(v.amount) - parseInt(amount)

					if parseInt(v.amount) <= 0 then
						data[k] = nil
					end

					if notify and vRP.itemBodyList(idname) then
						TriggerClientEvent("itensNotify",vRP.getUserSource(user_id),{ "-",vRP.itemIndexList(idname),vRP.format(parseInt(amount)),vRP.itemNameList(idname) })
					end
					return true
				end
			end
		else
			local slot  = tostring(slot)

			if data[slot] and data[slot].item == idname and parseInt(data[slot].amount) >= parseInt(amount) then
				data[slot].amount = parseInt(data[slot].amount) - parseInt(amount)

				if parseInt(data[slot].amount) <= 0 then
					data[slot] = nil
				end

				if notify and vRP.itemBodyList(idname) then
					TriggerClientEvent("itensNotify",vRP.getUserSource(user_id),{ "-",vRP.itemIndexList(idname),vRP.format(parseInt(amount)),vRP.itemNameList(idname) })
				end
				return true
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEINVENTORYITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.removeInventoryItem(user_id,idname,amount,notify)
	local data = vRP.getInventory(user_id)
	if data then
		for k,v in pairs(data) do
			if v.item == idname and parseInt(v.amount) >= parseInt(amount) then
				v.amount = parseInt(v.amount) - parseInt(amount)

				if parseInt(v.amount) <= 0 then
					data[k] = nil
				end

				if notify and vRP.itemBodyList(idname) then
					TriggerClientEvent("itensNotify",vRP.getUserSource(user_id),{ "-",vRP.itemIndexList(idname),vRP.format(parseInt(amount)),vRP.itemNameList(idname) })
				end

				break
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVED
-----------------------------------------------------------------------------------------------------------------------------------------
local actived = {}
local activedAmount = {}
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(actived) do
			if actived[k] > 0 then
				actived[k] = v - 1
				if actived[k] <= 0 then
					actived[k] = nil
				end
			end
		end
		Citizen.Wait(100)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARLOGS
-----------------------------------------------------------------------------------------------------------------------------------------
local policeLogs = " "
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYCHESTITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.tryChestItem(user_id,chestData,itemName,amount,slot)
	if actived[user_id] == nil then
		actived[user_id] = 1
		local data = vRP.getSData(chestData)
		local items = json.decode(data) or {}
		if data and items ~= nil then
			if items[itemName] ~= nil and parseInt(items[itemName].amount) >= parseInt(amount) then

				if parseInt(amount) > 0 then
					activedAmount[user_id] = parseInt(amount)
				else
					activedAmount[user_id] = parseInt(items[itemName].amount)
				end

				local new_weight = vRP.computeInvWeight(user_id) + vRP.itemWeightList(itemName) * parseInt(activedAmount[user_id])
				if new_weight <= vRP.getBackpack(user_id) then
					vRP.giveInventoryItem(user_id,itemName,parseInt(activedAmount[user_id]),true,slot)

					items[itemName].amount = parseInt(items[itemName].amount) - parseInt(activedAmount[user_id])

					if chestData == "chest:Police" then
						creativeLogs(policeLogs,"```PASSAPORTE: "..user_id.." ( RETIROU )\nITEM: "..vRP.format(parseInt(activedAmount[user_id])).."x "..vRP.itemNameList(itemName).."```")
					end

					if parseInt(items[itemName].amount) <= 0 then
						items[itemName] = nil
					end

					vRP.setSData(chestData,json.encode(items))
					return true
				end
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORECHESTITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.storeChestItem(user_id,chestData,itemName,amount,chestWeight,slot)
	if actived[user_id] == nil then
		actived[user_id] = 1
		local slot = tostring(slot)
		local data = vRP.getSData(chestData)
		local items = json.decode(data) or {}
		if data and items ~= nil then

			if parseInt(amount) > 0 then
				activedAmount[user_id] = parseInt(amount)
			else
				local inv = vRP.getInventory(user_id)
				if inv[slot] then
					activedAmount[user_id] = parseInt(inv[slot].amount)
				end
			end

			local new_weight = vRP.computeChestWeight(items) + vRP.itemWeightList(itemName) * parseInt(activedAmount[user_id])
			if new_weight <= chestWeight then
				if vRP.tryGetInventoryItem(user_id,itemName,parseInt(activedAmount[user_id]),true,slot) then
					if items[itemName] ~= nil then
						items[itemName].amount = parseInt(items[itemName].amount) + parseInt(activedAmount[user_id])
					else
						items[itemName] = { amount = parseInt(activedAmount[user_id]) }
					end

					if chestData == "chest:Police" then
						creativeLogs(policeLogs,"```PASSAPORTE: "..user_id.." ( GUARDOU )\nITEM: "..vRP.format(parseInt(activedAmount[user_id])).."x "..vRP.itemNameList(itemName).."```")
					end

					vRP.setSData(chestData,json.encode(items))
					return true
				end
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATIVELOGS
-----------------------------------------------------------------------------------------------------------------------------------------
function creativeLogs(webhook,message)
	if webhook ~= "" then
		PerformHttpRequest(webhook,function(err,text,headers) end,"POST",json.encode({ content = message }),{ ['Content-Type'] = "application/json" })
	end
end