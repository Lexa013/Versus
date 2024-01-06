--[[
    Migration system taken from Advisor - Erlite
    https://github.com/Erlite/Advisor/
]]

VS.SQL = VS.SQL or {}

local migrations = {}
local migrations_folder = "Server/modules/database/migrations/"

local function SetMigrationVersion(version)
    if not version or type(version) ~= "number" then
        Console.Error("[SQL] Cannot set migration to invalid version '" .. version or "nil" .. "'")
        return
    end

    VS.SQL.Connection:Execute("UPDATE vs_migrations SET VERSION = :v LIMIT 1;", function(affected_rows)  
        if not affected_rows then 
            Console.Error("[SQL] Failed to set migration version to %i", version)
        end
    end, version)
end

local function RunMigration(version)
    if not migrations[version] then 
        Console.Error("[SQL] Could not run migration " .. version .. " as it does not exist!")
    end

    local database = VS.SQL.Connection
    local migration_file = File("Packages/" ..Package.GetName().. "/" ..migrations_folder.. "/" ..migrations[version])
    local data = migration_file:Read()

    if not data then 
        Console.Error("[SQL] Could not read migration at " .. migrations_folder .. migrations[version])
    end

    Console.Log("[SQL] Running migration '%s'", migrations[version])

    local queries = StringUtils.Explode(";", data)

    for k, v in ipairs(queries) do
        if (v == "" or string.len(v) <= 2) then
            goto skipQuery
        end

        local _, failed = database:Execute(v)

        if (failed) then
            Console.Error("[SQL] Failed the query #".. k .." of ".. migrations[version])
            return
        end

        Console.Log("\tSuccesfully ran query #".. k .." of ".. migrations[version])

        ::skipQuery::
    end

    if migrations[version + 1] then
        RunMigration(version + 1)
    else
        Console.Log("[SQL] All migrations completed.")
        SetMigrationVersion(version)
    end
end

function VS.SQL.Migrate()
    Console.Log("[SQL] Initializing database migrations..")
    local db = VS.SQL.Connection

    db:Execute("CREATE TABLE IF NOT EXISTS vs_migrations (version INT NOT NULL); ")
    db:Execute([[
        INSERT INTO vs_migrations
        SELECT 0 FROM DUAL
        WHERE NOT EXISTS (SELECT * FROM vs_migrations);
    ]])

    local db_version = db:Select("SELECT * FROM vs_migrations LIMIT 1;")
    VS.SQL.OnVersionRetrieved(db_version)

end

function VS.SQL.OnVersionRetrieved(data)
    if not data then
        Console.Error("[SQL] Failed to start migrating the database, %s")
        return
    end

    local currentVersion = tonumber(data[1]["version"])
    
    if (not currentVersion) then
        Console.Error("[SQL] Database version is invalid, aborting migration !")
        return
    end

    Console.Log("[SQL] Curent database version is: " ..currentVersion)

    local migration_files = Package.GetFiles(migrations_folder, ".sql")

    for _, filePath in ipairs(migration_files) do
        local exploded_filename = StringUtils.Explode("/", filePath)
        local filename = exploded_filename[#exploded_filename]

        local splited = StringUtils.Explode("_", filename)

        -- Has at least 12_AwesomeMigration
        if (#splited < 2) then
            Console.Warn("[SQL] Invalid migration '%s': naming convention is 'version_migration-name.sql'. Skipping.", filename)
            goto continue
        end

        -- Migrations version is > to 1
        local migration_version = tonumber(splited[1])

        if (not migration_version or migration_version < 1) then
            Console.Warn("[SQL] Invalid migration '%s': version must be a valid number, minimum 1. Skipping.", filename)
            goto continue
        end

        if migrations[migration_version] then
            Console.Warn("[SQL] Migration '%s' conflicts with '%s'. Two migrations cannot have the same version.", filename, migrations[migration_version])
            goto continue
        end

        if migration_version ~= #migrations + 1 then
            Console.Error("[SQL] Migration '%s' does not follow versioning order. Versions must be ordinal.", filename)
            Console.Error("[SQL] Aborting migrations.")
            return
        end

        migrations[migration_version] = filename
        ::continue::
    end

    if #migrations == 0 or #migrations <= currentVersion then
        Console.Log("[SQL] No migrations to run, already up to date.")
        return
    end

    Console.Warn("[SQL] Database is %i version(s) behind! Running migrations.", #migrations - currentVersion)
    RunMigration(currentVersion + 1)
end