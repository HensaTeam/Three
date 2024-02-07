-----------------------------------------------------------------------------------------------------------------------------------------
-- DISPATCH
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	for i = 1,12 do
		EnableDispatchService(i,false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TYREBURST
-----------------------------------------------------------------------------------------------------------------------------------------
local oldSpeed = 0
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
			timeDistance = 4
			SetPedHelmet(ped,false)
			DisableControlAction(0,345,true)
			local veh = GetVehiclePedIsUsing(ped)
			if GetPedInVehicleSeat(veh,-1) == ped then
				local speed = GetEntitySpeed(veh) * 2.236936
				if speed ~= oldSpeed then
					if (oldSpeed - speed) >= 60 then
						TriggerServerEvent("upgradeStress",10)
						if GetVehicleClass(veh) ~= 8 then
							vehicleTyreBurst(veh)
						end
					end
					oldSpeed = speed
				end
			end
		else
			oldSpeed = 0
		end

		Citizen.Wait(timeDistance)
	end
end)

-----------------------------------------
----------- Desativar o Q ---------------
-----------------------------------------

Citizen.CreateThread(function()
    while true do
    local timeDistance = 100
        Citizen.Wait(1)
        local ped = PlayerPedId()
        local health = GetEntityHealth(ped)
        if health >= 101 then
        timeDistance = 4
        DisableControlAction(0,44,true)
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- EMPURRAR
-----------------------------------------------------------------------------------------------------------------------------------------
local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end
		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc,moveFunc,disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = { handle = iter, destructor = disposeFunc }
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		coroutine.yield(id)
		next,id = moveFunc(iter)
		until not next

		enum.destructor,enum.handle = nil,nil
		disposeFunc(iter)
	end)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle,FindNextVehicle,EndFindVehicle)
end

function GetVeh()
    local vehicles = {}
    for vehicle in EnumerateVehicles() do
        table.insert(vehicles,vehicle)
    end
    return vehicles
end

function GetClosestVeh(coords)
	local vehicles = GetVeh()
	local closestDistance = -1
	local closestVehicle = -1
	local coords = coords

	if coords == nil then
		local ped = PlayerPedId()
		coords = GetEntityCoords(ped)
	end

	for i=1,#vehicles,1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance = GetDistanceBetweenCoords(vehicleCoords,coords.x,coords.y,coords.z,true)
		if closestDistance == -1 or closestDistance > distance then
			closestVehicle  = vehicles[i]
			closestDistance = distance
		end
	end
	return closestVehicle,closestDistance
end

local First = vector3(0.0,0.0,0.0)
local Second = vector3(5.0,5.0,5.0)
local Vehicle = { Coords = nil, Vehicle = nil, Dimension = nil, IsInFront = false, Distance = nil }

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local closestVehicle,Distance = GetClosestVeh()
		if Distance < 6.1 and not IsPedInAnyVehicle(ped) then
			Vehicle.Coords = GetEntityCoords(closestVehicle)
			Vehicle.Dimensions = GetModelDimensions(GetEntityModel(closestVehicle),First,Second)
			Vehicle.Vehicle = closestVehicle
			Vehicle.Distance = Distance
			if GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle), GetEntityCoords(ped), true) > GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle) * -1, GetEntityCoords(ped), true) then
				Vehicle.IsInFront = false
			else
				Vehicle.IsInFront = true
			end
		else
			Vehicle = { Coords = nil, Vehicle = nil, Dimensions = nil, IsInFront = false, Distance = nil }
		end
		Citizen.Wait(500)
	end
