VS.SQL.Repositories.User = VS.SQL.Repositories.User or {}

local db_connection = VS.SQL.Connection

---@async
---@param steamid string
---@return boolean Wether the users exists in the database or not
---@return string If there is an error, returns a string
function VS.SQL.Repositories.User.IsExistingAsync(steamid, callback)
    db_connection:ExecuteAsync("SELECT 1 FROM vs_users WHERE steamid = :0", function(affected_rows, error)
        local exists = affected_rows >= 1

        callback(exists, error)
    end, steamid)
end

---@async
---@param steamid string
---@param ip string
---@return "UserCreated", table<string> steamid
function VS.SQL.Repositories.User.CreateUserAsync(steamid, ip, callback)
    db_connection:ExecuteAsync("INSERT INTO vs_users (steamid, ip) VALUES (:0, :1)", callback, steamid, ip)
end

---@async
---@param steamid string
---@param update_last_seen number
---@return "PlayerData", table<any> data, steamid
function VS.SQL.Repositories.User.FetchDataAsync(steamid, callback)
    local query = [[
        SELECT steamid, username, ip, joined_at, last_seen, usergroup FROM vs_users WHERE steamid = :0
    ]]

    db_connection:SelectAsync(query, callback, steamid)
end

---@async
---@param column_name string Column name in the database
---@param steamid string The SteamId of the user
---@param new_value any Value which will be set
---@return "UserColumnUpdated", table<any> steamid, column_name, new_value
function VS.SQL.Repositories.User.UpdateColumnAsync(column_name, steamid, new_value, callback)
    db_connection:ExecuteAsync("UPDATE vs_users SET ".. column_name .." = :0 WHERE steamid = :1", callback, new_value, steamid)
end



