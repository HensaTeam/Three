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
Tunnel.bindInterface("vrp_weplants",cRP)
vSERVER = Tunnel.getInterface("vrp_weplants")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local wePlants = {}
local weObjects = {}
local weHashsA = "bkr_prop_weed_01_small_01c"
local weHashsB = "bkr_prop_weed_01_small_01a"
local weHashsC = "bkr_prop_weed_med_01a"
local weHashsD = "bkr_prop_weed_lrg_01a"
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

		for k,v in pairs(wePlants) do
			local distance = #(coords - vector3(v[1],v[2],v[3]))
			if distance < 25 then
				if weObjects[k] == nil then
					if v[4] <= 39 then
						createModels(k,weHashsA,v[1],v[2],v[3])
					elseif v[4] >= 40 and v[4] <= 69 then
						createModels(k,weHashsB,v[1],v[2],v[3])
					elseif v[4] >= 70 and v[4] <= 99 then
						createModels(k,weHashsC,v[1],v[2],v[3])
					elseif v[4] >= 100 then
						createModels(k,weHashsD,v[1],v[2],v[3])
					end
				else
					timeDistance = 4

					if distance <= 2 then
						if parseInt(v[4]) >= 100 then
							dwText(v[1],v[2],v[3]-0.5,"~g~E~w~   COLETAR")
						else
							dwText(v[1],v[2],v[3]-0.5,"~y~"..v[4].."%~w~  PROGRESSO")
						end
					end

					if distance <= 0.7 then
						if IsControlJustPressed(1,38) and vSERVER.checkTimers(k) then
							if DoesEntityExist(weObjects[k]) then
								vSERVER.removePlants(k)
							end
						end
					end
				end
			else
				if weObjects[k] then
					TriggerEvent("vrp_weplants:removeExists",k)
				end
			end
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESSPLANTS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.pressPlants(x,y,z)
	vSERVER.pressPlants(x,y,z)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TABLEUPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_weplants:tableUpdate")
AddEventHandler("vrp_weplants:tableUpdate",function(status)
	wePlants = status

	for k,v in pairs(wePlants) do
		if DoesEntityExist(weObjects[k]) then
			if v[4] == 40 then
				TriggerEvent("vrp_weplants:removeExists",k)
				createModels(k,weHashsB,v[1],v[2],v[3])
			elseif v[4] == 70 then
				TriggerEvent("vrp_weplants:removeExists",k)
				createModels(k,weHashsC,v[1],v[2],v[3])
			elseif v[4] == 100 then
				TriggerEvent("vrp_weplants:removeExists",k)
				createModels(k,weHashsD,v[1],v[2],v[3])
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEMODELS
-----------------------------------------------------------------------------------------------------------------------------------------
function createModels(id,hash,x,y,z)
	local mHash = GetHashKey(hash)

	RequestModel(mHash)
	while not HasModelLoaded(mHash) do
		RequestModel(mHash)
		Citizen.Wait(10)
	end

	weObjects[id] = CreateObjectNoOffset(mHash,x,y,z,false,true,true)
	SetEntityAsMissionEntity(weObjects[id],true,true)
	PlaceObjectOnGroundProperly(weObjects[id])
	FreezeEntityPosition(weObjects[id],true)
	SetModelAsNoLongerNeeded(mHash)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEEXISTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_weplants:removeExists")
AddEventHandler("vrp_weplants:removeExists",function(id)
	if DoesEntityExist(weObjects[id]) then
		SetEntityAsMissionEntity(weObjects[id],false,false)
		DeleteEntity(weObjects[id])
		weObjects[id] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DWTEXT
-----------------------------------------------------------------------------------------------------------------------------------------
function dwText(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,100)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 400
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,100)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTITYINWORLDCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.entityInWorldCoords()
	local ped = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(ped))
	if DoesObjectOfTypeExistAtCoords(x,y,z,0.6,GetHashKey(weHashsA),true) or DoesObjectOfTypeExistAtCoords(x,y,z,0.6,GetHashKey(weHashsB),true) or DoesObjectOfTypeExistAtCoords(x,y,z,0.6,GetHashKey(weHashsC),true) or DoesObjectOfTypeExistAtCoords(x,y,z,0.6,GetHashKey(weHashsD),true) then
		return false
	end
	return true,x,y,z
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKWATER
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkWater()
	return IsEntityInWater(PlayerPedId())
end