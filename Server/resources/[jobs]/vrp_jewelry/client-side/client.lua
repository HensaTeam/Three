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
Tunnel.bindInterface("vrp_jewelry",cRP)
vSERVER = Tunnel.getInterface("vrp_jewelry")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local jewelryStart = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- BOMBLOCS
-----------------------------------------------------------------------------------------------------------------------------------------
local bombLocs = {
	{ -631.29,-237.43,38.08,305.32 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAFELOCS
-----------------------------------------------------------------------------------------------------------------------------------------
local safeLocs = {
	{ -627.94,-233.9,38.06,212.97 },
	{ -626.93,-233.13,38.06,215.44 },
	{ -626.84,-235.34,38.06,32.47 },
	{ -625.75,-234.55,38.06,33.49 },
	{ -626.69,-238.6,38.06,214.93 },
	{ -625.66,-237.85,38.06,213.92 },
	{ -623.08,-232.92,38.06,302.81 },
	{ -620.15,-233.33,38.06,36.1 },
	{ -619.71,-230.45,38.06,125.35 },
	{ -621.03,-228.58,38.06,125.23 },
	{ -623.97,-228.18,38.06,215.36 },
	{ -624.41,-231.09,38.06,301.78 },
	{ -620.22,-234.46,38.06,216.98 },
	{ -619.21,-233.68,38.06,212.31 },
	{ -617.54,-230.53,38.06,303.03 },
	{ -618.28,-229.51,38.06,303.19 },
	{ -619.65,-227.63,38.06,304.16 },
	{ -620.39,-226.6,38.06,306.91 },
	{ -623.91,-227.07,38.06,33.11 },
	{ -624.96,-227.83,38.06,35.16 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- JEWELRYROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

		if not jewelryStart then

			for k,v in pairs(bombLocs) do
				local distance = #(coords - vector3(v[1],v[2],v[3]))
				if distance <= 2 then
					timeDistance = 4
					if IsControlJustPressed(1,47) and vSERVER.jewelryCheckItens() then
						local mHash = GetHashKey("prop_c4_final_green")

						RequestModel(mHash)
						while not HasModelLoaded(mHash) do
							RequestModel(mHash)
							Citizen.Wait(10)
						end

						local bomb = CreateObjectNoOffset(mHash,v[1],v[2],v[3],true,false,false)
						SetEntityAsMissionEntity(bomb,true,true)
						FreezeEntityPosition(bomb,true)
						SetEntityHeading(bomb,v[4])
						SetModelAsNoLongerNeeded(mHash)

						Citizen.Wait(20000)

						TriggerServerEvent("vrp_doors:doorsStatistics",17,false)
						TriggerServerEvent("tryDeleteEntity",ObjToNet(bomb))
						AddExplosion(v[1],v[2],v[3],2,100.0,true,false,true)
						vSERVER.jewelryUpdateStatus(true)
					end
				end
			end
		else
			for k,v in pairs(safeLocs) do
				local distance = #(coords - vector3(v[1],v[2],v[3]))
				if distance <= 2 then
					timeDistance = 4
					DrawText3Ds(v[1],v[2],v[3],"~g~E~w~   ROUBAR")
					if distance <= 0.6 and IsControlJustPressed(1,38) then
						SetEntityHeading(ped,v[4])
						vSERVER.openDrawer(k)
					end
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- JEWELRYFUNCTIONSTART
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_jewelry:jewelryFunctionStart")
AddEventHandler("vrp_jewelry:jewelryFunctionStart",function(status)
	jewelryStart = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3Ds(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,100)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text))/400
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,100)
end