end)

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(500)
		if Vehicle.Vehicle ~= nil then
			local ped = PlayerPedId()
			if IsControlPressed(0,244) and GetEntityHealth(ped) > 100 and IsVehicleSeatFree(Vehicle.Vehicle,-1) and not IsEntityAttachedToEntity(ped,Vehicle.Vehicle) and not (GetEntityRoll(Vehicle.Vehicle) > 75.0 or GetEntityRoll(Vehicle.Vehicle) < -75.0) then
				RequestAnimDict('missfinale_c2ig_11')
				TaskPlayAnim(ped,'missfinale_c2ig_11','pushcar_offcliff_m',2.0,-8.0,-1,35,0,0,0,0)
				NetworkRequestControlOfEntity(Vehicle.Vehicle)

				if Vehicle.IsInFront then
					AttachEntityToEntity(ped,Vehicle.Vehicle,GetPedBoneIndex(6286),0.0,Vehicle.Dimensions.y*-1+0.1,Vehicle.Dimensions.z+1.0,0.0,0.0,180.0,0.0,false,false,true,false,true)
				else
					AttachEntityToEntity(ped,Vehicle.Vehicle,GetPedBoneIndex(6286),0.0,Vehicle.Dimensions.y-0.3,Vehicle.Dimensions.z+1.0,0.0,0.0,0.0,0.0,false,false,true,false,true)
				end

				while true do
					Citizen.Wait(5)
					if IsDisabledControlPressed(0,34) then
						TaskVehicleTempAction(ped,Vehicle.Vehicle,11,100)
					end

					if IsDisabledControlPressed(0,9) then
						TaskVehicleTempAction(ped,Vehicle.Vehicle,10,100)
					end

					if Vehicle.IsInFront then
						SetVehicleForwardSpeed(Vehicle.Vehicle,-1.0)
					else
						SetVehicleForwardSpeed(Vehicle.Vehicle,1.0)
					end

					if not IsDisabledControlPressed(0,244) then
						DetachEntity(ped,false,false)
						StopAnimTask(ped,'missfinale_c2ig_11','pushcar_offcliff_m',2.0)
						break
					end
				end
			end
		end
	end
