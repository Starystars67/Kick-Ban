-- ======================================
      -- Written By : Titch2000
      -- Free to use and edit but 
	  -- please give credit
-- ======================================
RegisterNetEvent('yt:kick');
RegisterNetEvent('yt:ban');
RegisterNetEvent('yt:kick-ban-help');
RegisterNetEvent('yt:not-admin');
RegisterNetEvent('yt:status-console');

AddEventHandler("playerConnecting", function()
	Citizen.Trace('[YT:KICK-BAN]: Ban Check!')
	TriggerServerEvent('yt:checkBanState')
end)

AddEventHandler("playerSpawned", function()
	Citizen.Trace('[YT:KICK-BAN]: Ban Check!')
	TriggerServerEvent('yt:checkBanState')
end)

Citizen.CreateThread(function() 
	Citizen.Trace("[YT:KICK-BAN]: Ban Check Running.")
	while true do
		Wait( 60000 ) -- CHECKS EVERY MINUTE
		TriggerServerEvent('yt:checkBanState')
		TriggerEvent("yt:status-console", "Client")
	end
end)

-- Citizen.CreateThread(function()
	-- local time = timeAmount -- 10 seconds
	-- while (time ~= 0) do -- Whist we have time to wait
		-- Wait(1000) -- CHECKS EVERY MINUTE
		-- TriggerServerEvent('yt:checkBanState')
		-- time = time - 1
		-- -- 1 Second should have past by now
	-- end
	-- -- When the above loop has finished, 10 seconds should have passed. We can now do something
-- end)

AddEventHandler("yt:status-console", function(msg)
	Citizen.Trace("[YT:KICK-BAN]: " .. msg)
end)

AddEventHandler('yt:kick', function(player, reason)
	ped = GetPlayerPed(-1);
	
	if ped then
		if reason ~= nil then
			TriggerEvent('chatMessage', "^3Server", {255, 0, 0}, "^0Player " .. player .. " Was kicked.");
			TriggerEvent('chatMessage', "^3Server", {255, 0, 0}, "^0reason: " .. reason .. ". ");
		else
			TriggerEvent('chatMessage', "^3Server", {255, 0, 0}, "^0Player " .. player .. " Was kicked");
		end
	end
end)

AddEventHandler('yt:ban', function()
	ped = GetPlayerPed(-1);
	
	if ped then
		if reason ~= nil then
			TriggerEvent('chatMessage', "^3Server", {255, 0, 0}, "^0Player " .. player .. " Was BANNED.");
			TriggerEvent('chatMessage', "^3Server", {255, 0, 0}, "^0reason: " .. reason .. ". ");
		else
			TriggerEvent('chatMessage', "^3Server", {255, 0, 0}, "^0Player " .. player .. " Was BANNED");
		end
	end
end)

AddEventHandler('yt:kick-ban-help', function()
	ped = GetPlayerPed(-1);
	
	if ped then
		TriggerEvent('chatMessage', "^3Server", {255, 0, 0}, "^0-------- KICK & BAN COMMAND HELP --------");
		TriggerEvent('chatMessage', "^3Server", {255, 0, 0}, "^0Usage: /kick <user-id> <reason optional>");
		TriggerEvent('chatMessage', "^3Server", {255, 0, 0}, "^0Usage: /ban <user-id> <reason optional>");
	end
end)

AddEventHandler('yt:not-admin', function()
	ped = GetPlayerPed(-1);
	
	if ped then
		TriggerEvent('chatMessage', "^3Server", {255, 0, 0}, "^0YOU DO NOT HAVE PREMISSION TO USE THIS COMMAND");
	end
end)