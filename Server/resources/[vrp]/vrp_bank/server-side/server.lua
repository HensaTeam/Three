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
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTWANTED
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestWanted()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.wantedReturn(user_id) then
			return true
		end
		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestBank()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.getUserIdentity(user_id)
		return vRP.getBank(user_id),identity.name,identity.name2
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTFINES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestFines()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local fines = {}
		local consult = vRP.getFines(user_id)
		for k,v in pairs(consult) do
			if v.nuser_id == 0 then
				table.insert(fines,{ id = v.id, user_id = parseInt(v.user_id), nuser_id = "Government", date = v.date, price = parseInt(v.price), text = tostring(v.text) })
			else
				local identity = vRP.getUserIdentity(v.nuser_id)
				table.insert(fines,{ id = v.id, user_id = parseInt(v.user_id), nuser_id = tostring(identity.name.." "..identity.name2), date = v.date, price = parseInt(v.price), text = tostring(v.text) })
			end
		end
		return fines
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINESPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.finesPayment(id,price)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.paymentBank(user_id,parseInt(price)) then
			TriggerClientEvent("vrp_bank:Update",source,"requestFines")
			vRP.Query("vRP/del_fines",{ id = parseInt(id), user_id = parseInt(user_id) })
		else
			TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente na sua conta bancária.",5000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTINVOICES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestInvoices()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local invoices = {}
		local consult = vRP.getInvoice(user_id)
		for k,v in pairs(consult) do
			if v.nuser_id == 0 then
				table.insert(invoices,{ id = v.id, user_id = parseInt(v.user_id), nuser_id = parseInt(v.nuser_id), name = "Governament", date = v.date, price = parseInt(v.price), text = tostring(v.text) })
			else
				local identity = vRP.getUserIdentity(v.nuser_id)
				table.insert(invoices,{ id = v.id, user_id = parseInt(v.user_id), nuser_id = parseInt(v.nuser_id), name = tostring(identity.name.." "..identity.name2), date = v.date, price = parseInt(v.price), text = tostring(v.text) })
			end
		end
		return invoices
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTINVOICES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestMyInvoices()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local invoices = {}
		local consult = vRP.getMyInvoice(user_id)
		for k,v in pairs(consult) do
			local identity = vRP.getUserIdentity(v.user_id)
			if identity then
				table.insert(invoices,{ name = tostring(identity.name.." "..identity.name2), date = v.date, price = parseInt(v.price), text = tostring(v.text) })
			end
		end
		return invoices
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVOICESPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.invoicesPayment(id,price,nuser_id)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.paymentBank(user_id,parseInt(price)) then
			if parseInt(nuser_id) > 0 then
				vRP.addBank(nuser_id,parseInt(price))
			end
			TriggerClientEvent("vrp_bank:Update",source,"requestInvoices")
			vRP.Query("vRP/del_invoice",{ id = parseInt(id), user_id = parseInt(user_id) })
		else
			TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente na sua conta bancária.",5000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANKDEPOSIT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.bankDeposit(amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if parseInt(amount) > 0 then
			if vRP.tryGetInventoryItem(user_id,"dollars",parseInt(amount)) then
				vRP.addBank(user_id,parseInt(amount))
				TriggerClientEvent("vrp_bank:Update",source,"requestInicio")
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANWITHDRAW
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.bankWithdraw(amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then

		local getInvoice = vRP.getInvoice(user_id)
		if getInvoice[1] ~= nil then
			TriggerClientEvent("Notify",source,"negado","Encontramos faturas pendentes.",3000)
			return
		end

		local getFines = vRP.getFines(user_id)
		if getFines[1] ~= nil then
			TriggerClientEvent("Notify",source,"negado","Encontramos multas pendentes.",3000)
			return
		end

		if parseInt(amount) > 0 then
			if vRP.computeInvWeight(user_id) + vRP.itemWeightList("dollars") * parseInt(amount) <= vRP.getBackpack(user_id) then
				if vRP.withdrawCash(user_id,parseInt(amount)) then
					TriggerClientEvent("vrp_bank:Update",source,"requestInicio")
				else
					TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente na sua conta bancária.",5000)
				end
			else
				TriggerClientEvent("Notify",source,"negado","Mochila cheia.",5000)
			end
		end
	end
end