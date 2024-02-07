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
Tunnel.bindInterface("vrp_benefactor",cRP)
vSERVER = Tunnel.getInterface("vrp_benefactor")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local typeCars = {}
local typeBikes = {}
local localVehicles = {}
local vehicles = {}
local vehIds = {}
local open = vector3(-30.09,-1105.0,26.43)
local zone = PolyZone:Create({
	vector2(-28.33,-1120.86),
	vector2(-44.92,-1122.70),
	vector2(-64.26,-1123.11),
	vector2(-71.02,-1117.35),
	vector2(-68.44,-1108.67),
	vector2(-57.19,-1079.97),
	vector2(-43.52,-1083.67),
	vector2(-36.62,-1089.40),
	vector2(-30.89,-1087.63),
	vector2(-25.52,-1089.94),
	vector2(-27.49,-1094.88),
	vector2(-18.20,-1099.08)
},{ name="pdm", minZ = 22, maxZ = 40 })

local coords = {
	[1] = { cds = vector3(-43.79,-1101.67,25.97), h = 11.34 },
	[2] = { cds = vector3(-49.38,-1099.91,25.97), h = 5.67 },
	[3] = { cds = vector3(-46.83,-1093.38,25.95), h = 102.05 },
	[4] = { cds = vector3(-40.62,-1096.44,25.97), h = 102.05 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_benefactor:syncVehicles")
AddEventHandler("vrp_benefactor:syncVehicles",function(vehs)
	if #vehIds > 0 then
		for k,v in pairs(vehs) do
			if v.model ~= vehicles[k].model then
				swapVehicle(v.model,k)
			end
		end
	else
		vehicles = vehs
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCLIST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_benefactor:syncList")
AddEventHandler("vrp_benefactor:syncList",function(cars,bikes)
	typeCars = cars
	typeBikes = bikes
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADOPEN
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)

	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)
			local distance = #(coords - open)
			if distance <= 2.1 then
				timeDistance = 4
				DrawText3D(open.x,open.y,open.z,"~g~E~w~   ABRIR")
				if IsControlJustPressed(1,38) then
					SetNuiFocus(true,true)
					SendNUIMessage({ action = "show" })
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
local inside = false
Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		if zone:isPointInside(coords) then
			if not inside then
				inside = true
				spawnVehicles()
			end
		else
			if inside then
				inside = false
				despawnVehicles()
			end
		end

		Citizen.Wait(500)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
function spawnVehicles()
	ClearAreaOfVehicles(-45.96,-1097.4,26.42,20.0)
	for k,v in pairs(vehicles) do
		local hash = GetHashKey(v.model)

		RequestModel(hash)
		while not HasModelLoaded(hash) do
			RequestModel(hash)
			Citizen.Wait(10)
		end

		local id = CreateVehicle(hash,coords[k].cds.x,coords[k].cds.y,coords[k].cds.z,coords[k].h,false,false)
		SetVehicleOnGroundProperly(id)
		SetVehicleDoorsLocked(id,2)
		SetVehicleDirtLevel(id,0.0)
		FreezeEntityPosition(id,true)
		SetEntityAsMissionEntity(id,true,true)
		SetVehicleNumberPlateText(id,"PDMSALE"..k)
		vehIds[k] = id
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SWAPVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function swapVehicle(veh,slot)
	if slot > 0 and slot < 5 then
		if vehIds[slot] then
			if DoesEntityExist(vehIds[slot]) then
				DeleteEntity(vehIds[slot])
			end
		end

		local hash = GetHashKey(veh)

		RequestModel(hash)
		while not HasModelLoaded(hash) do
			RequestModel(hash)
			Citizen.Wait(10)
		end

		local id = CreateVehicle(hash,coords[slot].cds.x,coords[slot].cds.y,coords[slot].cds.z,coords[slot].h,false,false)
		SetVehicleDoorsLocked(id,2)
		SetVehicleDirtLevel(id,0.0)
		FreezeEntityPosition(id,true)
		SetEntityAsMissionEntity(id,true,true)
		SetVehicleNumberPlateText(id,"PDMSALE"..slot)
		vehIds[slot] = id
		vehicles[slot].model = veh
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DESPAWNVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
function despawnVehicles()
	for k,v in pairs(vehIds) do
		if DoesEntityExist(v) then
			DeleteEntity(v)
		end
	end
	vehIds = {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x,y,z,text)
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
-- CLOSEAPP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("CloseApp",function(data,cb)
	SetNuiFocus(false,false)
	cb("ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HANDLESPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("HandleSpawn",function(data,cb)
	TriggerServerEvent("vrp_benefactor:setVehicles",data.vehicle,data.slot)
	cb("ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCARS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("GetCars",function(data,cb)
	cb(typeCars)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETBIKES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("GetBikes",function(data,cb)
	cb(typeBikes)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETOWNED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("GetOwned",function(data,cb)
	local vehs = vSERVER.getOwned()
	cb(vehs)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSELL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("RequestSell",function(data,cb)
	vSERVER.requestSell(data.name)
	cb("ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTBUY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("RequestBuy",function(data,cb)
	vSERVER.requestBuy(data.name,data.form)
	cb("ok")
end)