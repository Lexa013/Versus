local shouldStop = false

local function checkStopCode(returnedCode)
   if (returnedCode == -1) then
    shouldStop = true
    Server.UnloadPackage(Package.GetName())
   end
end

local function loadModules()
    -- mName : module name && mConfig : module configuration(ex: files, displayName)
    for k, mConfig in ipairs(VS.Modules) do
        Console.Log("[Loader] Loading module: " ..mConfig.pathName)

        local isServer = _ENV["Server"] ~= nil and true or false;
        local moduleFiles = mConfig.files
        local packagePath = Package.GetPath()


        -- Shared include
        for _, sharedFile in ipairs(moduleFiles.shared) do
            if (shouldStop) then return end

            Console.Log("\tLoading SH file: " ..sharedFile)
            returnCode = Package.Require(packagePath.. "/Shared/modules/" ..mConfig.pathName.. "/" ..sharedFile)

            checkStopCode(returnCode)

        end

        -- Server include
        if (isServer) then
            for _, serverFile in ipairs(moduleFiles.server) do
                if (shouldStop) then return end

                Console.Log("\tLoading SV file: " ..serverFile)
                returnCode = Package.Require(packagePath.. "/Server/modules/" ..mConfig.pathName.. "/" ..serverFile)

                checkStopCode(returnCode)
            end
        end

        -- Client include
        if (not isServer) then
            for _, clientFile in ipairs(moduleFiles.client) do
                if (shouldStop) then return end

                Console.Log("\tLoading CL file: " ..clientFile)
                returnCode = Package.Require(packagePath.. "/Client/modules/" ..mConfig.pathName.. "/" ..clientFile)

                checkStopCode(returnCode)
            end
        end
    end
end

loadModules()