VS.SQL = VS.SQL or {}
VS.SQL.Repositories = VS.SQL.Repositories or {}
VS.SQL.Initialized = false

VS.SQL.Connection = Database(DatabaseEngine.MySQL, "host=127.0.0.1 port=3306 dbname=versus user=versus password=versus123")


if not VS.SQL.Connection then
    Console.Error("[SQL] Failed to connect to the database, ensure your server has access to it, aborting !")

    -- -1 represents the stop code
    return -1
end


VS.SQL.Initialized = true

VS.SQL.Migrate()

function VS.SQL.OnMigrationSucceeded()
    
end
