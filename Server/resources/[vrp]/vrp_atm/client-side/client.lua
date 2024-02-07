-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("vrp_atm")
-----------------------------------------------------------------------------------------------------------------------------------------
-- ATMOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
local atmObjects = {
	"prop_atm_01",
	"prop_atm_02",
	"prop_atm_03",
	"prop_fleeca_atm"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ATM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("atm",function()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	for k,v in pairs(atmObjects) do
		if DoesObjectOfTypeExistAtCoords(coords,0.6,GetHashKey(v),true) then
			local saldo = vSERVER.getSaldo()
			SetNuiFocus(true,true)
			SendNUIMessage({ action = "show", saldo = tostring(saldo) })
			vRP._playAnim(false,{"amb@prop_human_atm@male@base","base"},true)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSEAPP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("CloseApp", function(data,cb)
	SetNuiFocus(false)
	cb("ok")
	vRP._playAnim(false,{"amb@prop_human_atm@male@exit","exit"},false)
	Citizen.Wait(4000)
	vRP._stopAnim()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HANDLESAQUE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("HandleSaque", function(data,cb)
	local valor = parseInt(data.valor)
	local newSaldo = vSERVER.sacarValor(valor)
	cb({ saldo = tostring(newSaldo) })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HANDLETRANSFER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("HandleTransfer", function(data,cb)
	local valor,target = parseInt(data.valor),parseInt(data.target)
	local newSaldo = vSERVER.transferirValor(valor,target)
	cb({ saldo = tostring(newSaldo) })
end)