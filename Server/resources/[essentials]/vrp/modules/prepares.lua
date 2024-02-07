vRP.Prepare("vRP/get_vrp_infos","SELECT * FROM vrp_infos WHERE steam = @steam")
vRP.Prepare("vRP/get_characters","SELECT id,registration,phone,name,name2,bank FROM vrp_users WHERE steam = @steam and deleted = 0")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE USERS
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("vRP/get_vrp_users","SELECT * FROM vrp_users WHERE id = @id")
vRP.Prepare("vRP/get_vrp_registration","SELECT id FROM vrp_users WHERE registration = @registration")
vRP.Prepare("vRP/get_vrp_phone","SELECT id FROM vrp_users WHERE phone = @phone")
vRP.Prepare("vRP/create_characters","INSERT INTO vrp_users(steam,name,name2) VALUES(@steam,@name,@name2)")
vRP.Prepare("vRP/remove_characters","UPDATE vrp_users SET deleted = 1 WHERE id = @id")
vRP.Prepare("vRP/update_characters","UPDATE vrp_users SET registration = @registration, phone = @phone WHERE id = @id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE BANK
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("vRP/set_bank","UPDATE vrp_users SET bank = @bank WHERE id = @id")
vRP.Prepare("vRP/add_bank","UPDATE vrp_users SET bank = bank + @bank WHERE id = @id")
vRP.Prepare("vRP/del_bank","UPDATE vrp_users SET bank = bank - @bank WHERE id = @id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE VRP_USERS
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("vRP/create_user","INSERT INTO vrp_infos(steam) VALUES(@steam)")
vRP.Prepare("vRP/set_banned","UPDATE vrp_infos SET banned = @banned WHERE steam = @steam")
vRP.Prepare("vRP/set_whitelist","UPDATE vrp_infos SET whitelist = @whitelist WHERE steam = @steam")
vRP.Prepare("vRP/update_gems","UPDATE vrp_infos SET gems = gems + @gems WHERE steam = @steam")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE VRP_USER_DATA
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("vRP/set_userdata","REPLACE INTO vrp_user_data(user_id,dkey,dvalue) VALUES(@user_id,@key,@value)")
vRP.Prepare("vRP/get_userdata","SELECT dvalue FROM vrp_user_data WHERE user_id = @user_id AND dkey = @key")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE VRP_SRV_DATA
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("vRP/set_srvdata","REPLACE INTO vrp_srv_data(dkey,dvalue) VALUES(@key,@value)")
vRP.Prepare("vRP/get_srvdata","SELECT dvalue FROM vrp_srv_data WHERE dkey = @key")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE VRP_PERMISSIONS
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("vRP/get_perm","SELECT * FROM vrp_permissions WHERE user_id = @user_id")
vRP.Prepare("vRP/get_group","SELECT * FROM vrp_permissions WHERE user_id = @user_id AND permiss = @permiss")
vRP.Prepare("vRP/add_group","INSERT INTO vrp_permissions(user_id,permiss) VALUES(@user_id,@permiss)")
vRP.Prepare("vRP/del_group","DELETE FROM vrp_permissions WHERE user_id = @user_id AND permiss = @permiss")
vRP.Prepare("vRP/cle_group","DELETE FROM vrp_permissions WHERE user_id = @user_id")
vRP.Prepare("vRP/upd_group","UPDATE vrp_permissions SET permiss = @newpermiss WHERE user_id = @user_id AND permiss = @permiss")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE VRP_PRIORITY
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("vRP/set_premium","UPDATE vrp_infos SET premium = @premium, predays = @predays, priority = @priority WHERE steam = @steam")
vRP.Prepare("vRP/update_priority","UPDATE vrp_infos SET premium = 0, predays = 0, priority = 0 WHERE steam = @steam")
vRP.Prepare("vRP/update_premium","UPDATE vrp_infos SET predays = predays + @predays WHERE steam = @steam")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE VRP_HOMES
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("vRP/get_homeuser","SELECT * FROM vrp_homes WHERE user_id = @user_id AND home = @home")
vRP.Prepare("vRP/get_homeuserid","SELECT * FROM vrp_homes WHERE user_id = @user_id")
vRP.Prepare("vRP/get_homeuserowner","SELECT * FROM vrp_homes WHERE user_id = @user_id AND home = @home AND owner = 1")
vRP.Prepare("vRP/get_homeuseridowner","SELECT * FROM vrp_homes WHERE home = @home AND owner = 1")
vRP.Prepare("vRP/get_homepermissions","SELECT * FROM vrp_homes WHERE home = @home")
vRP.Prepare("vRP/add_permissions","INSERT IGNORE INTO vrp_homes(home,user_id) VALUES(@home,@user_id)")
vRP.Prepare("vRP/buy_permissions","INSERT IGNORE INTO vrp_homes(home,user_id,owner,vault) VALUES(@home,@user_id,1,@vault)")
vRP.Prepare("vRP/count_homepermissions","SELECT COUNT(*) as qtd FROM vrp_homes WHERE home = @home")
vRP.Prepare("vRP/count_homes","SELECT COUNT(*) as qtd FROM vrp_homes WHERE user_id = @user_id")
vRP.Prepare("vRP/rem_permissions","DELETE FROM vrp_homes WHERE home = @home AND user_id = @user_id")
vRP.Prepare("vRP/rem_allpermissions","DELETE FROM vrp_homes WHERE home = @home")
vRP.Prepare("vRP/upd_vaulthomes","UPDATE vrp_homes SET vault = vault + @vault WHERE home = @home AND owner = 1")
vRP.Prepare("vRP/transfer_homes","UPDATE vrp_homes SET user_id = @nuser_id WHERE user_id = @user_id AND home = @home")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE VRP_GARAGES
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("vRP/get_vehicle","SELECT * FROM vrp_vehicles WHERE user_id = @user_id")
vRP.Prepare("vRP/get_vehicle_plate","SELECT * FROM vrp_vehicles WHERE plate = @plate")
vRP.Prepare("vRP/rem_vehicle","DELETE FROM vrp_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.Prepare("vRP/get_vehicles","SELECT * FROM vrp_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.Prepare("vRP/set_update_vehicles","UPDATE vrp_vehicles SET engine = @engine, body = @body, fuel = @fuel, doors = @doors, windows = @windows, tyres = @tyres WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.Prepare("vRP/set_arrest","UPDATE vrp_vehicles SET arrest = @arrest, time = @time WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.Prepare("vRP/move_vehicle","UPDATE vrp_vehicles SET user_id = @nuser_id WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.Prepare("vRP/add_vehicle","INSERT IGNORE INTO vrp_vehicles(user_id,vehicle,plate,work) VALUES(@user_id,@vehicle,@plate,@work)")
vRP.Prepare("vRP/con_maxvehs","SELECT COUNT(vehicle) as qtd FROM vrp_vehicles WHERE user_id = @user_id AND work = 'false'")
vRP.Prepare("vRP/rem_srv_data","DELETE FROM vrp_srv_data WHERE dkey = @dkey")
vRP.Prepare("vRP/update_garages","UPDATE vrp_users SET garage = garage + 1 WHERE id = @id")
vRP.Prepare("vRP/update_plate_vehicle","UPDATE vrp_vehicles SET plate = @plate WHERE user_id = @user_id AND vehicle = @vehicle")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE VRP_INVOICE
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("vRP/add_invoice","INSERT INTO vrp_invoice(user_id,nuser_id,date,price,text) VALUES(@user_id,@nuser_id,@date,@price,@text)")
vRP.Prepare("vRP/get_invoice","SELECT * FROM vrp_invoice WHERE user_id = @user_id")
vRP.Prepare("vRP/get_myinvoice","SELECT * FROM vrp_invoice WHERE nuser_id = @nuser_id")
vRP.Prepare("vRP/del_invoice","DELETE FROM vrp_invoice WHERE id = @id AND user_id = @user_id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE VRP_FINES
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("vRP/add_fines","INSERT INTO vrp_fines(user_id,nuser_id,date,price,text) VALUES(@user_id,@nuser_id,@date,@price,@text)")
vRP.Prepare("vRP/get_fines","SELECT * FROM vrp_fines WHERE user_id = @user_id")
vRP.Prepare("vRP/del_fines","DELETE FROM vrp_fines WHERE id = @id AND user_id = @user_id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE VRP_GEMS
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("vRP/set_vrp_gems","UPDATE vrp_infos SET gems = gems + @gems WHERE steam = @steam")
vRP.Prepare("vRP/rem_vrp_gems","UPDATE vrp_infos SET gems = gems - @gems WHERE steam = @steam")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE VRP_BARBERSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("vRP/selectSkin","SELECT * FROM vrp_barbershop WHERE user_id = @user_id")
vRP.Prepare("vRP/insertSkin","INSERT INTO vrp_barbershop(user_id) VALUES(@user_id)")
vRP.Prepare("vRP/updateSkin","UPDATE vrp_barbershop SET fathers = @fathers, kinship = @kinship, eyecolor = @eyecolor, skincolor = @skincolor, acne = @acne, stains = @stains, freckles = @freckles, aging = @aging, hair = @hair, haircolor = @haircolor, haircolor2 = @haircolor2, makeup = @makeup, makeupintensity = @makeupintensity, makeupcolor = @makeupcolor, lipstick = @lipstick, lipstickintensity = @lipstickintensity, lipstickcolor = @lipstickcolor, eyebrow = @eyebrow, eyebrowintensity = @eyebrowintensity, eyebrowcolor = @eyebrowcolor, beard = @beard, beardintentisy = @beardintentisy, beardcolor = @beardcolor, blush = @blush, blushintentisy = @blushintentisy, blushcolor = @blushcolor WHERE user_id = @user_id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE VRP_PRISON
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("vRP/set_prison","UPDATE vrp_users SET prison = prison + @prison, locate = @locate WHERE id = @user_id")
vRP.Prepare("vRP/rem_prison","UPDATE vrp_users SET prison = prison - @prison WHERE id = @user_id")
vRP.Prepare("vRP/fix_prison","UPDATE vrp_users SET prison = 1 WHERE id = @user_id")