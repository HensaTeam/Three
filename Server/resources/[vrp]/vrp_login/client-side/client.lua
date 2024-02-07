-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local cam = nil
local new = false
local weight = 270.0
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIG
-----------------------------------------------------------------------------------------------------------------------------------------
local config = {
	["hawick"] = { 310.62,-231.46,54.03 },
	["west"] = { 1037.77,-765.61,57.98 },
	["little"] = { 450.12,-662.3,28.47 },
	["avenue"] = { 219.53,-808.87,30.69 },
	["goma"] = { -1201.35,-1550.69,4.29 },
	["delperro"] = { -2031.43,-461.64,11.47 },
	["route68"] = { 321.77,2622.18,44.48 },
	["procopio"] = { -772.94,5593.45,33.49 },
	["davis"] = { 27.66,-1763.32,29.32 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_login:Spawn")
AddEventHandler("vrp_login:Spawn",function(status)
	local ped = PlayerPedId()
	if status then
		local x,y,z = table.unpack(GetEntityCoords(ped))

		cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA",x,y,z+200.0,270.00,0.0,0.0,80.0,0,0)
		SetCamActive(cam,true)

		RenderScriptCams(true,false,1,true,true)

		SetNuiFocus(true,true)
		SendNUIMessage({ display = true })
	else
		SetEntityVisible(ped,true,false)
		FreezeEntityPosition(ped,false)
		SetEntityInvincible(ped,false)

		RenderScriptCams(false,false,0,true,true)
		SetCamActive(cam,false)
		DestroyCam(cam,true)
		cam = nil
	end

	Citizen.Wait(1000)
	DoScreenFadeIn(1000)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("spawn",function(data,cb)
	local ped = PlayerPedId()
	if data.choice == "spawn" then
		SetNuiFocus(false)
		SendNUIMessage({ display = false })

		DoScreenFadeOut(1000)
		Citizen.Wait(1000)

		SetEntityVisible(ped,true,false)
		FreezeEntityPosition(ped,false)
		SetEntityInvincible(ped,false)

		RenderScriptCams(false,false,0,true,true)
		SetCamActive(cam,false)
		DestroyCam(cam,true)
		cam = nil

		Citizen.Wait(1000)
		DoScreenFadeIn(1000)
	else
    	new = false
		local speed = 0.7

		DoScreenFadeOut(500)
		Citizen.Wait(500)

		SetCamRot(cam,270.0)
		SetCamActive(cam,true)
		new = true
		weight = 270.0

		DoScreenFadeIn(500)

		SetEntityCoords(ped,config[data.choice][1],config[data.choice][2],config[data.choice][3]+0.5)
		local x,y,z = table.unpack(GetEntityCoords(ped))

		SetCamCoord(cam,x,y,z+200.0)
		local i = z + 200.0

		while i > config[data.choice][3] + 1.5 do
			Citizen.Wait(5)
			i = i - speed
			SetCamCoord(cam,x,y,i)

			if i <= config[data.choice][3] + 35.0 and weight < 360.0 then
				if speed - 0.0078 >= 0.05 then
					speed = speed - 0.0078
				end

				weight = weight + 0.75
				SetCamRot(cam,weight)
			end

			if not new then
				break
			end
		end
	end

	cb("ok")
end)