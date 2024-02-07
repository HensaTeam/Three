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
Tunnel.bindInterface("vrp_helicam",cRP)
vSERVER = Tunnel.getInterface("vrp_helicam")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local fov_max = 80.0
local fov_min = 5.0 -- max zoom level (smaller fov is more zoom)
local zoomspeed = 3.0 -- camera zoom speed
local speed_lr = 4.0 -- speed by which the camera pans left-right 
local speed_ud = 4.0 -- speed by which the camera pans up-down
local toggle_helicam = 51 -- control id of the button by which to toggle the helicam mode. Default: INPUT_CONTEXT (E)
local toggle_rappel = 154 -- control id to rappel out of the heli. Default: INPUT_DUCK (X)
local toggle_spotlight = 183 -- control id to toggle the various spotlight states Default: INPUT_PhoneCameraGrid (G)
local toggle_display = 44 -- control id to toggle vehicle info display. Default: INPUT_COVER (Q)
local radiusup_key = 137 -- control id to increase manual spotlight radius. Default: INPUT_VEH_PUSHBIKE_SPRINT (CAPSLOCK)
local radiusdown_key = 21 -- control id to decrease spotlight radius. Default: INPUT_SPRINT (LEFT-SHIFT)
local maxtargetdistance = 700 -- max distance at which target lock is maintained
local brightness = 1.0 -- default spotlight brightness
local spotradius = 4.0 -- default manual spotlight radius

local target_vehicle = nil
local manual_spotlight = false
local tracking spotlight = false
local vehicle_display = 0
local helicam = false
local polmav_hash = GetHashKey("polmav")
local fov = (fov_max+fov_min)*0.5
local vision_state = 0

