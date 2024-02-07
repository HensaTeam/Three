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
Tunnel.bindInterface("vrp_racewater",cRP)
vSERVER = Tunnel.getInterface("vrp_racewater")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local inRace = false
local startX = -1801.28
local startY = -1106.28
local startZ = -0.7
local racePos = 0
local raceTime = 0
local raceSelect = 0
local blipRace = nil
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local race = {
	[1] = {
		["time"] = 220,
		[1] = { -1741.02,-955.93,-0.01 },
		[2] = { -1212.09,-969.25,-0.14 },
		[3] = { -965.67,-976.52,-0.53 },
		[4] = { -1057.4,-1086.82,-0.52 },
		[5] = { -1055.88,-1237.93,-0.52 },
		[6] = { -827.77,-1468.62,0.0 },
		[7] = { -1030.78,-1723.09,0.17 },
		[8] = { -1281.5,-1955.27,0.48 },
		[9] = { -1575.61,-1908.19,1.21 },
		[10] = { -1913.1,-1759.69,-0.19 },
		[11] = { -2246.0,-1458.48,1.46 },
		[12] = { -2227.05,-968.34,0.14 },
		[13] = { -2205.58,-600.34,0.18 }
	},
	[2] = {
		["time"] = 220,
		[1] = { -1778.53,-973.46,-0.08 },
		[2] = { -1241.7,-917.89,-0.03 },
		[3] = { -1086.32,-1184.35,-0.48 },
		[4] = { -912.14,-1356.6,-0.06 },
		[5] = { -1046.58,-1796.2,0.04 },
		[6] = { -359.72,-1678.17,0.1 },
		[7] = { 60.85,-2137.85,-0.29 },
		[8] = { -279.29,-2539.05,0.36 }
	},
	[3] = {
		["time"] = 220,
		[1] = { -1873.18,-1279.9,0.3 },
		[2] = { -1743.29,-1230.6,0.32 },
		[3] = { -1651.31,-1265.28,0.97 },
		[4] = { -1305.17,-1964.66,0.26 },
		[5] = { -74.09,-1913.34,0.11 },
		[6] = { 146.12,-2313.39,1.25 },
		[7] = { 400.58,-2419.19,0.75 },
		[8] = { 558.41,-2888.4,-0.94 }
	},
	[4] = {
		["time"] = 200,
		[1] = { -1868.57,-1272.33,-0.14 },
		[2] = { -1684.94,-1238.04,1.04 },
		[3] = { -1482.95,-1480.53,2.61 },
		[4] = { -1303.62,-1963.63,0.17 },
		[5] = { -953.15,-1747.69,0.3 },
		[6] = { -137.0,-1860.13,0.0 },
		[7] = { 220.54,-2323.28,0.49 },
		[88] = { 595.68,-2463.54,-0.15 },
		[9] = { 627.58,-2079.13,4.69 },
		[10] = { 736.75,-1580.85,8.73 },
		[11] = { 1114.53,-1211.14,15.74 }
	},
	[5] = {
		["time"] = 600,
		[1] = { -2097.51,-1056.28,1.41 },
		[2] = { -2676.98,-582.63,2.15 },
		[3] = { -3200.66,254.32,0.95 },
		[4] = { -3342.21,967.81,0.4 },
		[5] = { -3194.77,1770.96,0.81 },
		[6] = { -2734.59,2675.64,0.07 },
		[7] = { -2375.81,2764.12,-0.05 },
		[8] = { -2254.06,2650.06,0.1 },
		[9] = { -1983.71,2545.61,-0.05 },
		[10] = { -1681.87,2599.98,-0.02 },
		[11] = { -1207.61,2713.71,0.02 },
		[12] = { -982.53,2818.93,6.69 },
		[13] = { -770.36,2845.53,11.11 },
		[14] = { -313.07,3023.66,16.4 },
		[15] = { -130.39,3111.36,21.34 },
		[16] = { 91.59,3273.62,28.32 },
		[17] = { 51.02,3981.19,28.89 },
		[18] = { -302.76,4392.17,30.06 },
		[19] = { -539.14,4423.86,29.09 },
		[20] = { -881.61,4411.75,13.74 },
		[21] = { -1139.12,4399.4,9.42 },
		[22] = { -1355.58,4332.66,1.68 },
		[23] = { -1706.29,4485.94,0.07 },
		[24] = { -1862.68,4714.09,-0.1 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTARTRACE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()

		if IsPedInAnyBoat(ped) then
			local coords = GetEntityCoords(ped)

			if not inRace then
				local distance = #(coords - vector3(startX,startY,startZ))
				if distance <= 500 then
					timeDistance = 4
					DrawMarker(1,startX,startY,startZ-5,0,0,0,0,0,0,50.0,50.0,100.0,255,0,0,100,0,0,0,0)
					if distance <= 25 then
						if IsControlJustPressed(1,38) then
							racePos = 1
							inRace = true
							raceSelect = vSERVER.raceSelect()
							raceTime = parseInt(race[raceSelect].time)
							makeBlipMarked()
						end
					end
				end
			else
				local distance = #(coords - vector3(race[raceSelect][racePos][1],race[raceSelect][racePos][2],race[raceSelect][racePos][3]))
				if distance <= 999 then
					timeDistance = 4
					DrawMarker(1,race[raceSelect][racePos][1],race[raceSelect][racePos][2],race[raceSelect][racePos][3]-5,0,0,0,0,0,0,50.0,50.0,100.0,100,100,255,100,0,0,0,0)
					if distance <= 25 then
						if DoesBlipExist(blipRace) then
							RemoveBlip(blipRace)
							blipRace = nil
						end

						if racePos >= #race[raceSelect] then
							inRace = false
							vSERVER.paymentMethod()
							PlaySoundFrontend(-1,"RACE_PLACED","HUD_AWARDS",false)
						else
							racePos = racePos + 1
							makeBlipMarked()
						end
					end
				end

				if raceTime > 0 then
					timeDistance = 4
					dwText("~b~"..raceTime.." SEGUNDOS ~w~RESTANTES PARA O FINAL DA CORRIDA",4,0.5,0.905,0.45,255,255,255,100)
					dwText("CORRA CONTRA O TEMPO, SUPERE SEUS LIMITES E QUEBRE SEUS RECORDES",4,0.5,0.93,0.38,255,255,255,50)
				end
			end
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADRACETIME
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if inRace and raceTime > 0 then
			raceTime = raceTime - 1

			if raceTime <= 0 or not IsPedInAnyBoat(PlayerPedId()) then
				raceTime = 0
				inRace = false

				if DoesBlipExist(blipRace) then
					RemoveBlip(blipRace)
				end
			end
		end

		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEBLIPRACE
-----------------------------------------------------------------------------------------------------------------------------------------
function makeBlipMarked()
	blipRace = AddBlipForCoord(race[raceSelect][racePos][1],race[raceSelect][racePos][2],race[raceSelect][racePos][3])
	SetBlipSprite(blipRace,1)
	SetBlipColour(blipRace,1)
	SetBlipScale(blipRace,0.4)
	SetBlipAsShortRange(blipRace,false)
	SetBlipRoute(blipRace,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Checkpoint")
	EndTextCommandSetBlipName(blipRace)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DWTEXT
-----------------------------------------------------------------------------------------------------------------------------------------
function dwText(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end