end)
------------------------------------------------------------------------
-- THREADGLOBAL - 0
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
	SetAudioFlag("PoliceScannerDisabled",true)

	while true do
		Citizen.Wait(0)

		SetRandomBoats(false)
		SetGarbageTrucks(false)
		SetCreateRandomCops(false)
		SetCreateRandomCopsOnScenarios(false)
		SetCreateRandomCopsNotOnScenarios(false)

		DisableVehicleDistantlights(true)
		-- SetPedDensityMultiplierThisFrame(0.0)
		SetVehicleDensityMultiplierThisFrame(0.75)
		SetParkedVehicleDensityMultiplierThisFrame(0.75)
		-- SetScenarioPedDensityMultiplierThisFrame(0.0,0.0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLETYREBURST
-----------------------------------------------------------------------------------------------------------------------------------------
function vehicleTyreBurst(vehicle)
	local tyre = math.random(4)
	if tyre == 1 then
		if not IsVehicleTyreBurst(vehicle,0,false) then
			SetVehicleTyreBurst(vehicle,0,true,1000.0)
		end
	elseif tyre == 2 then
		if not IsVehicleTyreBurst(vehicle,1,false) then
			SetVehicleTyreBurst(vehicle,1,true,1000.0)
		end
	elseif tyre == 3 then
		if not IsVehicleTyreBurst(vehicle,4,false) then
			SetVehicleTyreBurst(vehicle,4,true,1000.0)
		end
	elseif tyre == 4 then
		if not IsVehicleTyreBurst(vehicle,5,false) then
			SetVehicleTyreBurst(vehicle,5,true,1000.0)
		end
	end

	if math.random(100) < 30 then
		Citizen.Wait(10)
		vehicleTyreBurst(vehicle)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = {
	{ -211.67,-1325.24,30.89,402,4,"TUNE BENNTS",0.4 },
	{ 265.05,-1262.65,29.3,361,4,"Posto de Gasolina",0.4 },
	{ 819.02,-1027.96,26.41,361,4,"Posto de Gasolina",0.4 },
	{ 1208.61,-1402.43,35.23,361,4,"Posto de Gasolina",0.4 },
	{ 1181.48,-330.26,69.32,361,4,"Posto de Gasolina",0.4 },
	{ 621.01,268.68,103.09,361,4,"Posto de Gasolina",0.4 },
	{ 2581.09,361.79,108.47,361,4,"Posto de Gasolina",0.4 },
	{ 175.08,-1562.12,29.27,361,4,"Posto de Gasolina",0.4 },
	{ -319.76,-1471.63,30.55,361,4,"Posto de Gasolina",0.4 },
	{ 1782.33,3328.46,41.26,361,4,"Posto de Gasolina",0.4 },
	{ 49.42,2778.8,58.05,361,4,"Posto de Gasolina",0.4 },
	{ 264.09,2606.56,44.99,361,4,"Posto de Gasolina",0.4 },
	{ 1039.38,2671.28,39.56,361,4,"Posto de Gasolina",0.4 },
	{ 1207.4,2659.93,37.9,361,4,"Posto de Gasolina",0.4 },
	{ 2539.19,2594.47,37.95,361,4,"Posto de Gasolina",0.4 },
	{ 2679.95,3264.18,55.25,361,4,"Posto de Gasolina",0.4 },
	{ 2005.03,3774.43,32.41,361,4,"Posto de Gasolina",0.4 },
	{ 1687.07,4929.53,42.08,361,4,"Posto de Gasolina",0.4 },
	{ 1701.53,6415.99,32.77,361,4,"Posto de Gasolina",0.4 },
	{ 180.1,6602.88,31.87,361,4,"Posto de Gasolina",0.4 },
	{ -94.46,6419.59,31.48,361,4,"Posto de Gasolina",0.4 },
	{ -2555.17,2334.23,33.08,361,4,"Posto de Gasolina",0.4 },
	{ -1800.09,803.54,138.72,361,4,"Posto de Gasolina",0.4 },
	{ -1437.0,-276.8,46.21,361,4,"Posto de Gasolina",0.4 },
	{ -2096.3,-320.17,13.17,361,4,"Posto de Gasolina",0.4 },
	{ -724.56,-935.97,19.22,361,4,"Posto de Gasolina",0.4 },
	{ -525.26,-1211.19,18.19,361,4,"Posto de Gasolina",0.4 },
	{ -70.96,-1762.21,29.54,361,4,"Posto de Gasolina",0.4 },
	{ 298.43,-584.54,43.27,80,1,"Hospital",0.5 },
	{ 55.43,-876.19,30.66,357,4,"Garagem",0.6 },
	{ 317.25,2623.14,44.46,357,4,"Garagem",0.6 },
	{ -773.34,5598.15,33.60,357,4,"Garagem",0.6 },
	{ 275.23,-345.54,45.17,357,4,"Garagem",0.6 },
	{ 596.40,90.65,93.12,357,4,"Garagem",0.6 },
	{ -340.76,265.97,85.67,357,4,"Garagem",0.6 },
	{ -2030.01,-465.97,11.60,357,4,"Garagem",0.6 },
	{ -1184.92,-1510.00,4.64,357,4,"Garagem",0.6 },
	{ -73.44,-2004.99,18.27,357,4,"Garagem",0.6 },
	{ 214.02,-808.44,31.01,357,4,"Garagem",0.6 },
	{ -348.88,-874.02,31.31,357,4,"Garagem",0.6 },
	{ 67.74,12.27,69.21,357,4,"Garagem",0.6 },
	{ 361.90,297.81,103.88,357,4,"Garagem",0.6 },
	{ 1035.89,-763.89,57.99,357,4,"Garagem",0.6 },
	{ -796.63,-2022.77,9.16,357,4,"Garagem",0.6 },
	{ 453.27,-1146.76,29.52,357,4,"Garagem",0.6 },
	{ 528.66,-146.3,58.38,357,4,"Garagem",0.6 },
	{ -1159.48,-739.32,19.89,357,4,"Garagem",0.6 },
	{ 29.29,-1770.35,29.61,357,4,"Garagem",0.6 },
	{ 101.22,-1073.68,29.38,357,4,"Garagem",0.6 },
	{ 440.5,-982.12,30.69,60,4,"Departamento Policial",0.6 },
	{ 1851.45,3686.71,34.26,60,4,"Departamento Policial",0.6 },
	{ -448.18,6011.68,31.71,60,4,"Departamento Policial",0.6 },
	{ 25.68,-1346.6,29.5,52,4,"Loja de Departamento",0.5 },
	{ 2556.47,382.05,108.63,52,4,"Loja de Departamento",0.5 },
	{ 1163.55,-323.02,69.21,52,4,"Loja de Departamento",0.5 },
	{ -707.31,-913.75,19.22,52,4,"Loja de Departamento",0.5 },
	{ -47.72,-1757.23,29.43,52,4,"Loja de Departamento",0.5 },
	{ 373.89,326.86,103.57,52,4,"Loja de Departamento",0.5 },
	{ -3242.95,1001.28,12.84,52,4,"Loja de Departamento",0.5 },
	{ 1729.3,6415.48,35.04,52,4,"Loja de Departamento",0.5 },
	{ 548.0,2670.35,42.16,52,4,"Loja de Departamento",0.5 },
	{ 1960.69,3741.34,32.35,52,4,"Loja de Departamento",0.5 },
	{ 2677.92,3280.85,55.25,52,4,"Loja de Departamento",0.5 },
	{ 1698.5,4924.09,42.07,52,4,"Loja de Departamento",0.5 },
	{ -1820.82,793.21,138.12,52,4,"Loja de Departamento",0.5 },
	{ 1393.21,3605.26,34.99,52,4,"Loja de Departamento",0.5 },
	{ -2967.78,390.92,15.05,52,4,"Loja de Departamento",0.5 },
	{ -3040.14,585.44,7.91,52,4,"Loja de Departamento",0.5 },
	{ 1135.56,-982.24,46.42,52,4,"Loja de Departamento",0.5 },
	{ 1166.0,2709.45,38.16,52,4,"Loja de Departamento",0.5 },
	{ -1487.21,-378.99,40.17,52,4,"Loja de Departamento",0.5 },
	{ -1222.76,-907.21,12.33,52,4,"Loja de Departamento",0.5 },
	{ -1591.94,-1005.99,13.03,52,4,"Peixaria",0.5 },
	{ 1692.62,3759.50,34.70,76,4,"Loja de Armas",0.4 },
	{ 252.89,-49.25,69.94,76,4,"Loja de Armas",0.4 },
	{ 843.28,-1034.02,28.19,76,4,"Loja de Armas",0.4 },
	{ -331.35,6083.45,31.45,76,4,"Loja de Armas",0.4 },
	{ -663.15,-934.92,21.82,76,4,"Loja de Armas",0.4 },
	{ -1305.18,-393.48,36.69,76,4,"Loja de Armas",0.4 },
	{ -1118.80,2698.22,18.55,76,4,"Loja de Armas",0.4 },
	{ 2568.83,293.89,108.73,76,4,"Loja de Armas",0.4 },
	{ -3172.68,1087.10,20.83,76,4,"Loja de Armas",0.4 },
	{ 21.32,-1106.44,29.79,76,4,"Loja de Armas",0.4 },
	{ 811.19,-2157.67,29.61,76,4,"Loja de Armas",0.4 },
	{ -1213.44,-331.02,37.78,207,4,"Banco",0.5 },
	{ -351.59,-49.68,49.04,207,4,"Banco",0.5 },
	{ 313.47,-278.81,54.17,207,4,"Banco",0.5 },
	{ 149.35,-1040.53,29.37,207,4,"Banco",0.5 },
	{ -2962.60,482.17,15.70,207,4,"Banco",0.5 },
	{ -112.81,6469.91,31.62,207,4,"Banco",0.5 },
	{ 1175.74,2706.80,38.09,207,4,"Banco",0.5 },
	{ -51.82,-1111.38,26.44,225,4,"Concessionaria",0.5 },
	{ -1258.66,-368.11,36.91,225,4,"Concessionaria Premium",0.5 },
	{ -815.12,-184.15,37.57,71,4,"Barbearia",0.5 },
	{ 138.13,-1706.46,29.3,71,4,"Barbearia",0.5 },
	{ -1280.92,-1117.07,7.0,71,4,"Barbearia",0.5 },
	{ 1930.54,3732.06,32.85,71,4,"Barbearia",0.5 },
	{ 1214.2,-473.18,66.21,71,4,"Barbearia",0.5 },
	{ -33.61,-154.52,57.08,71,4,"Barbearia",0.5 },
	{ -276.65,6226.76,31.7,71,4,"Barbearia",0.5 },
	{ 75.35,-1392.92,29.38,366,4,"Loja de Roupas",0.5 },
	{ -710.15,-152.36,37.42,366,4,"Loja de Roupas",0.5 },
	{ -163.73,-303.62,39.74,366,4,"Loja de Roupas",0.5 },
	{ -822.38,-1073.52,11.33,366,4,"Loja de Roupas",0.5 },
	{ -1193.13,-767.93,17.32,366,4,"Loja de Roupas",0.5 },
	{ -1449.83,-237.01,49.82,366,4,"Loja de Roupas",0.5 },
	{ 4.83,6512.44,31.88,366,4,"Loja de Roupas",0.5 },
	{ 1693.95,4822.78,42.07,366,4,"Loja de Roupas",0.5 },
	{ 125.82,-223.82,54.56,366,4,"Loja de Roupas",0.5 },
	{ 614.2,2762.83,42.09,366,4,"Loja de Roupas",0.5 },
	{ 1196.72,2710.26,38.23,366,4,"Loja de Roupas",0.5 },
	{ -3170.53,1043.68,20.87,366,4,"Loja de Roupas",0.5 },
	{ -1101.42,2710.63,19.11,366,4,"Loja de Roupas",0.5 },
	{ 425.6,-806.25,29.5,366,4,"Loja de Roupas",0.5 },
	{ -1082.22,-247.54,37.77,617,4,"Premium Store",0.6 },
	{ 468.11,-585.95,28.5,513,4,"Motorista",0.5 },
	{ 239.31,242.81,106.69,67,4,"Transportador",0.5 },
	{ 1196.79,-3253.65,7.1,67,4,"Caminhoneiro",0.5 },
	{ -424.24,-2789.72,6.53,67,4,"PostOp",0.5 },
	{ -837.97,5406.55,34.59,285,4,"farm Lenhador",0.5 },
	{ 1215.35,-1269.67,35.38,285,4,"Central Lenhador",0.5 },
	{ -1563.32,-975.79,13.02,68,4,"Pescador",0.5 },
	{ -1188.27,2727.94,2.4,68,4,"Pescador",0.5 },
	{ 132.6,-1305.06,29.2,93,4,"Bar",0.5 },
	{ -565.14,271.56,83.02,93,4,"Bar",0.5 },
	{ -342.92,-1564.29,25.24,318,4,"Lixeiro",0.7 },
	{ 306.74,-601.9,43.29,403,4,"Farmácia",0.7 },
	{ 46.66,-1749.79,29.64,78,4,"Mega Mall",0.5 },
	{ 11.12,-1605.65,29.4,79,4,"Tacos",0.4 },
	{ -428.56,-1728.33,19.79,467,4,"Reciclagem",0.6 },
	{ -741.56,5594.94,41.66,4,4,"Teleférico",0.6 },
	{ 454.46,5571.95,781.19,4,4,"Teleférico",0.6 },
	{ -653.38,-852.87,24.51,459,4,"Eletrônicos",0.6 },
	{ 392.7,-831.61,29.3,459,4,"Eletrônicos",0.6 },
	{ -41.37,-1036.79,28.49,459,4,"Eletrônicos",0.6 },
	{ -509.38,278.8,83.33,459,4,"Eletrônicos",0.6 },
	{ 1137.52,-470.69,66.67,459,4,"Eletrônicos",0.6 },
	{ 441.08,-1018.8,28.19,515,4,"Patio da policia",0.7 },
	{ 909.8,-176.49,74.23,56,4,"Taxista",0.6 },
	 { 1322.64,-1651.97,52.27,75,4,"Tatuagens",0.4 },
    { -1153.67,-1425.68,4.95,75,4,"Tatuagens",0.4 },
    { 322.13,180.46,103.58,75,4,"Tatuagens",0.4 },
    { -3170.07,1075.05,20.82,75,4,"Tatuagens",0.4 },
    { 1864.63,3747.73,33.03,75,4,"Tatuagens",0.4 },
    { 546.08,-183.37,54.5,402,4,"Auto exotic",0.4 },
    { -1172.08,-1572.67,4.67,140,25,"Marconha store",0.4 },
	{ 546.33,-143.41,58.7,515,4,"Reboque",0.7 },
    { -293.71,6200.04,31.48,75,4,"Tatuagens",0.4 },
	{ 2952.5,2790.54,41.31,617,4,"Mina",0.6 },
	{ -1586.51,5199.35,3.99,79,5,"Tesouro",0.6 },
	{ 2679.43,3443.93,55.81,38,4,"Corrida",0.5 },
	{ -566.72,-2117.39,5.98,38,4,"Corrida",0.5 },
	{ 1679.4,-1564.53,112.57,38,4,"Corrida",0.5 },
	{ -1732.07,-727.34,10.4,38,4,"Corrida",0.5 }
}

Citizen.CreateThread(function()
	for _,v in pairs(blips) do
		local blip = AddBlipForCoord(v[1],v[2],v[3])
		SetBlipSprite(blip,v[4])
		SetBlipAsShortRange(blip,true)
		SetBlipColour(blip,v[5])
		SetBlipScale(blip,v[7])
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v[6])
		EndTextCommandSetBlipName(blip)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECOIL
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()

		if IsPedArmed(ped,6) then
			DisableControlAction(1,140,true)
			DisableControlAction(1,141,true)
			DisableControlAction(1,142,true)
			Citizen.Wait(1)
		else
			Citizen.Wait(1000)
		end

		if IsPedShooting(ped) then
			local cam = GetFollowPedCamViewMode()
			local veh = IsPedInAnyVehicle(ped)
			
			local speed = math.ceil(GetEntitySpeed(ped))
			if speed > 70 then
				speed = 70
			end

			local _,wep = GetCurrentPedWeapon(ped)
			local class = GetWeapontypeGroup(wep)
			local p = GetGameplayCamRelativePitch()
			local camDist = #(GetGameplayCamCoord() - GetEntityCoords(ped))

			local recoil = math.random(110,120+(math.ceil(speed*0.5)))/100
			local rifle = false

			if class == 970310034 or class == 1159398588 then
				rifle = true
			end

			if camDist < 5.3 then
				camDist = 1.5
			else
				if camDist < 8.0 then
					camDist = 4.0
				else
					camDist =  7.0
				end
			end

			if veh then
				recoil = recoil + (recoil * camDist)
			else
				recoil = recoil * 0.1
			end

			if cam == 4 then
				recoil = recoil * 0.6
				if rifle then
					recoil = recoil * 0.1
				end
			end

			if rifle then
				recoil = recoil * 0.6
			end

			local spread = math.random(4)
			local h = GetGameplayCamRelativeHeading()
			local hf = math.random(10,40+speed) / 100

			if veh then
				hf = hf * 2.0
			end

			if spread == 1 then
				SetGameplayCamRelativeHeading(h+hf)
			elseif spread == 2 then
				SetGameplayCamRelativeHeading(h-hf)
			end

			local set = p + recoil
			SetGameplayCamRelativePitch(set,0.8)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADGLOBAL - 1000
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		N_0xf4f2c0d4ee209e20()
		DistantCopCarSirens(false)

		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_PISTOL50"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_REVOLVER"),0.4)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_PISTOL"),0.8)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_PISTOL_MK2"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_COMBATPISTOL"),0.8)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_FLASHLIGHT"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_NIGHTSTICK"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HATCHET"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_KNIFE"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BAT"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BATTLEAXE"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BOTTLE"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_CROWBAR"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_DAGGER"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_GOLFCLUB"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HAMMER"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MACHETE"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_POOLCUE"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_STONE_HATCHET"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SWITCHBLADE"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_WRENCH"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_KNUCKLE"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_COMPACTRIFLE"),0.4)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_APPISTOL"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HEAVYPISTOL"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MACHINEPISTOL"),0.7)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MICROSMG"),0.7)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MINISMG"),0.7)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SNSPISTOL"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SNSPISTOL_MK2"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_VINTAGEPISTOL"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_CARBINERIFLE"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_ASSAULTRIFLE"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_ASSAULTRIFLE_MK2"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_ASSAULTSMG"),0.7)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_GUSENBERG"),0.7)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SAWNOFFSHOTGUN"),1.3)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_PUMPSHOTGUN"),2.0)

		--ClearAreaOfPeds(GetEntityCoords(PlayerPedId()),1000.0,1)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADGLOBAL - 5
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		HideHudComponentThisFrame(1)
		HideHudComponentThisFrame(2)
		HideHudComponentThisFrame(3)
		HideHudComponentThisFrame(4)
		HideHudComponentThisFrame(5)
		HideHudComponentThisFrame(6)
		HideHudComponentThisFrame(7)
		HideHudComponentThisFrame(8)
		HideHudComponentThisFrame(9)
		HideHudComponentThisFrame(10)
		HideHudComponentThisFrame(11)
		HideHudComponentThisFrame(12)
		HideHudComponentThisFrame(13)
		HideHudComponentThisFrame(15)
		HideHudComponentThisFrame(17)
		HideHudComponentThisFrame(18)
		HideHudComponentThisFrame(20)
		HideHudComponentThisFrame(21)
		HideHudComponentThisFrame(22)
		--DisableControlAction(1,37,true)
		DisableControlAction(1,192,true)
		DisableControlAction(1,204,true)
		DisableControlAction(1,211,true)
		DisableControlAction(1,349,true)
		DisableControlAction(1,157,false)
		DisableControlAction(1,158,false)
		DisableControlAction(1,160,false)
		DisableControlAction(1,164,false)
		DisableControlAction(1,165,false)
		DisableControlAction(1,159,false)
		DisableControlAction(1,161,false)
		DisableControlAction(1,162,false)
		DisableControlAction(1,163,false)
		
		RemoveAllPickupsOfType(GetHashKey("PICKUP_WEAPON_KNIFE"))
		RemoveAllPickupsOfType(GetHashKey("PICKUP_WEAPON_PISTOL"))
		RemoveAllPickupsOfType(GetHashKey("PICKUP_WEAPON_MINISMG"))
		RemoveAllPickupsOfType(GetHashKey("PICKUP_WEAPON_PUMPSHOTGUN"))
		RemoveAllPickupsOfType(GetHashKey("PICKUP_WEAPON_CARBINERIFLE"))

		DisablePlayerVehicleRewards(PlayerId())

		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			SetPedInfiniteAmmo(ped,true,"WEAPON_FIREEXTINGUISHER")
		end
		Citizen.Wait(5)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADGLOBAL - 0
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
	SetAudioFlag("PoliceScannerDisabled",true)

	while true do
		Citizen.Wait(0)

		SetRandomBoats(false)
		SetGarbageTrucks(false)
		SetCreateRandomCops(false)
		SetCreateRandomCopsOnScenarios(false)
		SetCreateRandomCopsNotOnScenarios(false)

		DisableVehicleDistantlights(true)
		-- SetPedDensityMultiplierThisFrame(0.0)
		SetVehicleDensityMultiplierThisFrame(0.25)
		SetParkedVehicleDensityMultiplierThisFrame(0.25)
		-- SetScenarioPedDensityMultiplierThisFrame(0.0,0.0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADGLOBAL - 10
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		RemoveVehiclesFromGeneratorsInArea(65.95 - 5.0,-1719.34 - 5.0,29.32 - 5.0,65.95 + 5.0,-1719.34 + 5.0,29.32 + 5.0)
		RemoveVehiclesFromGeneratorsInArea(115.57 - 5.0,-1758.6 - 5.0,29.34 - 5.0,115.57 + 5.0,-1758.6 + 5.0,29.34 + 5.0)
		RemoveVehiclesFromGeneratorsInArea(-4.02 - 5.0,-1533.7 - 5.0,29.63 - 5.0,-4.02 + 5.0,-1533.7 + 5.0,29.63 + 5.0)
		RemoveVehiclesFromGeneratorsInArea(100.79 - 5.0,-1605.9 - 5.0,29.52 - 5.0,100.79 + 5.0,-1605.9 + 5.0,29.52 + 5.0)
		RemoveVehiclesFromGeneratorsInArea(43.77 - 5.0,-1288.61 - 5.0,29.15 - 5.0,43.77 + 5.0,-1288.61 + 5.0,29.15 + 5.0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- IPLOADER
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	LoadInterior(GetInteriorAtCoords(313.36,-591.02,43.29))
	LoadInterior(GetInteriorAtCoords(440.84,-983.14,30.69))
	LoadInterior(GetInteriorAtCoords(1768.09,3327.09,41.45))
	for _,v in pairs(allIpls) do
		loadInt(v.coords,v.interiorsProps)
	end
end)

function loadInt(coordsTable,table)
	for _,v in pairs(coordsTable) do
		local interior = GetInteriorAtCoords(v[1],v[2],v[3])
		LoadInterior(interior)
		for _,i in pairs(table) do
			EnableInteriorProp(interior,i)
			Citizen.Wait(10)
		end
		RefreshInterior(interior)
	end
end

allIpls = {
	{
		interiorsProps = {
			"swap_clean_apt",
			"layer_debra_pic",
			"layer_whiskey",
			"swap_sofa_A"
		},
		coords = {{ -1150.7,-1520.7,10.6 }}
	},{
		interiorsProps = {
			"csr_beforeMission",
			"csr_inMission"
		},
		coords = {{ -47.1,-1115.3,26.5 }}
	},{
		interiorsProps = {
			"V_Michael_bed_tidy",
			"V_Michael_M_items",
			"V_Michael_D_items",
			"V_Michael_S_items",
			"V_Michael_L_Items"
		},
		coords = {{ -802.3,175.0,72.8 }}
	},{
		interiorsProps = {
			"meth_lab_production",
			"meth_lab_upgrade",
			"meth_lab_setup"
		},
		coords = {{ 38.49,3714.1,11.01 }}
	}--,{
		--interiorsProps = {
		--	"branded_style_set",
		--	"car_floor_hatch"
		--},
		--coords = {{ 941.00,-972.66,39.14 }}
	--}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TASERTIME
-----------------------------------------------------------------------------------------------------------------------------------------
local tasertime = false
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()

		if IsPedBeingStunned(ped) then
			timeDistance = 4
			SetPedToRagdoll(ped,7500,7500,0,0,0,0)
		end

		if IsPedBeingStunned(ped) and not tasertime then
			tasertime = true
			timeDistance = 4
			TriggerEvent("cancelando",true)
			ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE",1.0)
		elseif not IsPedBeingStunned(ped) and tasertime then
			tasertime = false
			Citizen.Wait(7500)
			StopGameplayCamShaking()
			TriggerEvent("cancelando",false)
		end

		Citizen.Wait(timeDistance)
	end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
    local ped = PlayerPedId()
        if IsPedArmed(ped, 6) then
       DisableControlAction(1, 140, true)
              DisableControlAction(1, 141, true)
           DisableControlAction(1, 142, true)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
local teleport = {
	{ 338.65,-583.87,74.17,330.37,-600.86,43.29,"DESCER" },
	{330.3,-601.23,43.29,338.65,-583.87,74.17,"SUBIR" },
--330.28,-601.18,43.29,90.34
	{ 332.26,-595.6,43.29,359.55,-584.95,28.82,"DESCER" },
	{ 359.55,-584.95,28.82,332.26,-595.6,43.29,"SUBIR" },

	{ 253.96,225.2,101.88,252.3,220.23,101.69,"ENTRAR" },
	{ 252.3,220.23,101.69,253.96,225.2,101.88,"SAIR" },

	{ 4.58,-705.95,45.98,-139.85,-627.0,168.83,"ENTRAR" },
	{ -139.85,-627.0,168.83,4.58,-705.95,45.98,"SAIR" },

	{ -117.29,-604.52,36.29,-74.48,-820.8,243.39,"ENTRAR" },
	{ -74.48,-820.8,243.39,-117.29,-604.52,36.29,"SAIR" },

	{ -826.9,-699.89,28.06,-1575.14,-569.15,108.53,"ENTRAR" },
	{ -1575.14,-569.15,108.53,-826.9,-699.89,28.06,"SAIR" },

	{ -935.68,-378.77,38.97,-1386.84,-478.56,72.05,"ENTRAR" },
	{ -1386.84,-478.56,72.05,-935.68,-378.77,38.97,"SAIR" },

	{ -741.07,5593.13,41.66,446.19,5568.79,781.19,"SUBIR" },
	{ 446.19,5568.79,781.19,-741.07,5593.13,41.66,"DESCER" },

	{ -740.78,5597.04,41.66,446.37,5575.02,781.19,"SUBIR" },
	{ 446.37,5575.02,781.19,-740.78,5597.04,41.66,"DESCER" },

	{ 40.69,3715.73,39.68,28.1,3711.62,13.6,"ENTRAR" },
	{ 28.1,3711.62,13.6,40.69,3715.73,39.68,"SAIR" },

	{ 241.14,-1378.93,33.75,275.8,-1361.48,24.54,"ENTRAR" },
	{ 275.8,-1361.48,24.54,241.14,-1378.93,33.75,"SAIR" },

	{ 232.89,-411.39,48.12,224.63,-360.7,-98.78,"ENTRAR" },
	{ 224.63,-360.7,-98.78,232.89,-411.39,48.12,"SAIR" },

	{ 234.33,-387.57,-98.78,244.34,-429.14,-98.78,"ENTRAR" },
	{ 244.34,-429.14,-98.78,234.33,-387.57,-98.78,"SAIR" }
}

Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)
			for k,v in pairs(teleport) do
				local distance = #(coords - vector3(v[1],v[2],v[3]))
				if distance <= 2 then
					timeDistance = 4
					DrawText3D(v[1],v[2],v[3],"~g~E~w~   "..v[7])
					if IsControlJustPressed(1,38) then
						DoScreenFadeOut(1000)
						Citizen.Wait(2000)
						SetEntityCoords(ped,v[4],v[5],v[6])
						Citizen.Wait(1000)
						DoScreenFadeIn(1000)
					end
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
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
	local factor = (string.len(text)) / 450
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,100)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLESUPPRESSED
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	local SUPPRESSED_MODELS = { "SHAMAL","LUXOR","LUXOR2","JET","LAZER","TITAN","BARRACKS","BARRACKS2","CRUSADER","RHINO","AIRTUG","RIPLEY","PHANTOM","HAULER","RUBBLE","BIFF","TACO","PACKER","TRAILERS","TRAILERS2","TRAILERS3","TRAILERS4","BLIMP","POLMAV","MULE","MULE2","MULE3","MULE4" }
	while true do
		for _,model in next,SUPPRESSED_MODELS do
			SetVehicleModelIsSuppressed(GetHashKey(model),true)
		end
		Wait(10000)
	end
end)
---------------------------------------------------- 
--------------( NÃO ATIRAR AGACHADO )---------------
----------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = PlayerPedId()
        local player = PlayerId()
        if agachar then 
            DisablePlayerFiring(player, true)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        DisableControlAction(0,36,true)
        if not IsPedInAnyVehicle(ped) then
            RequestAnimSet("move_ped_crouched")
            RequestAnimSet("move_ped_crouched_strafing")
            if IsDisabledControlJustPressed(0,36) then
                if agachar then
                    ResetPedStrafeClipset(ped)
                    ResetPedMovementClipset(ped,0.25)
                    agachar = false
                else
                    SetPedStrafeClipset(ped,"move_ped_crouched_strafing")
                    SetPedMovementClipset(ped,"move_ped_crouched",0.25)
                    agachar = true
                end
            end
        end
    end
end) 