Citizen.CreateThread(function()
	DecorRegister("SpotvectorX",3)
	DecorRegister("SpotvectorY",3)
	DecorRegister("SpotvectorZ",3)
	DecorRegister("Target",3)
end)

Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if IsPlayerInPolmav() then
			timeDistance = 4
			local ped = PlayerPedId()
			local heli = GetVehiclePedIsUsing(ped)
			
			if IsHeliHighEnough(heli) then
				if IsControlJustPressed(1,toggle_helicam) then
					PlaySoundFrontend(-1,"SELECT","HUD_FRONTEND_DEFAULT_SOUNDSET",false)
					helicam = true
				end
				
				if IsControlJustPressed(1,toggle_rappel) then
					if GetPedInVehicleSeat(heli,1) == ped or GetPedInVehicleSeat(heli,2) == ped then
						PlaySoundFrontend(-1,"SELECT","HUD_FRONTEND_DEFAULT_SOUNDSET",false)
						TaskRappelFromHeli(ped,1)
					end
				end
			end

			if IsControlJustPressed(1,toggle_spotlight) and GetPedInVehicleSeat(heli,-1) == ped and not helicam then
				if target_vehicle then
					if tracking_spotlight then
						if not pause_Tspotlight then
							pause_Tspotlight = true
							TriggerServerEvent("heli:pause.tracking.spotlight",pause_Tspotlight)
						else
							pause_Tspotlight = false
							TriggerServerEvent("heli:pause.tracking.spotlight",pause_Tspotlight)
						end
						PlaySoundFrontend(-1,"SELECT","HUD_FRONTEND_DEFAULT_SOUNDSET",false)
					else
						if Fspotlight_state then
							Fspotlight_state = false
							TriggerServerEvent("heli:forward.spotlight",Fspotlight_state)
						end
						local target_netID = VehToNet(target_vehicle)
						local target_plate = GetVehicleNumberPlateText(target_vehicle)
						local targetposx,targetposy,targetposz = table.unpack(GetEntityCoords(target_vehicle))
						pause_Tspotlight = false
						tracking_spotlight = true
						TriggerServerEvent("heli:tracking.spotlight",target_netID,target_plate,targetposx,targetposy,targetposz)
						PlaySoundFrontend(-1,"SELECT","HUD_FRONTEND_DEFAULT_SOUNDSET",false)
					end
				else
					if tracking_spotlight then
						pause_Tspotlight = false
						tracking_spotlight = false
						TriggerServerEvent("heli:tracking.spotlight.toggle")
					end
					Fspotlight_state = not Fspotlight_state
					TriggerServerEvent("heli:forward.spotlight",Fspotlight_state)
					PlaySoundFrontend(-1,"SELECT","HUD_FRONTEND_DEFAULT_SOUNDSET",false)
				end
			end

			if IsControlJustPressed(1,toggle_display) and GetPedInVehicleSeat(heli,-1) == ped then 
				ChangeDisplay()
			end
		end
		
		if helicam then
			SetTimecycleModifier("heliGunCam")
			SetTimecycleModifierStrength(0.3)
			local scaleform = RequestScaleformMovie("HELI_CAM")
			while not HasScaleformMovieLoaded(scaleform) do
				Citizen.Wait(10)
			end

			local ped = PlayerPedId()
			local heli = GetVehiclePedIsUsing(ped)
			local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA",true)
			AttachCamToEntity(cam,heli,0.0,0.0,-1.5,true)
			SetCamRot(cam,0.0,0.0,GetEntityHeading(heli))
			SetCamFov(cam,fov)
			RenderScriptCams(true,false,0,1,0)
			PushScaleformMovieFunction(scaleform,"SET_CAM_LOGO")
			PushScaleformMovieFunctionParameterInt(0)
			PopScaleformMovieFunctionVoid()
			while helicam and not IsEntityDead(ped) and (GetVehiclePedIsUsing(ped) == heli) and IsHeliHighEnough(heli) do
				if IsControlJustPressed(1,toggle_helicam) then
					PlaySoundFrontend(-1,"SELECT","HUD_FRONTEND_DEFAULT_SOUNDSET",false)
					if manual_spotlight and target_vehicle then
						TriggerServerEvent("heli:manual.spotlight.toggle")
						local target_netID = VehToNet(target_vehicle)
						local target_plate = GetVehicleNumberPlateText(target_vehicle)
						local targetposx,targetposy,targetposz = table.unpack(GetEntityCoords(target_vehicle))
						pause_Tspotlight = false
						tracking_spotlight = true
						TriggerServerEvent("heli:tracking.spotlight",target_netID,target_plate,targetposx,targetposy,targetposz)
						PlaySoundFrontend(-1,"SELECT","HUD_FRONTEND_DEFAULT_SOUNDSET",false)
					end
					manual_spotlight = false
					helicam = false
				end

				if IsControlJustPressed(1,toggle_spotlight) then
					if tracking_spotlight then
						pause_Tspotlight = true
						TriggerServerEvent("heli:pause.tracking.spotlight",pause_Tspotlight)
						manual_spotlight = not manual_spotlight
						if manual_spotlight then
							local rotation = GetCamRot(cam, 2)
							local forward_vector = RotAnglesToVec(rotation)
							local SpotvectorX,SpotvectorY,SpotvectorZ = table.unpack(forward_vector)
							DecorSetInt(ped,"SpotvectorX",SpotvectorX)
							DecorSetInt(ped,"SpotvectorY",SpotvectorY)
							DecorSetInt(ped,"SpotvectorZ",SpotvectorZ)
							PlaySoundFrontend(-1,"SELECT","HUD_FRONTEND_DEFAULT_SOUNDSET",false)
							TriggerServerEvent("heli:manual.spotlight")
						else
							TriggerServerEvent("heli:manual.spotlight.toggle")
						end
					elseif Fspotlight_state then
						Fspotlight_state = false
						TriggerServerEvent("heli:forward.spotlight",Fspotlight_state)
						manual_spotlight = not manual_spotlight
						if manual_spotlight then
							PlaySoundFrontend(-1,"SELECT","HUD_FRONTEND_DEFAULT_SOUNDSET",false)
							TriggerServerEvent("heli:manual.spotlight")
						else
							TriggerServerEvent("heli:manual.spotlight.toggle")
						end
					else
						manual_spotlight = not manual_spotlight
						if manual_spotlight then
							PlaySoundFrontend(-1,"SELECT","HUD_FRONTEND_DEFAULT_SOUNDSET",false)
							TriggerServerEvent("heli:manual.spotlight")
						else
							TriggerServerEvent("heli:manual.spotlight.toggle")
						end
					end
				end

				if IsControlJustPressed(1,radiusup_key) then
					TriggerServerEvent("heli:radius.up")
				end

				if IsControlJustPressed(1,radiusdown_key) then
					TriggerServerEvent("heli:radius.down")
				end

				if IsControlJustPressed(1,toggle_display) then 
					ChangeDisplay()
				end

				local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
				CheckInputRotation(cam, zoomvalue)
				local vehicle_detected = GetVehicleInView(cam)
				if DoesEntityExist(vehicle_detected) then
					RenderVehicleInfo(vehicle_detected)
				end

				HandleZoom(cam)
				HideHudAndRadarThisFrame()
				PushScaleformMovieFunction(scaleform,"SET_ALT_FOV_HEADING")
				PushScaleformMovieFunctionParameterFloat(GetEntityCoords(heli).z)
				PushScaleformMovieFunctionParameterFloat(zoomvalue)
				PushScaleformMovieFunctionParameterFloat(GetCamRot(cam,2).z)
				PopScaleformMovieFunctionVoid()
				DrawScaleformMovieFullscreen(scaleform,255,255,255,255)
				Citizen.Wait(0)

				if manual_spotlight then
					local rotation = GetCamRot(cam, 2)
					local forward_vector = RotAnglesToVec(rotation)
					local SpotvectorX, SpotvectorY, SpotvectorZ = table.unpack(forward_vector)
					local camcoords = GetCamCoord(cam)

					DecorSetInt(ped,"SpotvectorX",SpotvectorX)
					DecorSetInt(ped,"SpotvectorY",SpotvectorY)
					DecorSetInt(ped,"SpotvectorZ",SpotvectorZ)
					DrawSpotLight(camcoords,forward_vector,255,255,255,800.0,10.0,brightness,spotradius,1.0,1.0)
				else
					TriggerServerEvent("heli:manual.spotlight.toggle")
				end

			end
			if manual_spotlight then
				manual_spotlight = false
				TriggerServerEvent("heli:manual.spotlight.toggle")
			end
			helicam = false
			ClearTimecycleModifier()
			fov = (fov_max+fov_min)*0.5
			RenderScriptCams(false,false,0,1,0)
			SetScaleformMovieAsNoLongerNeeded(scaleform)
			DestroyCam(cam,false)
			SetNightvision(false)
			SetSeethrough(false)
		end

		if IsPlayerInPolmav() and target_vehicle and not helicam and vehicle_display ~=2 then
			RenderVehicleInfo(target_vehicle)
		end

		Citizen.Wait(timeDistance)
	end
