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
Tunnel.bindInterface("vrp_bank",cRP)
vSERVER = Tunnel.getInterface("vrp_bank")
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCALIDADES
-----------------------------------------------------------------------------------------------------------------------------------------
local localidades = {
	{ -1212.63,-330.80,37.78 },
	{ 149.85,-1040.71,29.37 },
	{ -2962.56,482.95,15.70 },
	{ -111.97,6469.19,31.62 },
	{ 1175.05,2706.90,38.09 },
	{ -351.02,-49.97,49.04 },
	{ 314.13,-279.09,54.17 },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)

	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)
			for k,v in pairs(localidades) do
				local distance = #(coords - vector3(v[1],v[2],v[3]))
				if distance <= 2 then
					timeDistance = 4
					DrawText3D(v[1],v[2],v[3],"~g~E~w~   ABRIR")
					if IsControlJustPressed(1,38) and vSERVER.requestWanted() then				
						SetNuiFocus(true,true)
						SendNUIMessage({ action = "showMenu" })
					end
				end
			end
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANKCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("bankClose",function(data)
	SetNuiFocus(false,false)
	SendNUIMessage({ action = "hideMenu" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTBANK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestBank",function(data,cb)
	local resultado,nome,sobrenome = vSERVER.requestBank()
	if resultado then
		cb({ resultado = resultado, nome = nome, sobrenome = sobrenome })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTFINES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestFines",function(data,cb)
	local resultado = vSERVER.requestFines()
	if resultado then
		cb({ resultado = resultado })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINESPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("finesPayment",function(data)
	if data.id ~= nil then
		vSERVER.finesPayment(data.id,data.price)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTINVOICES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestInvoices",function(data,cb)
	local resultado = vSERVER.requestInvoices()
	if resultado then
		cb({ resultado = resultado })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTMYINVOICES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestMyInvoices",function(data,cb)
	local resultado = vSERVER.requestMyInvoices()
	if resultado then
		cb({ resultado = resultado })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVOICESPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("invoicesPayment",function(data)
	if data.id ~= nil then
		vSERVER.invoicesPayment(data.id,data.price,data.nuser_id)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTDEPOSITO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("bankDeposit",function(data)
	if parseInt(data.deposito) > 0 then
		vSERVER.bankDeposit(data.deposito)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTDEPOSITO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("bankWithdraw",function(data)
	if parseInt(data.saque) > 0 then
		vSERVER.bankWithdraw(data.saque)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_PANK:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_bank:Update")
AddEventHandler("vrp_bank:Update",function(action)
	SendNUIMessage({ action = action })
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
	local factor = (string.len(text)) / 400
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,100)
end