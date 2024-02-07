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
Tunnel.bindInterface("vrp_stockade",cRP)
vSERVER = Tunnel.getInterface("vrp_stockade")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local blockStockades = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTOCKADE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 1000
		local ped = PlayerPedId()

		if not IsPedInAnyVehicle(ped) then
			local vehicle = getNearVehicle(11)
			if DoesEntityExist(vehicle) and GetEntityModel(vehicle) == GetHashKey("stockade") then
				local coordsPed = GetEntityCoords(ped)
				local plate = GetVehicleNumberPlateText(vehicle)
				local coords = GetOffsetFromEntityInWorldCoords(vehicle,0.0,-3.5,0.0)
				local distance = #(coords - coordsPed)
				if distance <= 2.5 and blockStockades[plate] == nil then
					timeDistance = 4
					DrawText3D(coords.x,coords.y,coords.z+1,"~g~E~w~   ROUBAR")
					if IsControlJustPressed(1,38) and distance <= 1.0 and vSERVER.checkPolice(plate) then
						SetEntityHeading(ped,GetEntityHeading(vehicle))
						vSERVER.withdrawMoney(plate,VehToNet(vehicle))
					end
				end
			end
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FREEZEPLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.freezePlayers(status)
	FreezeEntityPosition(PlayerPedId(),status)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_STOCKADE:DESTROY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_stockade:Destroy")
AddEventHandler("vrp_stockade:Destroy",function(vehNet)
	if NetworkDoesNetworkIdExist(vehNet) then
		local v = NetToEnt(vehNet)
		if DoesEntityExist(v) then
			SetVehicleEngineHealth(v,100.0)
			SetVehicleBodyHealth(v,100.0)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_STOCKADE:CLIENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_stockade:Client")
AddEventHandler("vrp_stockade:Client",function(status)
	blockStockades = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DWTEXT
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
	local factor = (string.len(text)) / 450
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,100)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETNEARVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
function getNearVehicles(radius)
	local r = {}
	local coords = GetEntityCoords(PlayerPedId())

	local vehs = {}
	local it,veh = FindFirstVehicle()
	if veh then
		table.insert(vehs,veh)
	end
	local ok
	repeat
		ok,veh = FindNextVehicle(it)
		if ok and veh then
			table.insert(vehs,veh)
		end
	until not ok
	EndFindVehicle(it)

	for _,veh in pairs(vehs) do
		local coordsVeh = GetEntityCoords(veh)
		local distance = #(coords - coordsVeh)
		if distance <= radius then
			r[veh] = distance
		end
	end
	return r
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETNEARVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function getNearVehicle(radius)
	local veh
	local vehs = getNearVehicles(radius)
	local min = radius + 0.0001
	for _veh,dist in pairs(vehs) do
		if dist < min then
			min = dist
			veh = _veh
		end
	end
	return veh 
end