end)

RegisterNetEvent('heli:forward.spotlight')
AddEventHandler('heli:forward.spotlight',function(serverID,state)
	local heli = GetVehiclePedIsUsing(GetPlayerPed(GetPlayerFromServerId(serverID)))
	SetVehicleSearchlight(heli,state,false)
end)

RegisterNetEvent('heli:Tspotlight')
AddEventHandler('heli:Tspotlight',function(serverID,target_netID,target_plate,targetposx,targetposy,targetposz)
	if GetVehicleNumberPlateText(NetToVeh(target_netID)) == target_plate then
		Tspotlight_target = NetToVeh(target_netID)
	elseif GetVehicleNumberPlateText(DoesVehicleExistWithDecorator("Target")) == target_plate then
		Tspotlight_target = DoesVehicleExistWithDecorator("Target")
	elseif GetVehicleNumberPlateText(GetClosestVehicle(targetposx,targetposy,targetposz,25.0,0,70)) == target_plate then
		Tspotlight_target = GetClosestVehicle(targetposx,targetposy,targetposz,25.0,0,70)
	else 
		vehicle_match = FindVehicleByPlate(target_plate)
		if vehicle_match then
			Tspotlight_target = vehicle_match
		else 
			Tspotlight_target = nil
		end
	end

	local heli = GetVehiclePedIsUsing(GetPlayerPed(GetPlayerFromServerId(serverID)),false)
	local heliPed = GetPlayerPed(GetPlayerFromServerId(serverID))
	Tspotlight_toggle = true
	Tspotlight_pause = false
	tracking_spotlight = true
	while not IsEntityDead(heliPed) and (GetVehiclePedIsUsing(heliPed) == heli) and Tspotlight_target and Tspotlight_toggle do
		Citizen.Wait(1)
		local helicoords = GetEntityCoords(heli)
		local targetcoords = GetEntityCoords(Tspotlight_target)
		local spotVector = targetcoords - helicoords
		local target_distance = Vdist(targetcoords,helicoords)
		if Tspotlight_target and Tspotlight_toggle and not Tspotlight_pause then
			DrawSpotLight(helicoords['x'],helicoords['y'],helicoords['z'],spotVector['x'],spotVector['y'],spotVector['z'],255,255,255,(target_distance+20),10.0,brightness,4.0,1.0,0.0)
		end
		if Tspotlight_target and Tspotlight_toggle and target_distance > maxtargetdistance then
			DecorRemove(Tspotlight_target,"Target")			
			target_vehicle = nil
			tracking_spotlight = false
			TriggerServerEvent("heli:tracking.spotlight.toggle")
			Tspotlight_target = nil
			break
		end
	end
	Tspotlight_toggle = false
	Tspotlight_pause = false
	Tspotlight_target = nil
	tracking_spotlight = false
end)

