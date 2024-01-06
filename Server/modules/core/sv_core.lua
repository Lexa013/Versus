VS.Players = VS.Players or {}

local user_repository = VS.SQL.Repositories.User
local iam_repository = VS.SQL.Repositories.IAM

local function playerDataReceived(rows, error)
    if error or (#rows < 1 or #rows > 1) then
        Console.Log("Something went wrong when retrieving someone's data !")
        return
    end

    local playerData = rows[1]
    local player = VS.Players[playerData.steamid]

    -- If the data arrived after the player disconnected
    if (player == nil) then return end

    user_repository.UpdateColumnAsync("username", steamId, current_player:GetAccountName(), nil)
    user_repository.UpdateColumnAsync("ip", steamId, current_player:GetIP(), nil)
    user_repository.UpdateColumnAsync("last_seen", steamId, os.date("%Y-%m-%d %X", os.time()), nil)

end

local function playerJoined(player)
    local steamid = player:GetSteamID()
    local ip = player:GetIP()

    VS.Players[steamid] = player

    user_repository.IsExistingAsync(steamid, function(exists, error)
        if (not exists) then
            user_repository.CreateUserAsync(steamid, ip, function(rows_affected, error)
                user_repository.FetchDataAsync(steamid, playerDataReceived)
            end)
        else
            user_repository.FetchDataAsync(steamid, playerDataReceived)
        end
    end)

end

-- Player joins check if 
Player.Subscribe("Ready", playerJoined)


Player.Subscribe("Destroy", function(player)
    VS.Players[player:GetSteamID()] = nil
end)


VS.Commands.RegisterCommand("listgroups", function(caller)
    iam_repository.GetUsergroupsAsync(function(rows, error)
      
        if (error) then
            Server.SendChatMessage(caller, "Something went wrong when retrieving the usergroups !")
            Console.Warn("Failed to retrieve the usergroups list:" ..error)
            return
        end

        Server.SendChatMessage(caller, "List of existing usergroups")
        local text = ""
        for k, v in ipairs(rows) do
            text = text .."\t- ".. v["name"] .."\n"
        end

        Chat.SendMessage(caller, text)
    end)  
end)  

-- Console.Log(NanosTable.Dump(VS.Commands.Registered))

-- VS.Commands.Register("listgroups", function(caller)

--     local usergroups, error = iam_repository.GetUsergroups()

--     if (error) then
--         Server.SendChatMessage(caller, "Something went wrong when retrieving the usergroups !")
--         Console.Warn("Failed to retrieve the usergroups list:" ..error)
--         return
--     end

--     Server.SendChatMessage(caller, "List of existing usergroups")

--     local text = ""
--     for k, v in ipairs(usergroups) do
--         text = text .."\t- ".. v["name"] .."\n"
--     end

--     Chat.SendMessage(caller, text)
-- end)

-- VS.Commands.Register("addusergroup", function(caller, name, power)
    
--     local _, error = VS.SQL.Repositories.IAM.AddUsergroup(name, power)

--     if (error) then
--         Server.SendChatMessage(caller, "Something went wrong when creating a usergroup !")
--         Console.Warn("Failed to create a usergroup:" ..error)
--         return
--     end

--     Server.SendChatMessage(caller, "Successfully created the " ..name.. " usergroup with a power of " ..power)
-- end)

-- VS.Commands.Register("delete", function(caller, name)
    
--     local _, error = VS.SQL.Repositories.IAM.AddUsergroup(name, power)

--     if (error) then
--         Server.SendChatMessage(caller, "Something went wrong when creating a usergroup !")
--         Console.Warn("Failed to create a usergroup:" ..error)
--         return
--     end

--     Server.SendChatMessage(caller, "Successfully created the " ..name.. " usergroup with a power of " ..power)
-- end)