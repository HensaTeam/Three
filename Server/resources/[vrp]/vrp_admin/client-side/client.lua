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
Tunnel.bindInterface("vrp_admin",cRP)
vSERVER = Tunnel.getInterface("vrp_admin")
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCORD
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.setDiscord(status)
	SetDiscordAppId()
	SetDiscordRichPresenceAsset()
	-- SetRichPresence(status)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORTWAY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.vehicleHash(vehicle)
	print(GetEntityModel(vehicle))
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORTWAY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.teleportWay()
	local ped = PlayerPedId()
	local veh = GetVehiclePedIsUsing(ped)
	if IsPedInAnyVehicle(ped) then
		ped = veh
    end

	local waypointBlip = GetFirstBlipInfoId(8)
	local x,y,z = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09,waypointBlip,Citizen.ResultAsVector()))

	local ground
	local groundFound = false
	local groundCheckHeights = { 0.0,50.0,100.0,150.0,200.0,250.0,300.0,350.0,400.0,450.0,500.0,550.0,600.0,650.0,700.0,750.0,800.0,850.0,900.0,950.0,1000.0,1050.0,1100.0 }

	for i,height in ipairs(groundCheckHeights) do
		SetEntityCoordsNoOffset(ped,x,y,height,0,0,1)

		RequestCollisionAtCoord(x,y,z)
		while not HasCollisionLoadedAroundEntity(ped) do
			Citizen.Wait(10)
		end
		Citizen.Wait(20)

		ground,z = GetGroundZFor_3dCoord(x,y,height)
		if ground then
			z = z + 1.0
			groundFound = true
			break;
		end
	end

	if not groundFound then
		z = 1200
		GiveDelayedWeaponToPed(ped,0xFBAB5776,1,0)
	end

	RequestCollisionAtCoord(x,y,z)
	while not HasCollisionLoadedAroundEntity(ped) do
		Citizen.Wait(10)
	end

	SetEntityCoordsNoOffset(ped,x,y,z,0,0,1)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORTWAY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.teleportLimbo()
	local ped = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(ped))
	local _,vector = GetNthClosestVehicleNode(x,y,z,math.random(5,10),0,0,0)
	local x2,y2,z2 = table.unpack(vector)

	SetEntityCoordsNoOffset(ped,x2,y2,z2+5,0,0,1)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHELETRIC
-----------------------------------------------------------------------------------------------------------------------------------------
local vehEletric = {
	["teslaprior"] = true,
	["voltic"] = true,
	["raiden"] = true,
	["neon"] = true,
	["tezeract"] = true,
	["cyclone"] = true,
	["surge"] = true,
	["dilettante"] = true,
	["dilettante2"] = true,
	["bmx"] = true,
	["cruiser"] = true,
	["fixter"] = true,
	["scorcher"] = true,
	["tribike"] = true,
	["tribike2"] = true,
	["tribike3"] = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMINVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("adminVehicle")
AddEventHandler("adminVehicle",function(name,plate)
	local mHash = GetHashKey(name)

	RequestModel(mHash)
	while not HasModelLoaded(mHash) do
		RequestModel(mHash)
		Citizen.Wait(10)
	end

	if HasModelLoaded(mHash) then
		local ped = PlayerPedId()
		local nveh = CreateVehicle(mHash,GetEntityCoords(ped),GetEntityHeading(ped),true,false)

		SetVehicleDirtLevel(nveh,0.0)
		SetVehRadioStation(nveh,"OFF")
		SetVehicleNumberPlateText(nveh,plate)
		SetEntityAsMissionEntity(nveh,true,true)

		SetPedIntoVehicle(ped,nveh,-1)

		if vehEletric[vehname] then
			SetVehicleFuelLevel(nveh,0.0)
		else
			SetVehicleFuelLevel(nveh,100.0)
		end

		SetModelAsNoLongerNeeded(mHash)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETENPCS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.deleteNpcs()
	local handle,ped = FindFirstPed()
	local finished = false
	repeat
		local coords = GetEntityCoords(ped)
		local coordsPed = GetEntityCoords(PlayerPedId())
		local distance = #(coords - coordsPed)
		if IsPedDeadOrDying(ped) and not IsPedAPlayer(ped) and distance < 3 then
			TriggerServerEvent("tryDeleteEntity",PedToNet(ped))
			finished = true
		end
		finished,ped = FindNextPed(handle)
	until not finished
	EndFindPed(handle)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLETUNING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_admin:vehicleTuning")
AddEventHandler("vrp_admin:vehicleTuning",function()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	if IsEntityAVehicle(vehicle) then
		SetVehicleModKit(vehicle,0)
		SetVehicleMod(vehicle,11,GetNumVehicleMods(vehicle,11)-1,false)
		SetVehicleMod(vehicle,12,GetNumVehicleMods(vehicle,12)-1,false)
		SetVehicleMod(vehicle,13,GetNumVehicleMods(vehicle,13)-1,false)
		SetVehicleMod(vehicle,15,GetNumVehicleMods(vehicle,15)-1,false)
		ToggleVehicleMod(vehicle,18,true)
	end
end)

-- Citizen.CreateThread(function()
-- 	while true do
-- 		if IsControlJustPressed(1,38) then
-- 			vSERVER.buttonTxt()
-- 		end
-- 		Citizen.Wait(1)
-- 	end
-- end)