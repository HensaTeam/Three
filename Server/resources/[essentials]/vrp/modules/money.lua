-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.addBank(user_id,amount)
	if amount > 0 then
		vRP.Query("vRP/add_bank",{ id = parseInt(user_id), bank = parseInt(amount) })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.setBank(user_id,amount)
	if amount > 0 then
		vRP.Query("vRP/set_bank",{ id = parseInt(user_id), bank = parseInt(amount) })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.delBank(user_id,amount)
	if amount > 0 then
		vRP.Query("vRP/del_bank",{ id = parseInt(user_id), bank = parseInt(amount) })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getBank(user_id)
	local consult = vRP.getInformation(user_id)
	if consult[1] then
		return consult[1].bank
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.paymentBank(user_id,amount)
	if amount > 0 then
		local consult = vRP.getInformation(user_id)
		if consult[1] then
			if consult[1].bank >= amount then
				vRP.Query("vRP/del_bank",{ id = parseInt(user_id), bank = parseInt(amount) })

				local source = vRP.getUserSource(user_id)
				if source then
					TriggerClientEvent("itensNotify",source,{ "-","dollars",vRP.format(amount),"Dólares" })
				end
				return true
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WITHDRAWCASH
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.withdrawCash(user_id,amount)
	if amount > 0 then
		local consult = vRP.getInformation(user_id)
		if consult[1] then
			if consult[1].bank >= amount then
				vRP.giveInventoryItem(user_id,"dollars",amount,true)
				vRP.Query("vRP/del_bank",{ id = parseInt(user_id), bank = parseInt(amount) })
				return true
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETINVOICE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.setInvoice(user_id,price,nuser_id,text)
	vRP.Query("vRP/add_invoice",{ user_id = user_id, nuser_id = tostring(nuser_id), date = os.date("%d.%m.%Y"), price = price, text = tostring(text) })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETINVOICE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getInvoice(user_id)
	return vRP.Query("vRP/get_invoice",{ user_id = user_id })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETMYINVOICE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getMyInvoice(nuser_id)
	return vRP.Query("vRP/get_myinvoice",{ nuser_id = nuser_id })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETFINES
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.setFines(user_id,price,nuser_id,text)
	vRP.Query("vRP/add_fines",{ user_id = user_id, nuser_id = tostring(nuser_id), date = os.date("%d.%m.%Y"), price = price, text = tostring(text) })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETFINES
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getFines(user_id)
	return vRP.Query("vRP/get_fines",{ user_id = user_id })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPREMIUM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getPremium(user_id)
	local identity = vRP.getUserIdentity(user_id)
	if identity then
		local consult = vRP.getInfos(identity.steam)
		if consult[1] and os.time() >= (consult[1].premium+24*consult[1].predays*60*60) then
			return false
		else
			return true
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPREMIUM2
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getPremium2(steam)
	local consult = vRP.getInfos(steam)
	if consult[1] and os.time() >= (consult[1].premium+24*consult[1].predays*60*60) then
		return false
	else
		return true
	end
end