RegisterNetEvent('heli:Tspotlight.toggle')
AddEventHandler('heli:Tspotlight.toggle',function(serverID)
	Tspotlight_toggle = false
	tracking_spotlight = false
end)

RegisterNetEvent('heli:pause.Tspotlight')
AddEventHandler('heli:pause.Tspotlight',function(serverID,pause_Tspotlight)
	if pause_Tspotlight then
		Tspotlight_pause = true
	else
		Tspotlight_pause = false
	end
end)

RegisterNetEvent('heli:Mspotlight')
AddEventHandler('heli:Mspotlight',function(serverID)
	if GetPlayerServerId(PlayerId()) ~= serverID then
		local heli = GetVehiclePedIsUsing(GetPlayerPed(GetPlayerFromServerId(serverID)), false)
		local heliPed = GetPlayerPed(GetPlayerFromServerId(serverID))
		Mspotlight_toggle = true
		while not IsEntityDead(heliPed) and (GetVehiclePedIsUsing(heliPed) == heli) and Mspotlight_toggle do
			Citizen.Wait(0) 
			local helicoords = GetEntityCoords(heli)
			spotoffset = helicoords + vector3(0.0,0.0,-1.5)
			SpotvectorX = DecorGetInt(heliPed,"SpotvectorX")
			SpotvectorY = DecorGetInt(heliPed,"SpotvectorY")
			SpotvectorZ = DecorGetInt(heliPed,"SpotvectorZ")
			if SpotvectorX then
				DrawSpotLight(spotoffset['x'],spotoffset['y'],spotoffset['z'],SpotvectorX,SpotvectorY,SpotvectorZ,255,255,255,800.0,10.0,brightness,spotradius,1.0,1.0)
			end
		end
		Mspotlight_toggle = false
		DecorSetInt(heliPed,"SpotvectorX",nil)
		DecorSetInt(heliPed,"SpotvectorY",nil)
		DecorSetInt(heliPed,"SpotvectorZ",nil)
	end
end)

RegisterNetEvent('heli:Mspotlight.toggle')
AddEventHandler('heli:Mspotlight.toggle',function(serverID)
	Mspotlight_toggle = false
end)

