PlayerRepoSingleton = PlayerRepoSingleton or nil

if not PlayerRepoSingleton then
    require("mysqloo")
    
    local mysql = include("conf.lua").playerDB
    local PlyClass = include("player.lua")
    PlayerRepo = {}

    PlayerRepo.retryCount = 0
    PlayerRepo.maxRetries = 5
    PlayerRepo.retryDelay = 5
    PlayerRepo.saveDisabled = false
    PlayerRepo.db = mysqloo.connect(mysql.host, mysql.user, mysql.pass, "", mysql.port, mysql.sock)
    PlayerRepo.db:setAutoReconnect(true)

    function PlayerRepo:DisableSaving()
        if PlayerRepo.saveDisabled then return end
        print("[BW] DISABLING PLAYER REPO SAVING.")
        PlayerRepo.saveDisabled = true
    end

    function PlayerRepo.db:onConnected() 
        print("[BW] Player Database has connected.")
        PlayerRepo.retryCount = 0

        local query = PlayerRepo.db:query("USE basewars")
        function query:onSuccess(data)
            print(data)
        end
    
        function query:onError(err)
            print("[BW] could not use basewars db. error: '" .. err .. "' if this is your frist time run bw_init_db.")
            PlayerRepo:DisableSaving()
        end
        query:start()
    end

    --make a admin comand and method to manuly reconnect
    function PlayerRepo.db:onConnectionFailed(err) 
        print("[BW] Player database failed! Error:", err)
        print("[BW] (DEBUG) Player database credentals:", mysql.host, mysql.user, mysql.pass, mysql.port, mysql.sock)
        if PlayerRepo.retryCount < PlayerRepo.maxRetries then
            print("[BW] reconnecting to Player database again in 5 seconds.")
            PlayerRepo.retryCount = PlayerRepo.retryCount + 1
            timer.Simple(PlayerRepo.retryDelay, function() PlayerRepo.connect() end)
        else
            print("[BW] maxRetries reached for Player database.")
        end
    end
  
    function PlayerRepo.connect()
        if PlayerRepo.db:status() == 0 then return end--connected
        PlayerRepo.db:connect() 
    end

    --fix the database so money, levels, prestige, inventory, etc are all in subtables in the db
    function PlayerRepo.LoadPlayerData(ply, success, fail)
        local queryStr = string.format("SELECT * FROM player WHERE id = '%s';", ply:SteamID64())
        local query = PlayerRepo.db:query(queryStr)
        print("[BW] loading Player data for ".. ply:Nick() .." SteamID: " .. ply:SteamID64())

        function query:onSuccess(data)
            if #data > 0 then
                local pData = data[1]
                local plyInst = PlyClass.new(ply, pData, pData, pData)
                if success then success(plyInst) end
            else
                print("[BW] Creating new Player data for ".. ply:Nick() .." SteamID: " .. ply:SteamID64())
                if success then success(PlyClass.new(ply, {}, {}, {})) end
            end
        end
    
        function query:onError(err)
            print("[BW] failed to load Player data for ".. ply:Nick() .."! SteamID: " .. ply:SteamID64() .." Error:", err)
            PlayerRepo:DisableSaving()
            if fail then fail(PlyClass.new()) end
        end
    
        query:start()
    end
    --querystring needs to update feilds
    function PlayerRepo.SavePlayerData(plyInst, success, fail)
        if PlayerRepo.saveDisabled then fail() return end
        local queryStr = string.format("UPDATE ply SET money = '%s' WHERE id = '%s';" , plyInst:GetMoney() , plyInst.ply:SteamID64())
        local query = PlayerRepo.db:query(queryStr)
        print("[BW] Saving Player data for ".. plyInst.ply:Nick() .." SteamID: " .. plyInst.ply:SteamID64())

        function query:onSuccess()
            if success then success() end
        end
    
        function query:onError(err)
            print("[BW] failed to save player data for ".. plyInst.ply:Nick() .."! SteamID: " .. plyInst.ply:SteamID64() .." Error:", err)
            PlayerRepo:DisableSaving()
            if fail then fail() end
        end

        query:start()
    end

    PlayerRepoSingleton = PlayerRepo
end

return PlayerRepoSingleton