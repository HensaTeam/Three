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
Tunnel.bindInterface("vrp_postop",cRP)
vSERVER = Tunnel.getInterface("vrp_postop")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local posPackage = 0
local maxPackage = 25
local boxVehicles = {}
local inService = false
local inPackage = false
local handPackage = false
local initPackage = { -439.03,-2796.89,7.3 }
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTOCKADE
-----------------------------------------------------------------------------------------------------------------------------------------
local delivery = {
	{ 441.05,-981.03,30.69 },
	{ 312.33,-592.95,43.29 },
	{ -560.21,286.91,82.18 },
	{ -1369.07,-170.16,47.49 },
	{ -1080.28,-245.41,37.77 },
	{ -1845.02,-1195.58,19.19 },
	{ -1388.36,-586.94,30.22 },
	{ -1061.01,-521.63,36.09 },
	{ -1037.62,-1397.11,5.56 },
	{ -598.2,-929.91,23.87 },
	{ -32.54,-1112.79,26.49 },
	{ -661.96,-861.63,24.5 },
	{ -288.05,-1062.69,27.21 },
	{ -202.15,-1158.68,23.82 },
	{ 438.52,-622.98,28.71 },
	{ 382.18,-1076.52,29.43 },
	{ 143.66,-1041.32,29.37 },
	{ 166.39,-1451.17,29.25 },
	{ 20.42,-1505.47,31.86 },
	{ 410.53,-1910.7,25.46 },
	{ 849.16,-2097.55,30.26 },
	{ 200.49,335.86,105.62 },
	{ -143.73,229.41,94.94 },
	{ 110.21,-637.12,44.25 },
	{ 416.84,-1109.05,30.05 },
	{ 89.4,-1745.49,30.09 },
	{ -72.67,-1820.75,26.95 },
	{ 1174.36,-418.83,67.21 },
	{ 638.18,1.91,82.79 },
	{ 245.9,371.91,105.74 },
	{ -20.91,239.43,109.56 },
	{ -357.31,-50.8,49.04 },
	{ -345.43,-131.03,39.01 },
	{ -561.91,-131.06,38.44 },
	{ 196.19,-406.36,45.33 },
	{ 1200.5,-1277.37,35.58 },
	{ 229.65,-22.33,74.99 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CALLNAMES
-----------------------------------------------------------------------------------------------------------------------------------------
local callName = { "James","John","Robert","Michael","William","David","Richard","Charles","Joseph","Thomas","Christopher","Daniel","Paul","Mark","Donald","George","Kenneth","Steven","Edward","Brian","Ronald","Anthony","Kevin","Jason","Matthew","Gary","Timothy","Jose","Larry","Jeffrey","Frank","Scott","Eric","Stephen","Andrew","Raymond","Gregory","Joshua","Jerry","Dennis","Walter","Patrick","Peter","Harold","Douglas","Henry","Carl","Arthur","Ryan","Roger","Joe","Juan","Jack","Albert","Jonathan","Justin","Terry","Gerald","Keith","Samuel","Willie","Ralph","Lawrence","Nicholas","Roy","Benjamin","Bruce","Brandon","Adam","Harry","Fred","Wayne","Billy","Steve","Louis","Jeremy","Aaron","Randy","Howard","Eugene","Carlos","Russell","Bobby","Victor","Martin","Ernest","Phillip","Todd","Jesse","Craig","Alan","Shawn","Clarence","Sean","Philip","Chris","Johnny","Earl","Jimmy","Antonio","Mary","Patricia","Linda","Barbara","Elizabeth","Jennifer","Maria","Susan","Margaret","Dorothy","Lisa","Nancy","Karen","Betty","Helen","Sandra","Donna","Carol","Ruth","Sharon","Michelle","Laura","Sarah","Kimberly","Deborah","Jessica","Shirley","Cynthia","Angela","Melissa","Brenda","Amy","Anna","Rebecca","Virginia","Kathleen","Pamela","Martha","Debra","Amanda","Stephanie","Carolyn","Christine","Marie","Janet","Catherine","Frances","Ann","Joyce","Diane","Alice","Julie","Heather","Teresa","Doris","Gloria","Evelyn","Jean","Cheryl","Mildred","Katherine","Joan","Ashley","Judith","Rose","Janice","Kelly","Nicole","Judy","Christina","Kathy","Theresa","Beverly","Denise","Tammy","Irene","Jane","Lori","Rachel","Marilyn","Andrea","Kathryn","Louise","Sara","Anne","Jacqueline","Wanda","Bonnie","Julia","Ruby","Lois","Tina","Phyllis","Norma","Paula","Diana","Annie","Lillian","Emily","Robin" }
local callName2 = { "Smith","Johnson","Williams","Jones","Brown","Davis","Miller","Wilson","Moore","Taylor","Anderson","Thomas","Jackson","White","Harris","Martin","Thompson","Garcia","Martinez","Robinson","Clark","Rodriguez","Lewis","Lee","Walker","Hall","Allen","Young","Hernandez","King","Wright","Lopez","Hill","Scott","Green","Adams","Baker","Gonzalez","Nelson","Carter","Mitchell","Perez","Roberts","Turner","Phillips","Campbell","Parker","Evans","Edwards","Collins","Stewart","Sanchez","Morris","Rogers","Reed","Cook","Morgan","Bell","Murphy","Bailey","Rivera","Cooper","Richardson","Cox","Howard","Ward","Torres","Peterson","Gray","Ramirez","James","Watson","Brooks","Kelly","Sanders","Price","Bennett","Wood","Barnes","Ross","Henderson","Coleman","Jenkins","Perry","Powell","Long","Patterson","Hughes","Flores","Washington","Butler","Simmons","Foster","Gonzales","Bryant","Alexander","Russell","Griffin","Diaz","Hayes" }
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTOCKADE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()

		if inService then
			if not IsPedInAnyVehicle(ped) then
				local vehicle = getNearVehicle(11)
				local coords = GetEntityCoords(ped)

				if DoesEntityExist(vehicle) and GetEntityModel(vehicle) == GetHashKey("boxville4") then
					local coordsVeh = GetOffsetFromEntityInWorldCoords(vehicle,0.0,-3.5,0.0)
					local distance = #(coords - coordsVeh)
					if distance <= 1.2 then
						timeDistance = 4
						local plate = GetVehicleNumberPlateText(vehicle)

						if inPackage then
							if boxVehicles[plate] == nil then
								DrawText3D(coordsVeh.x,coordsVeh.y,coordsVeh.z,"~g~E~w~   GUARDAR ENCOMENDA\nTOTAL DE ENCOMENDAS:  0/"..maxPackage,550,0.0225,0.06)
							else
								DrawText3D(coordsVeh.x,coordsVeh.y,coordsVeh.z,"~g~E~w~   GUARDAR ENCOMENDA\nTOTAL DE ENCOMENDAS:  "..boxVehicles[plate].."/"..maxPackage,550,0.0225,0.06)
							end

							if IsControlJustPressed(1,38) and vSERVER.addPackage(plate) then
								inPackage = false
								handPackage = false
								vRP.removeObjects("one")
							end
						else
							if boxVehicles[plate] == nil then
								DrawText3D(coordsVeh.x,coordsVeh.y,coordsVeh.z,"~g~E~w~   RETIRAR ENCOMENDA\nTOTAL DE ENCOMENDAS:  0/"..maxPackage,550,0.0225,0.06)
							else
								DrawText3D(coordsVeh.x,coordsVeh.y,coordsVeh.z,"~g~E~w~   RETIRAR ENCOMENDA\nTOTAL DE ENCOMENDAS:  "..boxVehicles[plate].."/"..maxPackage,550,0.0225,0.06)
							end

							if IsControlJustPressed(1,38) and boxVehicles[plate] then
								if boxVehicles[plate] > 0 then
									inPackage = true
									handPackage = true
									TriggerServerEvent("vrp_postop:remPackage",plate)
									vRP.createObjects("anim@heists@box_carry@","idle","hei_prop_heist_box",50,28422)
								end
							end
						end
					end
				end

				local distance = #(coords - vector3(initPackage[1],initPackage[2],initPackage[3]))
				if distance <= 2 then
					timeDistance = 4

					if inPackage then
						DrawText3D(initPackage[1],initPackage[2],initPackage[3],"~g~E~w~   GUARDAR ENCOMENDA",350,0.0125,0.03)
					else
						DrawText3D(initPackage[1],initPackage[2],initPackage[3],"~g~E~w~   RETIRAR ENCOMENDA",350,0.0125,0.03)
					end

					if IsControlJustPressed(1,38) then
						if inPackage then
							inPackage = false
							vRP.removeObjects("one")
						else
							inPackage = true
							vRP.createObjects("anim@heists@box_carry@","idle","hei_prop_heist_box",50,28422)
						end
					end
				end

				local distance = #(coords - vector3(delivery[posPackage][1],delivery[posPackage][2],delivery[posPackage][3]))
				if distance <= 30 then
					timeDistance = 4
					DrawText3D(delivery[posPackage][1],delivery[posPackage][2],delivery[posPackage][3],"~g~E~w~   ENTREGAR ENCOMENDA",350,0.0125,0.03)
					if distance <= 0.6 and IsControlJustPressed(1,38) and handPackage then
						inPackage = false
						handPackage = false
						vSERVER.paymentMethod()
						vRP.removeObjects("one")
						TriggerEvent("vrp_postop:initDelivery")
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
-- ENTREGADOR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("entregador",function(source,args)
	if GetEntityHealth(PlayerPedId()) > 101 then
		if inService then
			inService = false
		else
			inService = true
			TriggerEvent("vrp_postop:initDelivery")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_POSTOP:UPDATEPACKAGE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_postop:updatePackage")
AddEventHandler("vrp_postop:updatePackage",function(status)
	boxVehicles = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_POSTOP:UPDATEPACKAGE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_postop:initDelivery")
AddEventHandler("vrp_postop:initDelivery",function()
	posPackage = math.random(#delivery)
	TriggerEvent("NotifyPush",{ code = 20, title = "Entrega de encomenda", x = delivery[posPackage][1], y = delivery[posPackage][2], z = delivery[posPackage][3], name = callName[math.random(#callName)].." "..callName2[math.random(#callName2)], rgba = {30,90,160} })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DWTEXT
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x,y,z,text,h,g,f)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,100)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / h
	DrawRect(_x,_y+g,0.01+factor,f,0,0,0,100)
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