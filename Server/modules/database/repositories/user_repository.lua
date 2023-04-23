VS.SQL.Repositories.User = VS.SQL.Repositories.User or {}

local db_connection = VS.SQL.Connection

---@async
---@param steamid string
---@return boolean #Wether the users exists in the database or not
function VS.SQL.Repositories.User.IsExistingSync(steamid)
    local exists = db_connection:ExecuteSync("SELECT 1 FROM vs_users WHERE steamid = :0" , steamid)

    return (exists == 1 and true or false)
end

---@async
---@param steamid string
---@param ip string
---@return "UserCreated", number steamid
function VS.SQL.Repositories.User.CreateUser(steamid, ip)
    local query = 
    [[
        INSERT INTO vs_users (steamid, ip) VALUES (:0, :1)
    ]]

    db_connection:Execute(query, function()
        Events.Call("SQL::QueryResult", "User.CreateUser", steamid)
    end, steamid, ip)
end

---@async
---@param steamid string
---@param update_last_seen number,
---@return "PlayerData", table<string, any> data, number steamid
function VS.SQL.Repositories.User.FetchData(steamid, update_last_seen)
    local query = [[
        SELECT username, ip, joined_at, last_seen FROM vs_users WHERE steamid = :0
    ]]

    db_connection:Execute("UPDATE vs_users SET last_seen = current_timestamp() WHERE steamid = :0 AND :1=1", function()
        db_connection:Select(query, function(data)
            Events.Call("SQL::QueryResult", "User.FetchData", data, steamid, nil, nil)
        end, steamid)
    end, steamid, update_last_seen and 1 or 0)
end

---@async
---@param column_name string Column name in the database
---@param steamid string, 
---@param new_value any Value which will be set
---@return "UserColumnUpdated", string steamid, string column_name, any new_value
function VS.SQL.Repositories.User.UpdateColumn(column_name, steamid, new_value)
    db_connection:Execute("UPDATE vs_users SET ".. column_name .." = :0 WHERE steamid = :1", function(_)
        Events.Call("SQL::QueryResult", "User.UpdateColumn", steamid, column_name, new_value, nil)
    end, new_value, steamid)
end



