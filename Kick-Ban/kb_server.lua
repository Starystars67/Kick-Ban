-- ======================================
      -- Written By : Titch2000
      -- Free to use and edit but 
	  -- please give credit
-- ======================================
_VERSION = '1.0.0'

local adminAmount = 0;
local admins = {
	--------------------------------------
	-- EXAMPLES BELOW, Remember to insert comma if using more than 1 admin
    --{['i'] = 0, ['IP'] = "ip:"},
    --{['i'] = 1, ['IP'] = "steam:"}
	--------------------------------------
	{['i'] = 0, ['IP'] = "ip:79.68.80.205"},
	{['i'] = 1, ['IP'] = "ip:79.68.94.72"},
	{['i'] = 2, ['IP'] = "steam:1100001099e2841"},
}

for k,v in ipairs(admins) do
    adminAmount = adminAmount + 1;
end

-- version check
PerformHttpRequest("https://raw.githubusercontent.com/Starystars67/Kick-Ban/master/Kick-Ban/version.txt", function(err, rText, headers)
	print("\n[YT-Kick-Ban]")
	print("Current version: " .. _VERSION)
	print("Updated version: " .. rText)
	print("  Admins loaded: " .. adminAmount .. "\n")
	
	if rText ~= _VERSION then
		--print("\nYou do not seem to be using the latest version of YT:Kick-Ban. Please update\n")
	else
		print("Everything is up-to-date!\n")
	end
end, "GET", "", {what = 'this'})

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

AddEventHandler("chatMessage", function(source, color, msg)
    if msg:sub(1, 1) == "/" then
        cmd = stringsplit(msg, " ")
		if cmd[1] == "/kick-user" then								-- KICK
			-- get ip of player
			local playerIP = GetPlayerIdentifiers(source)[1]
			--print(playerIP)
			-- check against our list
			for k,v in ipairs(admins) do
				if v.IP == playerIP then -- player ip then
					notAdmin = 0
					if cmd[2] ~= nil then
						cmd[2] = tonumber(cmd[2])
						if (cmd[2] < 1 or cmd[2] > 320) then
							-- tell the sender they have an invalid target
							TriggerClientEvent('chatMessage', source, "SYSTEM", {200, 0, 0}, "Invalid PlayerID!")
							return -- dont continue any further
						end
						DropPlayer(cmd[2], cmd[3])
						-- get player from name or id? if its int then go if its string then get id as int
						local playerName = GetPlayerName(cmd[2])
						TriggerClientEvent("yt:kick", source, playerName, cmd[3])
						CancelEvent()
						return
					else
						TriggerClientEvent("yt:kick-ban-help", source)
						CancelEvent()
					end
				else
					notAdmin = 1
				end
			end
			
			if notAdmin == 1 then
				TriggerClientEvent("yt:not-admin", source)
			end
			CancelEvent()
		elseif cmd[1] == "/ban-user" then								-- BAN
			-- get ip of player
			local playerIP = GetPlayerIdentifiers(source)[1]
			--print(playerIP)
			-- check against our list
			for k,v in ipairs(admins) do
				if v.IP == playerIP then -- player ip then
					notAdmin = 0
					if cmd[2] ~= nil then
						cmd[2] = tonumber(cmd[2])
						if (cmd[2] < 1 or cmd[2] > 320) then
							-- tell the sender they have an invalid target
							TriggerClientEvent('chatMessage', source, "SYSTEM", {200, 0, 0}, "Invalid PlayerID!")
							return -- dont continue any further
						end
						if(GetPlayerName(tonumber(cmd[2])))then
							local player = tonumber(cmd[2])
							local name = GetPlayerName(tonumber(cmd[2]))
							local reason = cmd
							local state = "BANNED"
							local identifier = GetPlayerIdentifiers(player)[1]
							table.remove(reason, 1)
							table.remove(reason, 1)
							if(#reason == 0)then
								reason = " Banned: You have been BANNED from the server"
							else
								reason = " " .. table.concat(reason, " ")
							end
							MySQL.Async.execute("INSERT INTO bans (identifier,name,state,reason) VALUES (@identifier,@name,@state,@reason)", {['@identifier'] = identifier, ['@name'] = name, ['@state'] = state, ['@reason'] = reason})
							DropPlayer(player, reason)
							CancelEvent()
							return
						else
							TriggerClientEvent('yt:kick-ban-help', source)
						end
					else
						TriggerClientEvent("yt:kick-ban-help", source)
						CancelEvent()
					end
				else
					notAdmin = 1
				end
			end
			
			if notAdmin == 1 then
				TriggerClientEvent("yt:not-admin", source)
			end
			CancelEvent()
		end
		CancelEvent()
    end
end)

RegisterServerEvent('yt:dropPlayer')
AddEventHandler('yt:dropPlayer', function(player, reason)
	print('Player: ' .. player .. ' Was Kicked From the Server, Reason: ' .. reason)
	DropPlayer(player, reason)
end)

RegisterServerEvent('yt:checkBanState')
AddEventHandler('yt:checkBanState', function()
	name = GetPlayerName(source)
	local player = source
	local identifier = GetPlayerIdentifiers(source)[1]
	print('Player: '..name..' ID: '..source..' '..identifier..' BAN CHECK RESULT:')
	MySQL.Async.fetchAll('SELECT * FROM bans WHERE identifier=@id', {['@id'] = identifier}, function(gotInfo)
		if gotInfo[1] ~= nil then
			local result = "BAN CHECK RESULT = " .. gotInfo[1].state
			local state = gotInfo[1].state
			local reason = gotInfo[1].reason
			TriggerClientEvent("yt:status-console", player, "Server")
			--print("Result: " .. gotInfo[1].state .. " " .. gotInfo[1].reason)
			if state == "BANNED" then 
				print('BANNED')
				reason = "You Are Banned From The Server, Reason: " .. reason .. " "
				TriggerEvent('yt:dropPlayer', player, reason)
				CancelEvent()
			elseif state == "Dev" then
				print('Created by Titch2000')
			else	
				print('Not Banned')
			end
		else
			print('Not Banned')
			CancelEvent()
		end
	end)
end)

AddEventHandler('playerConnecting', function()
	name = GetPlayerName(source)
	local player = source
	local identifier = GetPlayerIdentifiers(source)[1]
	print('Player: '..name..' ID: '..source..' '..identifier..' BAN CHECK RESULT:')
	MySQL.Async.fetchAll('SELECT * FROM bans WHERE identifier=@id', {['@id'] = identifier}, function(gotInfo)
		if gotInfo[1] ~= nil then
			local result = "BAN CHECK RESULT = " .. gotInfo[1].state
			local state = gotInfo[1].state
			local reason = gotInfo[1].reason
			TriggerClientEvent("yt:status-console", player, "Server")
			--print("Result: " .. gotInfo[1].state .. " " .. gotInfo[1].reason)
			if state == "BANNED" then 
				print('BANNED')
				reason = "You Are Banned From The Server, Reason: " .. reason .. " "
				TriggerEvent('yt:dropPlayer', player, reason)
				CancelEvent()
			elseif state == "Dev" then
				print('Created by Titch2000')
			else	
				print('Not Banned')
			end
		else
			print('Not Banned')
			CancelEvent()
		end
	end)
end)