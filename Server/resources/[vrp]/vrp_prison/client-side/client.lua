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
Tunnel.bindInterface("vrp_prison",cRP)
vSERVER = Tunnel.getInterface("vrp_prison")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = nil
local prison = false
local numServices = 1
local prisonTimer = 0
local prisonLocal = 1
local showHud = true
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICES
-----------------------------------------------------------------------------------------------------------------------------------------
local services = {
	[1] = {
		[1] = { 444.15,-974.91,30.68,0.0,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[2] = { 442.95,-974.94,30.68,0.0,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[3] = { 452.06,-973.17,30.68,0.0,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[4] = { 448.8,-979.22,30.68,272.13,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[5] = { 440.88,-996.11,30.68,181.42,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[6] = { 442.13,-996.11,30.68,181.42,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[7] = { 448.12,-984.88,26.67,0.0,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[8] = { 446.97,-984.85,26.67,2.84,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[9] = { 442.61,-989.2,26.67,90.71,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[10] = { 442.59,-984.5,26.67,87.88,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[11] = { 429.2,-989.85,26.67,90.71,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[12] = { 429.25,-988.62,26.67,90.71,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[13] = { 429.2,-987.34,26.67,93.55,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[14] = { 429.2,-986.16,26.67,99.22,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[15] = { 432.65,-981.98,26.67,189.93,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[16] = { 427.26,-981.98,26.67,175.75,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[17] = { 449.06,-980.17,26.67,357.17,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[18] = { 447.64,-980.17,26.67,2.84,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[19] = { 459.29,-990.61,24.9,90.71,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[20] = { 459.28,-989.41,24.9,90.71,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[21] = { 477.76,-1006.16,24.9,175.75,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[22] = { 480.26,-1006.16,24.9,184.26,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[23] = { 467.82,-1006.23,24.9,178.59,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[24] = { 473.1,-1014.42,26.39,87.88,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[25] = { 434.4,-974.98,30.7,280.63,"amb@world_human_janitor@male@idle_a","idle_a","prop_tool_broom" },
		[26] = { 424.34,-978.36,30.7,110.56,"amb@world_human_janitor@male@idle_a","idle_a","prop_tool_broom" },
		[27] = { 437.11,-985.81,30.68,161.58,"amb@world_human_janitor@male@idle_a","idle_a","prop_tool_broom" },
		[28] = { 443.57,-976.76,30.68,357.17,"amb@world_human_janitor@male@idle_a","idle_a","prop_tool_broom" },
		[29] = { 450.55,-975.61,30.68,311.82,"amb@world_human_janitor@male@idle_a","idle_a","prop_tool_broom" },
		[30] = { 456.9,-990.96,30.68,263.63,"amb@world_human_janitor@male@idle_a","idle_a","prop_tool_broom" },
		[31] = { 439.75,-993.4,30.68,277.8,"amb@world_human_janitor@male@idle_a","idle_a","prop_tool_broom" },
		[32] = { 451.13,-986.53,26.67,266.46,"amb@world_human_janitor@male@idle_a","idle_a","prop_tool_broom" },
		[33] = { 444.88,-977.7,26.67,343.0,"amb@world_human_janitor@male@idle_a","idle_a","prop_tool_broom" },
		[34] = { 437.64,-981.63,26.67,306.15,"amb@world_human_janitor@male@idle_a","idle_a","prop_tool_broom" },
		[35] = { 458.56,-975.7,26.67,283.47,"amb@world_human_janitor@male@idle_a","idle_a","prop_tool_broom" },
		[36] = { 451.97,-980.05,26.67,153.08,"amb@world_human_janitor@male@idle_a","idle_a","prop_tool_broom" },
		[37] = { 462.85,-989.72,24.9,150.24,"amb@world_human_janitor@male@idle_a","idle_a","prop_tool_broom" },
		[38] = { 472.99,-990.36,24.9,272.13,"amb@world_human_janitor@male@idle_a","idle_a","prop_tool_broom" },
		[39] = { 464.35,-1000.24,24.9,235.28,"amb@world_human_janitor@male@idle_a","idle_a","prop_tool_broom" },
		[40] = { 476.5,-1001.81,24.9,255.12,"amb@world_human_janitor@male@idle_a","idle_a","prop_tool_broom" },
		[41] = { 474.94,-1014.09,26.39,184.26,"amb@world_human_janitor@male@idle_a","idle_a","prop_tool_broom" },
		[42] = { 440.15,-975.63,30.68,2.84,"anim@heists@prison_heiststation@cop_reactions","cop_b_idle",nil },
		[43] = { 442.54,-987.28,26.67,102.05,"anim@heists@prison_heiststation@cop_reactions","cop_b_idle",nil },
		[44] = { 430.24,-984.94,26.67,272.13,"anim@heists@prison_heiststation@cop_reactions","cop_b_idle",nil },
		[45] = { 433.57,-989.07,26.67,90.71,"anim@heists@prison_heiststation@cop_reactions","cop_b_idle",nil },
		[46] = { 430.79,-982.03,26.67,187.09,"anim@heists@prison_heiststation@cop_reactions","cop_b_idle",nil },
		[47] = { 470.26,-988.61,24.9,0.0,"anim@heists@prison_heiststation@cop_reactions","cop_b_idle",nil },
		[48] = { 477.72,-1006.21,24.9,181.42,"anim@heists@prison_heiststation@cop_reactions","cop_b_idle",nil }
	},
	[2] = {
		[1] = { 1679.65,2480.19,45.57,136.52,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[2] = { 1700.21,2474.81,45.57,228.39,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[3] = { 1706.99,2481.11,45.57,226.21,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[4] = { 1737.41,2504.68,45.57,166.44,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[5] = { 1760.65,2519.08,45.57,256.13,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[6] = { 1695.8,2536.22,45.57,90.09,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[7] = { 1652.46,2564.41,45.57,0.38,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[8] = { 1629.92,2564.38,45.57,1.6,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[9] = { 1624.51,2577.44,45.57,272.34,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[10] = { 1608.92,2566.89,45.57,43.79,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[11] = { 1609.91,2539.73,45.57,135.58,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[12] = { 1622.37,2507.73,45.57,97.58,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil },
		[13] = { 1643.92,2490.75,45.57,187.29,"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator",nil }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYSTEMTREAD
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if prison then
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			local distance = #(coords - vector3(services[prisonLocal][numServices][1],services[prisonLocal][numServices][2],services[prisonLocal][numServices][3]))

			if distance <= 10 then
				timeDistance = 4
				DrawMarker(21,services[prisonLocal][numServices][1],services[prisonLocal][numServices][2],services[prisonLocal][numServices][3]-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,240,202,87,50,0,0,0,1)
				if distance <= 1.5 then
					if IsControlJustPressed(1,38) and prisonTimer <= 0 then
						prisonTimer = 3
						TriggerEvent("cancelando",true)

						SetEntityHeading(ped,services[prisonLocal][numServices][4])

						if services[prisonLocal][numServices][7] == nil then
							vRP._playAnim(false,{services[prisonLocal][numServices][5],services[prisonLocal][numServices][6]},true)
						else
							vRP.createObjects(services[prisonLocal][numServices][5],services[prisonLocal][numServices][6],services[prisonLocal][numServices][7],49,28422)
						end

						SetEntityCoords(ped,services[prisonLocal][numServices][1],services[prisonLocal][numServices][2],services[prisonLocal][numServices][3]-1)

						SetTimeout(15000,function()
							vRP.removeObjects()
							vSERVER.reducePrison()
							TriggerEvent("cancelando",false)
						end)
					end
				end
			end

			if GetEntityHealth(ped) <= 101 then
				TriggerEvent("updatePrison")
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESSPRISON
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if prisonTimer > 0 then
			prisonTimer = prisonTimer - 1
		end
		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESSPRISON
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.startPrison(status)
	prison = true
	prisonLocal = status
	numServices = math.random(#services[prisonLocal])
	prisonBlips()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESSPRISON
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.stopPrison()
	prison = false
	if DoesBlipExist(blips) then
		RemoveBlip(blips)
		blips = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISTANCEPRISON
-----------------------------------------------------------------------------------------------------------------------------------------
local mrpd = PolyZone:Create({
	vector2(405.48,-1034.84),
	vector2(406.17,-962.54),
	vector2(411.99,-960.15),
	vector2(444.62,-960.54),
	vector2(488.36,-960.48),
	vector2(492.42,-961.36),
	vector2(495.29,-966.66),
	vector2(494.23,-1022.98)
},{ name="mrpd" })

Citizen.CreateThread(function()
	while true do
		if prison then
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			if prisonLocal == 1 then
				if not mrpd:isPointInside(coords) then
					SetEntityCoords(ped,448.43,-987.86,30.69)
					TriggerEvent("Notify","aviso","Nós achamos você tentando escapar.",5000)
				end
			else
				local distance = #(coords - vector3(1700.5,2605.2,45.5))
				if distance >= 200 then
					SetEntityCoords(ped,1677.72,2509.68,45.57)
					TriggerEvent("Notify","aviso","Nós achamos você tentando escapar.",5000)
				end
			end
		end
		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRISONBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
function prisonBlips()
	if DoesBlipExist(blips) then
		RemoveBlip(blips)
		blips = nil
	end

	blips = AddBlipForCoord(services[prisonLocal][numServices][1],services[prisonLocal][numServices][2],services[prisonLocal][numServices][3])
	SetBlipSprite(blips,1)
	SetBlipColour(blips,71)
	SetBlipScale(blips,0.6)
	SetBlipAsShortRange(blips,false)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Serviço")
	EndTextCommandSetBlipName(blips)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADGPS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		if ((IsPedInAnyVehicle(ped) and showHud) or prison) then
			if not IsMinimapRendering() then
				DisplayRadar(true)
			end
		else
			if IsMinimapRendering() then
				DisplayRadar(false)
			end
		end
		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_PRISON:SWITCHHUD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_prison:switchHud")
AddEventHandler("vrp_prison:switchHud",function(status)
	showHud = status
end)