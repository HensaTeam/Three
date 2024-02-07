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
Tunnel.bindInterface("vrp_gangs",cRP)
vSERVER = Tunnel.getInterface("vrp_gangs")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local maxPackage = 100
local boxVehicles = {}
local inPackage = false
local handPackage = false
local inService = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- GANGS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("gangs",function(source,args)
	if GetEntityHealth(PlayerPedId()) > 101 then
		if inService then
			inService = false
			TriggerEvent("Notify","sucesso","Sistema desativado com sucesso.",5000)
		else
			inService = true
			TriggerEvent("Notify","sucesso","Sistema ativado com sucesso.",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
local functions = {
	{ 1417.1,6339.17,24.4,-159.89,-1636.28,37.25 }, -- ECSTASY
	{ 3725.43,4525.73,22.48,-830.41,-420.58,36.77 }, -- FUELTECH
	{ -1593.11,5202.99,4.32,75.77,-1970.07,21.13 } -- LEAN
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTOCKADE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 1000
		if inService then
			local ped = PlayerPedId()

			if not IsPedInAnyVehicle(ped) then
				local vehicle = getNearVehicle(11)

				if DoesEntityExist(vehicle) and GetEntityModel(vehicle) == GetHashKey("gburrito2") then
					local coordsPed = GetEntityCoords(ped)
					local plate = GetVehicleNumberPlateText(vehicle)
					local coords = GetOffsetFromEntityInWorldCoords(vehicle,0.0,-2.5,0.0)
					local distance = #(coords - coordsPed)
					if distance <= 1.2 then
						timeDistance = 4

						if inPackage then
							if boxVehicles[plate] == nil then
								DrawText3D(coords.x,coords.y,coords.z,"~g~E~w~   GUARDAR SUPRIMENTOS\nTOTAL DE SUPRIMENTOS:  0/"..maxPackage)
							else
								DrawText3D(coords.x,coords.y,coords.z,"~g~E~w~   GUARDAR SUPRIMENTOS\nTOTAL DE SUPRIMENTOS:  "..boxVehicles[plate].."/"..maxPackage)
							end

							if IsControlJustPressed(1,38) and vSERVER.addPackage(plate) then
								inPackage = false
								handPackage = false
								vRP.removeObjects("one")
							end
						else
							if boxVehicles[plate] == nil then
								DrawText3D(coords.x,coords.y,coords.z,"~g~E~w~   RETIRAR SUPRIMENTOS\nTOTAL DE SUPRIMENTOS:  0/"..maxPackage)
							else
								DrawText3D(coords.x,coords.y,coords.z,"~g~E~w~   RETIRAR SUPRIMENTOS\nTOTAL DE SUPRIMENTOS:  "..boxVehicles[plate].."/"..maxPackage)
							end

							if IsControlJustPressed(1,38) and boxVehicles[plate] then
								if boxVehicles[plate] > 0 then
									inPackage = true
									handPackage = true
									TriggerServerEvent("vrp_gangs:remPackage",plate)
									vRP.createObjects("anim@heists@box_carry@","idle","hei_prop_heist_box",50,28422)
								end
							end
						end
					end
				end

				local coords = GetEntityCoords(ped)

				for k,v in pairs(functions) do
					local distance01 = #(coords - vector3(v[1],v[2],v[3]))
					local distance02 = #(coords - vector3(v[4],v[5],v[6]))
					if distance01 <= 2 then
						timeDistance = 4

						if distance01 <= 0.6 and IsControlJustPressed(1,38) then
							if inPackage then
								inPackage = false
								vRP.removeObjects("one")
							else
								inPackage = true
								vRP.createObjects("anim@heists@box_carry@","idle","hei_prop_heist_box",50,28422)
							end
						end
					end

					if distance02 <= 2 and handPackage then
						timeDistance = 4
						if distance02 <= 0.6 and IsControlJustPressed(1,38) then
							inPackage = false
							handPackage = false
							vSERVER.paymentMethod(k)
							vRP.removeObjects("one")
						end
					end
				end
			end
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_GANGS:THREADBLOCK
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if inPackage then
			timeDistance = 4
			DisableControlAction(1,245,true)
			DisableControlAction(1,167,true)
			DisableControlAction(1,21,true)
			DisableControlAction(1,22,true)
			DisableControlAction(1,23,true)
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_GANGS:UPDATEPACKAGE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_gangs:updatePackage")
AddEventHandler("vrp_gangs:updatePackage",function(status)
	boxVehicles = status
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
	local factor = (string.len(text)) / 550
	DrawRect(_x,_y+0.0225,0.01+factor,0.06,0,0,0,100)
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
		local distance = #(coordsVeh - coords)
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