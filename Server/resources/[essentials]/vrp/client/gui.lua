-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local crouch = false
local point = false
local object = nil
local celular = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATUS:CELULAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("status:celular")
AddEventHandler("status:celular",function(status)
	celular = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCELULAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		if celular then
			timeDistance = 4
			DisableControlAction(1,288,true)
			DisableControlAction(1,289,true)
			DisableControlAction(1,170,true)
			DisableControlAction(1,187,true)
			DisableControlAction(1,189,true)
			DisableControlAction(1,190,true)
			DisableControlAction(1,188,true)
			DisableControlAction(1,73,true)
			DisableControlAction(1,167,true)
			DisableControlAction(1,29,true)
			DisableControlAction(1,182,true)
			DisableControlAction(1,16,true)
			DisableControlAction(1,17,true)
			DisableControlAction(1,24,true)
			DisableControlAction(1,25,true)
			DisableControlAction(1,245,true)
			DisableControlAction(1,68,true)
			DisableControlAction(1,70,true)
			DisableControlAction(1,91,true)
			DisablePlayerFiring(PlayerPedId(),true)
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.request(id,text,time)
	SendNUIMessage({ act = "request", id = id, text = tostring(text), time = time })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NUIPROMPT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("prompt",function(data,cb)
	if data.act == "close" then
		SetNuiFocus(false)
		vRPserver._promptResult(data.result)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROMPT
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.prompt(title,default_text)
	SendNUIMessage({ act = "prompt", title = title, text = tostring(default_text) })
	SetNuiFocus(true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("request",function(data,cb)
	if data.act == "response" then
		vRPserver._requestResult(data.id,data.ok)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETDIV
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.setDiv(name,css,content)
	SendNUIMessage({ act = "set_div", name = name, css = css, content = content })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETDIVCONTENT
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.setDivContent(name,content)
	SendNUIMessage({ act = "set_div_content", name = name, content = content })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEDIV
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.removeDiv(name)
	SendNUIMessage({ act = "remove_div", name = name })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADANIMSET
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.loadAnimSet(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Citizen.Wait(10)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
local animDict = nil
local animName = nil
local animActived = false
function tvRP.createObjects(dict,anim,prop,flag,mao,altura,pos1,pos2,pos3,pos4,pos5)
	if DoesEntityExist(object) then
		TriggerServerEvent("tryDeleteEntity",ObjToNet(object))
		object = nil
	end

	local ped = PlayerPedId()
	local mHash = GetHashKey(prop)

	RequestModel(mHash)
	while not HasModelLoaded(mHash) do
		RequestModel(mHash)
		Citizen.Wait(10)
	end

	if anim ~= "" then
		tvRP.loadAnimSet(dict)
		TaskPlayAnim(ped,dict,anim,3.0,3.0,-1,flag,0,0,0,0)
	end

	if altura then
		local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,0.0,-5.0)
		object = CreateObject(mHash,coords.x,coords.y,coords.z,true,true,true)
		AttachEntityToEntity(object,ped,GetPedBoneIndex(ped,mao),altura,pos1,pos2,pos3,pos4,pos5,true,true,false,true,1,true)
	else
		local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,0.0,-5.0)
		object = CreateObject(mHash,coords.x,coords.y,coords.z,true,true,true)
		AttachEntityToEntity(object,ped,GetPedBoneIndex(ped,mao),0.0,0.0,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
	end
	SetEntityAsMissionEntity(object,true,true)
	SetModelAsNoLongerNeeded(mHash)

	animDict = dict
	animName = anim
	animFlags = flag
	animActived = true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEACTIVED
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.removeActived()
	if animActived then
		if DoesEntityExist(object) then
			TriggerServerEvent("tryDeleteEntity",ObjToNet(object))
			object = nil
		end
		animActived = false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADANIM
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		if not IsEntityPlayingAnim(ped,animDict,animName,3) and animActived then
			TaskPlayAnim(ped,animDict,animName,3.0,3.0,-1,animFlags,0,0,0,0)
			timeDistance = 4
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBLOCK
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		if animActived then
			timeDistance = 4
			DisableControlAction(1,16,true)
			DisableControlAction(1,17,true)
			DisableControlAction(1,24,true)
			DisableControlAction(1,25,true)
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.removeObjects(status)
	if status == "one" then
		tvRP.stopAnim(true)
	elseif status == "two" then
		tvRP.stopAnim(false)
	else
		tvRP.stopAnim(true)
		tvRP.stopAnim(false)
	end

	animActived = false
	TriggerEvent("camera")
	TriggerEvent("binoculos")
	if DoesEntityExist(object) then
		TriggerServerEvent("tryDeleteEntity",ObjToNet(object))
		object = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLOCKDRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
local blockDrunk = false
RegisterNetEvent("vrp:blockDrunk")
AddEventHandler("vrp:blockDrunk",function(status)
	blockDrunk = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POINT
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if point then
			timeDistance = 4
			local ped = PlayerPedId()
			local camPitch = GetGameplayCamRelativePitch()

			if camPitch < -70.0 then
				camPitch = -70.0
			elseif camPitch > 42.0 then
				camPitch = 42.0
			end
			camPitch = (camPitch + 70.0) / 112.0

			local camHeading = GetGameplayCamRelativeHeading()
			local cosCamHeading = Cos(camHeading)
			local sinCamHeading = Sin(camHeading)
			if camHeading < -180.0 then
				camHeading = -180.0
			elseif camHeading > 180.0 then
				camHeading = 180.0
			end
			camHeading = (camHeading + 180.0) / 360.0

			local blocked = 0
			local nn = 0
			local coords = GetOffsetFromEntityInWorldCoords(ped,(cosCamHeading*-0.2)-(sinCamHeading*(0.4*camHeading+0.3)),(sinCamHeading*-0.2)+(cosCamHeading*(0.4*camHeading+0.3)),0.6)
			local ray = Cast_3dRayPointToPoint(coords.x,coords.y,coords.z-0.2,coords.x,coords.y,coords.z+0.2,0.4,95,ped,7);
			nn,blocked,coords,coords = GetRaycastResult(ray)

			Citizen.InvokeNative(0xD5BB4025AE449A4E,ped,"Pitch",camPitch)
			Citizen.InvokeNative(0xD5BB4025AE449A4E,ped,"Heading",camHeading*-1.0+1.0)
			Citizen.InvokeNative(0xB0A6CFD2C69C1088,ped,"isBlocked",blocked)
			Citizen.InvokeNative(0xB0A6CFD2C69C1088,ped,"isFirstPerson",Citizen.InvokeNative(0xEE778F8C7E1142E2,Citizen.InvokeNative(0x19CAFA3C87F7C2FF))==4)
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCDELETEENTITY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("syncDeleteEntity")
AddEventHandler("syncDeleteEntity",function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToEnt(index)
		if DoesEntityExist(v) then
			SetEntityAsMissionEntity(v,false,false)
			DeleteEntity(v)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCCLEANENTITY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("syncCleanEntity")
AddEventHandler("syncCleanEntity",function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToEnt(index)
		if DoesEntityExist(v) then
			SetVehicleDirtLevel(v,0.0)
			SetVehicleUndriveable(v,false)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELANDO
-----------------------------------------------------------------------------------------------------------------------------------------
local cancelando = false
RegisterNetEvent("cancelando")
AddEventHandler("cancelando",function(status)
	cancelando = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELF6
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("keybindCancel",function(source,args)
	if not IsPauseMenuActive() then
		local ped = PlayerPedId()
		if GetEntityHealth(ped) > 101 and not celular and not cancelando then
			TriggerServerEvent("vrp_inventory:Cancel")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HANDSUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("keybindHandsupp",function(source,args)
	if not IsPauseMenuActive() then
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) and not celular and GetEntityHealth(ped) > 101 then
			if IsEntityPlayingAnim(ped,"random@mugging3","handsup_standing_base",3) then
				StopAnimTask(ped,"random@mugging3","handsup_standing_base",2.0)
				tvRP.stopActived()
			else
				tvRP.playAnim(true,{"random@mugging3","handsup_standing_base"},true)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POINT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("keybindPoint",function(source,args)
	if not IsPauseMenuActive() then
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) and not celular and GetEntityHealth(ped) > 101 then
			tvRP.loadAnimSet("anim@mp_point")

			if not point then
				tvRP.stopActived()
				SetPedCurrentWeaponVisible(ped,0,1,1,1)
				SetPedConfigFlag(ped,36,1)
				TaskMoveNetwork(ped,"task_mp_pointing",0.5,0,"anim@mp_point",24)
				point = true
			else
				Citizen.InvokeNative(0xD01015C7316AE176,ped,"Stop")
				if not IsPedInjured(ped) then
					ClearPedSecondaryTask(ped)
				end

				if not IsPedInAnyVehicle(ped) then
					SetPedCurrentWeaponVisible(ped,1,1,1,1)
				end

				SetPedConfigFlag(ped,36,0)
				ClearPedSecondaryTask(ped)
				point = false
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIGARVEH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("keybindEngine",function(source,args)
	if not IsPauseMenuActive() then
		local ped = PlayerPedId()
		if not celular and GetEntityHealth(ped) > 101 then
			if IsPedInAnyVehicle(ped) then
				local vehicle = GetVehiclePedIsUsing(ped)
				if GetPedInVehicleSeat(vehicle,-1) == ped then
					tvRP.removeObjects("two")
					local running = GetIsVehicleEngineRunning(vehicle)
					SetVehicleEngineOn(vehicle,not running,true,true)
					if running then
						SetVehicleUndriveable(vehicle,true)
					else
						SetVehicleUndriveable(vehicle,false)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BIND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("keybind",function(source,args)
	if not IsPauseMenuActive() then
		local ped = PlayerPedId()
		if not celular and GetEntityHealth(ped) > 101 then
			if args[1] == "1" then
				TriggerServerEvent("vrp_inventory:useItem","1",1)
			elseif args[1] == "2" then
				TriggerServerEvent("vrp_inventory:useItem","2",1)
			elseif args[1] == "3" then
				TriggerServerEvent("vrp_inventory:useItem","3",1)
			elseif args[1] == "4" then
				TriggerServerEvent("vrp_inventory:useItem","4",1)
			elseif args[1] == "5" then
				TriggerServerEvent("vrp_inventory:useItem","5",1)
			elseif args[1] == "f1" and not IsPedInAnyVehicle(ped) then
				if IsEntityPlayingAnim(ped,"anim@heists@heist_corona@single_team","single_team_loop_boss",3) then
					StopAnimTask(ped,"anim@heists@heist_corona@single_team","single_team_loop_boss",2.0)
					tvRP.stopActived()
				else
					tvRP.playAnim(true,{"anim@heists@heist_corona@single_team","single_team_loop_boss"},true)
				end
			elseif args[1] == "f2" and not IsPedInAnyVehicle(ped) then
				if IsEntityPlayingAnim(ped,"mini@strip_club@idles@bouncer@base","base",3) then
					StopAnimTask(ped,"mini@strip_club@idles@bouncer@base","base",2.0)
					tvRP.stopActived()
				else
					tvRP.playAnim(true,{"mini@strip_club@idles@bouncer@base","base"},true)
				end
			elseif args[1] == "6" and not IsPedInAnyVehicle(ped) then
				if IsEntityPlayingAnim(ped,"anim@mp_player_intupperfinger","idle_a_fp",3) then
					StopAnimTask(ped,"anim@mp_player_intupperfinger","idle_a_fp",2.0)
					tvRP.stopActived()
				else
					tvRP.playAnim(true,{"anim@mp_player_intupperfinger","idle_a_fp"},true)
				end
			elseif args[1] == "7" and not IsPedInAnyVehicle(ped) then
				if IsEntityPlayingAnim(ped,"anim@heists@prison_heiststation@cop_reactions","cop_a_idle",3) then
					StopAnimTask(ped,"anim@heists@prison_heiststation@cop_reactions","cop_a_idle",2.0)
					tvRP.stopActived()
				else
					tvRP.playAnim(true,{"anim@heists@prison_heiststation@cop_reactions","cop_a_idle"},true)
				end
			elseif args[1] == "8" and not IsPedInAnyVehicle(ped) then
				if IsEntityPlayingAnim(ped,"amb@world_human_cop_idles@female@base","base",3) then
					StopAnimTask(ped,"amb@world_human_cop_idles@female@base","base",2.0)
					tvRP.stopActived()
				else
					tvRP.playAnim(true,{"amb@world_human_cop_idles@female@base","base"},true)
				end
			elseif args[1] == "9" and not IsPedInAnyVehicle(ped) then
				if IsEntityPlayingAnim(ped,"random@arrests@busted","idle_a",3) then
					StopAnimTask(ped,"random@arrests@busted","idle_a",2.0)
					tvRP.stopActived()
				else
					tvRP.playAnim(true,{"random@arrests@busted","idle_a"},true)
				end
			elseif args[1] == "left" and not IsPedInAnyVehicle(ped) then
				if not IsPedInAnyVehicle(ped) then
					tvRP.playAnim(true,{"anim@mp_player_intupperthumbs_up","enter"},false)
				end
			elseif args[1] == "right" and not IsPedInAnyVehicle(ped) then
				if not IsPedInAnyVehicle(ped) then
					tvRP.playAnim(true,{"anim@mp_player_intcelebrationmale@face_palm","face_palm"},false)
				end
			elseif args[1] == "up" and not IsPedInAnyVehicle(ped) then
				if not IsPedInAnyVehicle(ped) then
					tvRP.playAnim(true,{"anim@mp_player_intcelebrationmale@salute","salute"},false)
				end
			elseif args[1] == "down" and not IsPedInAnyVehicle(ped) then
				if not IsPedInAnyVehicle(ped) then
					tvRP.playAnim(true,{"rcmnigel1c","hailing_whistle_waive_a"},false)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACCEPT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("keybindAccept",function(source,args)
	local ped = PlayerPedId()
	if not celular and GetEntityHealth(ped) > 101 then
		SendNUIMessage({ act = "event", event = "Y" })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REJECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("keybindReject",function(source,args)
	local ped = PlayerPedId()
	if not celular and GetEntityHealth(ped) > 101 then
		SendNUIMessage({ act = "event", event = "U" })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRUNKCAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("vehTrunk",function(source,args)
	local ped = PlayerPedId()
	if not celular and GetEntityHealth(ped) > 101 then
		TriggerServerEvent("vrp_trunkchest:openTrunk")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("keybindCancel","Cancelar animações","keyboard","f6")
RegisterKeyMapping("keybindHandsupp","Levantar as mãos","keyboard","x")
RegisterKeyMapping("keybindPoint","Apontar os dedos","keyboard","b")
RegisterKeyMapping("keybindEngine","Ligar veículo","keyboard","z")
RegisterKeyMapping("keybind 1","Inventory Bind 1","keyboard","1")
RegisterKeyMapping("keybind 2","Inventory Bind 2","keyboard","2")
RegisterKeyMapping("keybind 3","Inventory Bind 3","keyboard","3")
RegisterKeyMapping("keybind 4","Inventory Bind 4","keyboard","4")
RegisterKeyMapping("keybind 5","Inventory Bind 5","keyboard","5")
RegisterKeyMapping("keybind f1","Animation Bind f1","keyboard","f1")
RegisterKeyMapping("keybind f2","Animation Bind f2","keyboard","f2")
RegisterKeyMapping("keybind 6","Animation Bind 6","keyboard","6")
RegisterKeyMapping("keybind 7","Animation Bind 7","keyboard","7")
RegisterKeyMapping("keybind 8","Animation Bind 8","keyboard","8")
RegisterKeyMapping("keybind 9","Animation Bind 9","keyboard","9")
RegisterKeyMapping("keybind left","Bind Left","keyboard","left")
RegisterKeyMapping("keybind right","Bind Right","keyboard","right")
RegisterKeyMapping("keybind up","Bind Up","keyboard","up")
RegisterKeyMapping("keybind down","Bind Down","keyboard","down")
RegisterKeyMapping("keybindAccept","Aceitar chamado","keyboard","y")
RegisterKeyMapping("keybindReject","Rejeitar chamado","keyboard","u")