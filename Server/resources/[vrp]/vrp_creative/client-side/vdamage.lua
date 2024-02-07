local pedInSameVehicleLast = false
local vehicle = nil
local lastVehicle = nil
local vehicleClass = nil

local healthEngineLast = 1000.0
local healthEngineCurrent = 1000.0
local healthEngineNew = 1000.0
local healthEngineDelta = 0.0
local healthEngineDeltaScaled = 0.0

local healthBodyLast = 1000.0
local healthBodyCurrent = 1000.0
local healthBodyNew = 1000.0
local healthBodyDelta = 0.0
local healthBodyDeltaScaled = 0.0

local classDamageMultiplier = { [0] = 1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,0.0,0.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0 }

local function isPedDrivingAVehicle()
	local ped = PlayerPedId()
	vehicle = GetVehiclePedIsUsing(ped)
	if IsPedInAnyVehicle(ped) then
		if GetPedInVehicleSeat(vehicle,-1) == ped then
			local class = GetVehicleClass(vehicle)
			if class ~= 13 and class ~= 14 then
				return true
			end
		end
	end
	return false
end

Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if IsPedInAnyVehicle(ped) then
			if pedInSameVehicleLast then
				timeDistance = 4
				local factor = 1.0
				if healthEngineNew < 900 then
					factor = (healthEngineNew+200.0) / 1100
				end
				SetVehicleEngineTorqueMultiplier(vehicle,factor)
			end

			local roll = GetEntityRoll(vehicle)
			if (roll > 75.0 or roll < -75.0) and GetEntitySpeed(vehicle) < 2 then
				DisableControlAction(2,59,true)
				DisableControlAction(2,60,true)
			end
		end
		Citizen.Wait(timeDistance)
	end
end)

Citizen.CreateThread(function()
	while true do
		local roll = GetEntityRoll(vehicle)
		if roll > 75.0 or roll < -75.0 then
			local tyre = math.random(4)
			if math.random(100) <= 50 then
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
			end
		end
		Citizen.Wait(1000)
	end
end)

Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		if isPedDrivingAVehicle() then
			timeDistance = 4
			vehicle = GetVehiclePedIsUsing(ped)
			vehicleClass = GetVehicleClass(vehicle)
			healthEngineCurrent = GetVehicleEngineHealth(vehicle)

			if healthEngineCurrent >= 1000 then
				healthEngineLast = 1000.0
			end

			healthEngineNew = healthEngineCurrent
			healthEngineDelta = healthEngineLast - healthEngineCurrent
			healthEngineDeltaScaled = healthEngineDelta * 1.2 * classDamageMultiplier[vehicleClass]
			healthBodyCurrent = GetVehicleBodyHealth(vehicle)

			if healthBodyCurrent == 1000 then
				healthBodyLast = 1000.0
			end

			healthBodyNew = healthBodyCurrent
			healthBodyDelta = healthBodyLast - healthBodyCurrent
			healthBodyDeltaScaled = healthBodyDelta * 1.2 * classDamageMultiplier[vehicleClass]

			if healthEngineCurrent > 101.0 then
				SetVehicleUndriveable(vehicle,false)
			end

			if healthEngineCurrent <= 101.0 then
				SetVehicleUndriveable(vehicle,true)
			end

			if vehicle ~= lastVehicle then
				pedInSameVehicleLast = false
			end

			if pedInSameVehicleLast then
				if healthEngineCurrent ~= 1000.0 or healthBodyCurrent ~= 1000.0 then
					local healthEngineCombinedDelta = math.max(healthEngineDeltaScaled,healthBodyDeltaScaled)
					if healthEngineCombinedDelta > (healthEngineCurrent - 100.0) then
						healthEngineCombinedDelta = healthEngineCombinedDelta * 0.7
					end

					if healthEngineCombinedDelta > healthEngineCurrent then
						healthEngineCombinedDelta = healthEngineCurrent - (210.0 / 5)
					end
					healthEngineNew = healthEngineLast - healthEngineCombinedDelta

					if healthEngineNew > (210.0 + 5) and healthEngineNew < 477.0 then
						healthEngineNew = healthEngineNew-(0.038 * 3.2)
					end

					if healthEngineNew < 210.0 then
						healthEngineNew = healthEngineNew-(0.1 * 0.9)
					end

					if healthEngineNew < 100.0 then
						healthEngineNew = 100.0
					end

					if healthBodyNew < 0 then
						healthBodyNew = 0.0
					end
				end
			else
				if healthBodyCurrent < 210.0 then
					healthBodyNew = 210.0
				end
				pedInSameVehicleLast = true
			end

			if healthEngineNew ~= healthEngineCurrent then
				SetVehicleEngineHealth(vehicle,healthEngineNew)
			end

			if healthBodyNew ~= healthBodyCurrent then
				SetVehicleBodyHealth(vehicle,healthBodyNew)
			end

			healthEngineLast = healthEngineNew
			healthBodyLast = healthBodyNew
			lastVehicle = vehicle
		else
			pedInSameVehicleLast = false
		end

		Citizen.Wait(timeDistance)
	end
end)