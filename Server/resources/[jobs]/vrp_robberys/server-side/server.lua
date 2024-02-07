-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("vrp_robberys",cRP)
vCLIENT = Tunnel.getInterface("vrp_robberys")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local robberyProgress = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local vars = {
	[1] = {
		["x"] = 28.24,
		["y"] = -1338.832,
		["z"] = 29.5,
		["cops"] = 7,
		["time"] = 240,
		["distance"] = 12,
		["type"] = "convn",
		["cooldown"] = 7200,
		["name"] = "Loja de Departamento",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "dollars", ["min"] = 40000, ["max"] = 60000 },
			{ ["item"] = "dollars2", ["min"] = 400, ["max"] = 600 }
		}
	},
	[2] = {
		["x"] = 2548.883,
		["y"] = 384.850,
		["z"] = 108.63,
		["cops"] = 7,
		["time"] = 240,
		["distance"] = 12,
		["type"] = "convn",
		["cooldown"] = 7200,
		["name"] = "Loja de Departamento",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "dollars", ["min"] = 40000, ["max"] = 60000 },
			{ ["item"] = "dollars2", ["min"] = 400, ["max"] = 600 }
		}
	},
	[3] = {
		["x"] = 1159.156,
		["y"] = -314.055,
		["z"] = 69.21,
		["cops"] = 7,
		["time"] = 240,
		["distance"] = 12,
		["type"] = "convn",
		["cooldown"] = 7200,
		["name"] = "Loja de Departamento",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "dollars", ["min"] = 40000, ["max"] = 60000 },
			{ ["item"] = "dollars2", ["min"] = 400, ["max"] = 600 }
		}
	},
	[4] = {
		["x"] = -710.067,
		["y"] = -904.091,
		["z"] = 19.22,
		["cops"] = 7,
		["time"] = 240,
		["distance"] = 12,
		["type"] = "convn",
		["cooldown"] = 7200,
		["name"] = "Loja de Departamento",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "dollars", ["min"] = 40000, ["max"] = 60000 },
			{ ["item"] = "dollars2", ["min"] = 400, ["max"] = 600 }
		}
	},
	[5] = {
		["x"] = -43.652,
		["y"] = -1748.122,
		["z"] = 29.43,
		["cops"] = 7,
		["time"] = 240,
		["distance"] = 12,
		["type"] = "convn",
		["cooldown"] = 7200,
		["name"] = "Loja de Departamento",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "dollars", ["min"] = 40000, ["max"] = 60000 },
			{ ["item"] = "dollars2", ["min"] = 400, ["max"] = 600 }
		}
	},
	[6] = {
		["x"] = 378.291,
		["y"] = 333.712,
		["z"] = 103.57,
		["cops"] = 7,
		["time"] = 240,
		["distance"] = 12,
		["type"] = "convn",
		["cooldown"] = 7200,
		["name"] = "Loja de Departamento",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "dollars", ["min"] = 40000, ["max"] = 60000 },
			{ ["item"] = "dollars2", ["min"] = 400, ["max"] = 600 }
		}
	},
	[7] = {
		["x"] = -3250.385,
		["y"] = 1004.504,
		["z"] = 12.84,
		["cops"] = 7,
		["time"] = 240,
		["distance"] = 12,
		["type"] = "convn",
		["cooldown"] = 7200,
		["name"] = "Loja de Departamento",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "dollars", ["min"] = 40000, ["max"] = 60000 },
			{ ["item"] = "dollars2", ["min"] = 400, ["max"] = 600 }
		}
	},
	[8] = {
		["x"] = 1734.968,
		["y"] = 6421.161,
		["z"] = 35.04,
		["cops"] = 7,
		["time"] = 240,
		["distance"] = 12,
		["type"] = "convn",
		["cooldown"] = 7200,
		["name"] = "Loja de Departamento",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "dollars", ["min"] = 40000, ["max"] = 60000 },
			{ ["item"] = "dollars2", ["min"] = 400, ["max"] = 600 }
		}
	},
	[9] = {
		["x"] = 546.450,
		["y"] = 2662.45,
		["z"] = 42.16,
		["cops"] = 7,
		["time"] = 240,
		["distance"] = 12,
		["type"] = "convn",
		["cooldown"] = 7200,
		["name"] = "Loja de Departamento",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "dollars", ["min"] = 40000, ["max"] = 60000 },
			{ ["item"] = "dollars2", ["min"] = 400, ["max"] = 600 }
		}
	},
	[10] = {
		["x"] = 1959.113,
		["y"] = 3749.239,
		["z"] = 32.35,
		["cops"] = 7,
		["time"] = 240,
		["distance"] = 12,
		["type"] = "convn",
		["cooldown"] = 7200,
		["name"] = "Loja de Departamento",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "dollars", ["min"] = 40000, ["max"] = 60000 },
			{ ["item"] = "dollars2", ["min"] = 400, ["max"] = 600 }
		}
	},
	[11] = {
		["x"] = 2672.457,
		["y"] = 3286.811,
		["z"] = 55.25,
		["cops"] = 7,
		["time"] = 240,
		["distance"] = 12,
		["type"] = "convn",
		["cooldown"] = 7200,
		["name"] = "Loja de Departamento",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "dollars", ["min"] = 40000, ["max"] = 60000 },
			{ ["item"] = "dollars2", ["min"] = 400, ["max"] = 600 }
		}
	},
	[12] = {
		["x"] = 1708.095,
		["y"] = 4920.711,
		["z"] = 42.07,
		["cops"] = 7,
		["time"] = 240,
		["distance"] = 12,
		["type"] = "convn",
		["cooldown"] = 7200,
		["name"] = "Loja de Departamento",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "dollars", ["min"] = 40000, ["max"] = 60000 },
			{ ["item"] = "dollars2", ["min"] = 400, ["max"] = 600 }
		}
	},
	[13] = {
		["x"] = -1829.422,
		["y"] = 798.491,
		["z"] = 138.2,
		["cops"] = 7,
		["time"] = 240,
		["distance"] = 12,
		["type"] = "convn",
		["cooldown"] = 7200,
		["name"] = "Loja de Departamento",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "dollars", ["min"] = 40000, ["max"] = 60000 },
			{ ["item"] = "dollars2", ["min"] = 400, ["max"] = 600 }
		}
	},
	[14] = {
		["x"] = -2959.66,
		["y"] = 386.765,
		["z"] = 14.05,
		["cops"] = 7,
		["time"] = 240,
		["distance"] = 12,
		["type"] = "convn",
		["cooldown"] = 7200,
		["name"] = "Loja de Departamento",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "dollars", ["min"] = 40000, ["max"] = 60000 },
			{ ["item"] = "dollars2", ["min"] = 400, ["max"] = 600 }
		}
	},
	[15] = {
		["x"] = -3048.155,
		["y"] = 585.519,
		["z"] = 7.91,
		["cops"] = 7,
		["time"] = 240,
		["distance"] = 12,
		["type"] = "convn",
		["cooldown"] = 7200,
		["name"] = "Loja de Departamento",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "dollars", ["min"] = 40000, ["max"] = 60000 },
			{ ["item"] = "dollars2", ["min"] = 400, ["max"] = 600 }
		}
	},
	[16] = {
		["x"] = 1126.75,
		["y"] = -979.760,
		["z"] = 45.42,
		["cops"] = 7,
		["time"] = 240,
		["distance"] = 12,
		["type"] = "convn",
		["cooldown"] = 7200,
		["name"] = "Loja de Departamento",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "dollars", ["min"] = 40000, ["max"] = 60000 },
			{ ["item"] = "dollars2", ["min"] = 400, ["max"] = 600 }
		}
	},
	[17] = {
		["x"] = 1169.631,
		["y"] = 2717.833,
		["z"] = 37.16,
		["cops"] = 7,
		["time"] = 240,
		["distance"] = 12,
		["type"] = "convn",
		["cooldown"] = 7200,
		["name"] = "Loja de Departamento",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "dollars", ["min"] = 40000, ["max"] = 60000 },
			{ ["item"] = "dollars2", ["min"] = 400, ["max"] = 600 }
		}
	},
	[18] = {
		["x"] = -1478.67,
		["y"] = -375.675,
		["z"] = 39.17,
		["cops"] = 7,
		["time"] = 240,
		["distance"] = 12,
		["type"] = "convn",
		["cooldown"] = 7200,
		["name"] = "Loja de Departamento",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "dollars", ["min"] = 40000, ["max"] = 60000 },
			{ ["item"] = "dollars2", ["min"] = 400, ["max"] = 600 }
		}
	},
	[19] = {
		["x"] = -1221.126,
		["y"] = -916.213,
		["z"] = 11.33,
		["cops"] = 7,
		["time"] = 240,
		["distance"] = 12,
		["type"] = "convn",
		["cooldown"] = 7200,
		["name"] = "Loja de Departamento",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "dollars", ["min"] = 40000, ["max"] = 60000 },
			{ ["item"] = "dollars2", ["min"] = 400, ["max"] = 600 }
		}
	},
	[20] = {
		["x"] = 1693.374,
		["y"] = 3761.669,
		["z"] = 34.71,
		["cops"] = 6,
		["time"] = 240,
		["distance"] = 12,
		["type"] = "ammus",
		["cooldown"] = 7200,
		["name"] = "Loja de Armas",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "WEAPON_PISTOL", ["min"] = 1, ["max"] = 1 },
			{ ["item"] = "WEAPON_SNSPISTOL", ["min"] = 1, ["max"] = 2 },
			{ ["item"] = "WEAPON_PISTOL_AMMO", ["min"] = 50, ["max"] = 75 }
		}
	},
	[21] = {
		["x"] = 253.061,
		["y"] = -51.643,
		["z"] = 69.95,
		["cops"] = 6,
		["time"] = 240,
		["distance"] = 12,
		["type"] = "ammus",
		["cooldown"] = 7200,
		["name"] = "Loja de Armas",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "WEAPON_PISTOL", ["min"] = 1, ["max"] = 1 },
			{ ["item"] = "WEAPON_SNSPISTOL", ["min"] = 1, ["max"] = 2 },
			{ ["item"] = "WEAPON_PISTOL_AMMO", ["min"] = 50, ["max"] = 75 }
		}
	},
	[22] = {
		["x"] = 841.128,
		["y"] = -1034.951,
		["z"] = 28.2,
		["cops"] = 6,
		["time"] = 240,
		["distance"] = 12,
		["type"] = "ammus",
		["cooldown"] = 7200,
		["name"] = "Loja de Armas",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "WEAPON_PISTOL", ["min"] = 1, ["max"] = 1 },
			{ ["item"] = "WEAPON_SNSPISTOL", ["min"] = 1, ["max"] = 2 },
			{ ["item"] = "WEAPON_PISTOL_AMMO", ["min"] = 50, ["max"] = 75 }
		}
	},
	[23] = {
		["x"] = -330.467,
		["y"] = 6085.647,
		["z"] = 31.46,
		["cops"] = 6,
		["time"] = 240,
		["distance"] = 12,
		["type"] = "ammus",
		["cooldown"] = 7200,
		["name"] = "Loja de Armas",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "WEAPON_PISTOL", ["min"] = 1, ["max"] = 1 },
			{ ["item"] = "WEAPON_SNSPISTOL", ["min"] = 1, ["max"] = 2 },
			{ ["item"] = "WEAPON_PISTOL_AMMO", ["min"] = 50, ["max"] = 75 }
		}
	},
	[24] = {
		["x"] = -660.987,
		["y"] = -933.901,
		["z"] = 21.83,
		["cops"] = 6,
		["time"] = 240,
		["distance"] = 12,
		["type"] = "ammus",
		["cooldown"] = 7200,
		["name"] = "Loja de Armas",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "WEAPON_PISTOL", ["min"] = 1, ["max"] = 1 },
			{ ["item"] = "WEAPON_SNSPISTOL", ["min"] = 1, ["max"] = 2 },
			{ ["item"] = "WEAPON_PISTOL_AMMO", ["min"] = 50, ["max"] = 75 }
		}
	},
	[25] = {
		["x"] = -1304.775,
		["y"] = -395.832,
		["z"] = 36.7,
		["cops"] = 6,
		["time"] = 240,
		["distance"] = 12,
		["type"] = "ammus",
		["cooldown"] = 7200,
		["name"] = "Loja de Armas",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "WEAPON_PISTOL", ["min"] = 1, ["max"] = 1 },
			{ ["item"] = "WEAPON_SNSPISTOL", ["min"] = 1, ["max"] = 2 },
			{ ["item"] = "WEAPON_PISTOL_AMMO", ["min"] = 50, ["max"] = 75 }
		}
	},
	[26] = {
		["x"] = -1117.765,
		["y"] = 2700.388,
		["z"] = 18.56,
		["cops"] = 6,
		["time"] = 240,
		["distance"] = 12,
		["type"] = "ammus",
		["cooldown"] = 7200,
		["name"] = "Loja de Armas",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "WEAPON_PISTOL", ["min"] = 1, ["max"] = 1 },
			{ ["item"] = "WEAPON_SNSPISTOL", ["min"] = 1, ["max"] = 2 },
			{ ["item"] = "WEAPON_PISTOL_AMMO", ["min"] = 50, ["max"] = 75 }
		}
	},
	[27] = {
		["x"] = 2566.632,
		["y"] = 292.945,
		["z"] = 108.74,
		["cops"] = 6,
		["time"] = 240,
		["distance"] = 12,
		["type"] = "ammus",
		["cooldown"] = 7200,
		["name"] = "Loja de Armas",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "WEAPON_PISTOL", ["min"] = 1, ["max"] = 1 },
			{ ["item"] = "WEAPON_SNSPISTOL", ["min"] = 1, ["max"] = 2 },
			{ ["item"] = "WEAPON_PISTOL_AMMO", ["min"] = 50, ["max"] = 75 }
		}
	},
	[28] = {
		["x"] = -3172.701,
		["y"] = 1089.462,
		["z"] = 20.84,
		["cops"] = 6,
		["time"] = 240,
		["distance"] = 12,
		["type"] = "ammus",
		["cooldown"] = 7200,
		["name"] = "Loja de Armas",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "WEAPON_PISTOL", ["min"] = 1, ["max"] = 1 },
			{ ["item"] = "WEAPON_SNSPISTOL", ["min"] = 1, ["max"] = 2 },
			{ ["item"] = "WEAPON_PISTOL_AMMO", ["min"] = 50, ["max"] = 75 }
		}
	},
	[29] = {
		["x"] = 23.733,
		["y"] = -1106.27,
		["z"] = 29.8,
		["cops"] = 6,
		["time"] = 240,
		["distance"] = 12,
		["type"] = "ammus",
		["cooldown"] = 7200,
		["name"] = "Loja de Armas",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "WEAPON_PISTOL", ["min"] = 1, ["max"] = 1 },
			{ ["item"] = "WEAPON_SNSPISTOL", ["min"] = 1, ["max"] = 2 },
			{ ["item"] = "WEAPON_PISTOL_AMMO", ["min"] = 50, ["max"] = 75 }
		}
	},
	[30] = {
		["x"] = 808.914,
		["y"] = -2158.684,
		["z"] = 29.62,
		["cops"] = 6,
		["time"] = 240,
		["distance"] = 12,
		["type"] = "ammus",
		["cooldown"] = 7200,
		["name"] = "Loja de Armas",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "WEAPON_PISTOL", ["min"] = 1, ["max"] = 1 },
			{ ["item"] = "WEAPON_SNSPISTOL", ["min"] = 1, ["max"] = 2 },
			{ ["item"] = "WEAPON_PISTOL_AMMO", ["min"] = 50, ["max"] = 75 }
		}
	},
	[31] = {
		["x"] = -1210.409,
		["y"] = -336.485,
		["z"] = 38.29,
		["cops"] = 8,
		["time"] = 300,
		["distance"] = 12,
		["type"] = "fleeca",
		["cooldown"] = 10800,
		["name"] = "Banco Fleeca",
		["required"] = "blackcard",
		["itens"] = {
			{ ["item"] = "goldbar", ["min"] = 250, ["max"] = 300 }
		}
	},
	[32] = {
		["x"] = -353.519,
		["y"] = -55.518,
		["z"] = 49.54,
		["cops"] = 8,
		["time"] = 300,
		["distance"] = 12,
		["type"] = "fleeca",
		["cooldown"] = 10800,
		["name"] = "Banco Fleeca",
		["required"] = "blackcard",
		["itens"] = {
			{ ["item"] = "goldbar", ["min"] = 250, ["max"] = 300 }
		}
	},
	[33] = {
		["x"] = 311.525,
		["y"] = -284.649,
		["z"] = 54.67,
		["cops"] = 8,
		["time"] = 300,
		["distance"] = 12,
		["type"] = "fleeca",
		["cooldown"] = 10800,
		["name"] = "Banco Fleeca",
		["required"] = "blackcard",
		["itens"] = {
			{ ["item"] = "goldbar", ["min"] = 250, ["max"] = 300 }
		}
	},
	[34] = {
		["x"] = 147.210,
		["y"] = -1046.292,
		["z"] = 29.87,
		["cops"] = 8,
		["time"] = 300,
		["distance"] = 12,
		["type"] = "fleeca",
		["cooldown"] = 10800,
		["name"] = "Banco Fleeca",
		["required"] = "blackcard",
		["itens"] = {
			{ ["item"] = "goldbar", ["min"] = 250, ["max"] = 300 }
		}
	},
	[35] = {
		["x"] = -2956.449,
		["y"] = 482.090,
		["z"] = 16.2,
		["cops"] = 8,
		["time"] = 300,
		["distance"] = 12,
		["type"] = "fleeca",
		["cooldown"] = 10800,
		["name"] = "Banco Fleeca",
		["required"] = "blackcard",
		["itens"] = {
			{ ["item"] = "goldbar", ["min"] = 250, ["max"] = 300 }
		}
	},
	[36] = {
		["x"] = 1175.66,
		["y"] = 2712.939,
		["z"] = 38.59,
		["cops"] = 8,
		["time"] = 300,
		["distance"] = 12,
		["type"] = "fleeca",
		["cooldown"] = 10800,
		["name"] = "Banco Fleeca",
		["required"] = "blackcard",
		["itens"] = {
			{ ["item"] = "goldbar", ["min"] = 250, ["max"] = 300 }
		}
	},
	[37] = {
		["x"] = 134.124,
		["y"] = -1708.138,
		["z"] = 29.7,
		["cops"] = 5,
		["time"] = 240,
		["distance"] = 10,
		["type"] = "barber",
		["cooldown"] = 3600,
		["name"] = "Barbearia",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "dollars", ["min"] = 20000, ["max"] = 40000 },
			{ ["item"] = "dollars2", ["min"] = 200, ["max"] = 300 }
		}
	},
	[38] = {
		["x"] = -1284.667,
		["y"] = -1115.089,
		["z"] = 7.5,
		["cops"] = 5,
		["time"] = 240,
		["distance"] = 10,
		["type"] = "barber",
		["cooldown"] = 3600,
		["name"] = "Barbearia",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "dollars", ["min"] = 20000, ["max"] = 40000 },
			{ ["item"] = "dollars2", ["min"] = 200, ["max"] = 300 }
		}
	},
	[39] = {
		["x"] = 1930.781,
		["y"] = 3727.585,
		["z"] = 33.35,
		["cops"] = 5,
		["time"] = 240,
		["distance"] = 10,
		["type"] = "barber",
		["cooldown"] = 3600,
		["name"] = "Barbearia",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "dollars", ["min"] = 20000, ["max"] = 40000 },
			{ ["item"] = "dollars2", ["min"] = 200, ["max"] = 300 }
		}
	},
	[40] = {
		["x"] = 1211.147,
		["y"] = -470.180,
		["z"] = 66.71,
		["cops"] = 5,
		["time"] = 240,
		["distance"] = 10,
		["type"] = "barber",
		["cooldown"] = 3600,
		["name"] = "Barbearia",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "dollars", ["min"] = 20000, ["max"] = 40000 },
			{ ["item"] = "dollars2", ["min"] = 200, ["max"] = 300 }
		}
	},
	[41] = {
		["x"] = -30.355,
		["y"] = -151.385,
		["z"] = 57.58,
		["cops"] = 5,
		["time"] = 240,
		["distance"] = 10,
		["type"] = "barber",
		["cooldown"] = 3600,
		["name"] = "Barbearia",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "dollars", ["min"] = 20000, ["max"] = 40000 },
			{ ["item"] = "dollars2", ["min"] = 200, ["max"] = 300 }
		}
	},
	[42] = {
		["x"] = -278.047,
		["y"] = 6231.001,
		["z"] = 32.2,
		["cops"] = 5,
		["time"] = 240,
		["distance"] = 10,
		["type"] = "barber",
		["cooldown"] = 3600,
		["name"] = "Barbearia",
		["required"] = "bluecard",
		["itens"] = {
			{ ["item"] = "dollars", ["min"] = 20000, ["max"] = 40000 },
			{ ["item"] = "dollars2", ["min"] = 200, ["max"] = 300 }
		}
	},
	[43] = {
		["x"] = 265.336,
		["y"] = 220.184,
		["z"] = 102.09,
		["cops"] = 10,
		["time"] = 600,
		["distance"] = 20,
		["type"] = "bank",
		["cooldown"] = 21600,
		["name"] = "Vinewood Vault",
		["required"] = "blackcard",
		["itens"] = {
			{ ["item"] = "goldbar", ["min"] = 500, ["max"] = 700 }
		}
	},
	[44] = {
		["x"] = -104.386,
		["y"] = 6477.150,
		["z"] = 31.83,
		["cops"] = 10,
		["time"] = 600,
		["distance"] = 12,
		["type"] = "bank",
		["cooldown"] = 21600,
		["name"] = "Savings Bank",
		["required"] = "blackcard",
		["itens"] = {
			{ ["item"] = "goldbar", ["min"] = 500, ["max"] = 700 }
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPOLICE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkPolice(robberyId,coords)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if robberyProgress[vars[robberyId].type] ~= nil then
			TriggerClientEvent("Notify",source,"importante","Aguarde <b>"..robberyProgress[vars[robberyId].type].."</b> segundos.",5000)
			return false
		end

		local amountCops = vRP.numPermission("Police")
		if parseInt(#amountCops) <= parseInt(vars[robberyId].cops) then
			TriggerClientEvent("Notify",source,"aviso","Sistema indisponível no momento, tente mais tarde.",5000)
			return false
		end

		if vRP.tryGetInventoryItem(user_id,vars[robberyId].required,1,true) then
			for k,v in pairs(amountCops) do
				async(function()
					TriggerClientEvent("NotifyPush",v,{ code = 31, title = "Roubo a "..vars[robberyId].name, x = coords.x, y = coords.y, z = coords.z, rgba = {0,150,90} })
				end)
			end

			robberyProgress[vars[robberyId].type] = vars[robberyId].cooldown

			return true
		else
			TriggerClientEvent("Notify",source,"aviso","Você precisa de <b>1x "..vRP.itemNameList(vars[robberyId].required).."</b>.",5000)
			return false
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTMETHOD
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.paymentMethod(robberyId)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.wantedTimer(user_id,600)
		for k,v in pairs(vars[robberyId].itens) do
			vRP.giveInventoryItem(user_id,v.item,parseInt(math.random(v.min,v.max)),true)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(robberyProgress) do
			if robberyProgress[k] > 0 then
				robberyProgress[k] = robberyProgress[k] - 1
				if robberyProgress[k] <= 0 then
					robberyProgress[k] = nil
				end
			end
		end
		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	vCLIENT.updateVars(source,vars)
end)