RegisterNetEvent('heli:radius.up')
AddEventHandler('heli:radius.up',function(serverID)
	if spotradius < 10.0 then
		spotradius = spotradius + 1.0
	end
end)

RegisterNetEvent('heli:radius.down')
AddEventHandler('heli:radius.down',function(serverID)
	if spotradius > 4.0 then
		spotradius = spotradius - 1.0
	end
end)

function IsPlayerInPolmav()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	return IsVehicleModel(vehicle,polmav_hash)
end

function IsHeliHighEnough(heli)
	return GetEntityHeightAboveGround(heli) > 1.5
end

function ChangeDisplay()
	if vehicle_display == 0 then
		vehicle_display = 1
	elseif vehicle_display == 1 then
		vehicle_display = 2
	else
		vehicle_display = 0
	end
end

function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0,220)
	local rightAxisY = GetDisabledControlNormal(0,221)
	local rotation = GetCamRot(cam,2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
		new_x = math.max(math.min(20.0,rotation.x+rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)),-89.5)
		SetCamRot(cam,new_x,0.0,new_z,2)
	end
end

function HandleZoom(cam)
	if IsControlJustPressed(1,241) then
		fov = math.max(fov - zoomspeed, fov_min)
	end

	if IsControlJustPressed(1,242) then
		fov = math.min(fov + zoomspeed, fov_max)
	end

	local current_fov = GetCamFov(cam)
	if math.abs(fov-current_fov) < 0.1 then
		fov = current_fov
	end

	SetCamFov(cam,current_fov+(fov-current_fov)*0.05)
end

function GetVehicleInView(cam)
	local coords = GetCamCoord(cam)
	local forward_vector = RotAnglesToVec(GetCamRot(cam,2))
	local rayhandle = CastRayPointToPoint(coords,coords+(forward_vector*200.0),10,GetVehiclePedIsUsing(PlayerPedId()),0)
	local _,_,_,_,entityHit = GetRaycastResult(rayhandle)
	if entityHit > 0 and IsEntityAVehicle(entityHit) then
		return entityHit
	else
		return nil
	end
end

function RenderVehicleInfo(vehicle)
	if DoesEntityExist(vehicle) then
		local model = GetEntityModel(vehicle)
		local vehname = GetLabelText(GetDisplayNameFromVehicleModel(model))
		local licenseplate = GetVehicleNumberPlateText(vehicle)
		local vehspeed = GetEntitySpeed(vehicle)*2.236936
		SetTextFont(0)
		SetTextProportional(1)

		if vehicle_display == 0 then
			SetTextScale(0.0,0.49)
		elseif vehicle_display == 1 then
			SetTextScale(0.0,0.55)
		end

		SetTextColour(255,255,255,255)
		SetTextDropshadow(0,0,0,0,255)
		SetTextEdge(1,0,0,0,255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		if vehicle_display == 0 then
			AddTextComponentString("SPEED: " .. math.ceil(vehspeed) .. " MPH\nMODEL: " .. vehname .. "\nPLATE: " .. licenseplate)
		elseif vehicle_display == 1 then
			AddTextComponentString("MODDEL: " .. vehname .. "\nPLATE: " .. licenseplate)
		end
		DrawText(0.45,0.9)
	end
end

function RotAnglesToVec(rot)
	local z = math.rad(rot.z)
	local x = math.rad(rot.x)
	local num = math.abs(math.cos(x))
	return vector3(-math.sin(z)*num,math.cos(z)*num,math.sin(x))
end

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
		local iter,id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = { handle = iter, destructor = disposeFunc }
		setmetatable(enum,entityEnumerator)

		local next = true
		repeat
			Citizen.Wait(1)
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

function FindVehicleByPlate(plate)
	for vehicle in EnumerateVehicles() do
		if GetVehicleNumberPlateText(vehicle) == plate then
			return vehicle
		end
	end
end