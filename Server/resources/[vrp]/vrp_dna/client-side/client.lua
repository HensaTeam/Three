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
Tunnel.bindInterface("vrp_dna",cRP)
vSERVER = Tunnel.getInterface("vrp_dna")
-----------------------------------------------------------------------------------------------------------------------------------------
-- DNALIST
-----------------------------------------------------------------------------------------------------------------------------------------
local dnaList = {}
local dnaGrids = {}
local lastResult = "Nenhum"
local dnaX,dnaY,dnaZ = 312.933,-562.295,43.49
local dnaDeltas = { vector2(-1,-1),vector2(-1,0),vector2(-1,1),vector2(0,-1),vector2(1,-1),vector2(1,0),vector2(1,1),vector2(0,1) }
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMUPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_dna:dnaUpdates")
AddEventHandler("vrp_dna:dnaUpdates",function(status)
	dnaList = status

	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	dnaGrids = {}
	for k,v in ipairs(dnaDeltas) do
		local h = coords.xy + (v * 20)
		dnaGrids[toChannel(vector2(gridChunk(h.x),gridChunk(h.y)))] = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETGRIDCHUNK
-----------------------------------------------------------------------------------------------------------------------------------------
function gridChunk(x)
	return math.floor((x + 8192) / 128)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOCHANNEL
-----------------------------------------------------------------------------------------------------------------------------------------
function toChannel(v)
	return (v.x << 8) | v.y
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADDNA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) and (GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_FLASHLIGHT") and IsPlayerFreeAiming(PlayerId())) or (GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_PETROLCAN") and IsPedShooting(ped)) then
			local coords = GetEntityCoords(ped)

			for grid,v in pairs(dnaGrids) do
				if dnaList[grid] then
					for k,v in pairs(dnaList[grid]) do
						local distance = #(coords - vector3(v[1],v[2],v[3]))
						if distance <= 3 then
							timeDistance = 4
							DrawText3D(v[1],v[2],v[3]+0.2,"~y~"..grid.."   ~w~"..k,500)
							DrawMarker(28,v[1],v[2],v[3]+0.05,0,0,0,180.0,0,0,0.04,0.04,0.04,v[4],v[5],v[6],100,0,0,0,0)
							if distance <= 1.2 and GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_PETROLCAN") and IsPedShooting(ped) then
								TriggerServerEvent("vrp_dna:removeDna",grid,k)
							end
						end
					end
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LASTRESULT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_dna:lastResult")
AddEventHandler("vrp_dna:lastResult",function(status)
	lastResult = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADRESULT
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)
			local distance = #(coords - vector3(dnaX,dnaY,dnaZ))
			if distance <= 3 then
				timeDistance = 4
				DrawText3D(dnaX,dnaY,dnaZ,"~w~"..string.upper(lastResult),300)
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKDISTANCE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkDistance()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local distance = #(coords - vector3(dnaX,dnaY,dnaZ))
	if distance <= 2 then
		return true
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKDISTANCE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getPostions()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local gridChunk = vector2(gridChunk(coords.x),gridChunk(coords.y))
	local _,cdz = GetGroundZFor_3dCoord(coords.x,coords.y,coords.z)

	return coords.x,coords.y,cdz,toChannel(gridChunk)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x,y,z,text,width)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,100)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / width
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,125)
end