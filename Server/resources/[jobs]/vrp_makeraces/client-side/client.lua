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
Tunnel.bindInterface("vrp_makeraces",cRP)
vSERVER = Tunnel.getInterface("vrp_makeraces")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local races = {}
local myRaces = {}
local inRace = false
local makeRaces = false
local raceSelect = 0
local checkPoint = 0
local blipRace = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if makeRaces then
			timeDistance = 4
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			if IsPedInAnyVehicle(ped) then
				if IsControlJustPressed(1,38) then
					table.insert(myRaces,{ x,y,z })
					TriggerEvent("Notify","importante","Checkpoint marcado.",3000)
					PlaySoundFrontend(-1,"Event_Message_Purple","GTAO_FM_Events_Soundset",false)
				elseif IsControlJustPressed(1,47) then
					TriggerEvent("Notify","importante","Final da corrida marcado.",3000)
					PlaySoundFrontend(-1,"Event_Message_Purple","GTAO_FM_Events_Soundset",false)
					table.insert(myRaces,{ x,y,z })
					vSERVER.inputRaces(myRaces)
					makeRaces = false
				end
				dwText("[ ~g~E~w~ ] NOVO CHECKPOINT   ~m~|~w~   [ ~y~G~w~ ] FINALIZAR CORRIDA")
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SELECTRACES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.selectRaces(number)
	inRace = true
	checkPoint = 1
	raceSelect = number
	makeBlipMarked(raceSelect)
	SetNewWaypoint(races[raceSelect][checkPoint][1]+0.0001,races[raceSelect][checkPoint][2]+0.0001)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKERACES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.makeRaces()
	makeRaces = not makeRaces
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATERACES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_makeraces:updateRaces")
AddEventHandler("vrp_makeraces:updateRaces",function(status)
	races = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINISHRACES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.finishRaces(race)
	if raceSelect == race then
		inRace = false
		for k,v in pairs(blipRace) do
			if DoesBlipExist(blipRace[k]) then
				RemoveBlip(blipRace[k])
				blipRace[k] = nil
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTARTRACE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 100
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
			if inRace then
				local coords = GetEntityCoords(ped)
				local distance = #(coords - vector3(races[raceSelect][checkPoint][1],races[raceSelect][checkPoint][2],races[raceSelect][checkPoint][3]))
				if distance <= 200 then
					timeDistance = 4
					DrawMarker(1,races[raceSelect][checkPoint][1],races[raceSelect][checkPoint][2],races[raceSelect][checkPoint][3]-3,0,0,0,0,0,0,12.0,12.0,8.0,255,255,255,25,0,0,0,0)
					DrawMarker(21,races[raceSelect][checkPoint][1],races[raceSelect][checkPoint][2],races[raceSelect][checkPoint][3]+1,0,0,0,0,180.0,130.0,3.0,3.0,2.0,255,0,0,50,1,0,0,1)
					if distance <= 10 then
						if DoesBlipExist(blipRace[checkPoint]) then
							RemoveBlip(blipRace[checkPoint])
							blipRace[checkPoint] = nil
						end

						if checkPoint >= #races[raceSelect] then
							inRace = false
							vSERVER.finishRaces(raceSelect)
							PlaySoundFrontend(-1,"RACE_PLACED","HUD_AWARDS",false)
						else
							checkPoint = checkPoint + 1
							SetNewWaypoint(races[raceSelect][checkPoint][1]+0.0001,races[raceSelect][checkPoint][2]+0.0001)
						end
					end
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DWTEXT
-----------------------------------------------------------------------------------------------------------------------------------------
function dwText(text,height)
	SetTextFont(4)
	SetTextScale(0.50,0.50)
	SetTextColour(255,255,255,180)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.5,0.94)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEBLIPRACE
-----------------------------------------------------------------------------------------------------------------------------------------
function makeBlipMarked(number)
	for k,v in pairs(races[number]) do
		blipRace[k] = AddBlipForCoord(v[1],v[2],v[3])
		SetBlipSprite(blipRace[k],1)
		SetBlipColour(blipRace[k],0)
		SetBlipAsShortRange(blipRace[k],true)
		SetBlipScale(blipRace[k],0.8)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Checkpoint")
		EndTextCommandSetBlipName(blipRace[k])
		ShowNumberOnBlip(blipRace[k],parseInt(k))
	end
end