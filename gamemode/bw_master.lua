local PlyRepo = include("playerRepo.lua")
local PlyClass = include("player.lua")
local conf = include("conf.lua")

local playerInsts = {}

local function createPlayerInstance(ply)    
    PlayerRepo.LoadPlayerData(ply, 
        function(LoadedPlayer)
            LoadedPlayer.ply = ply
            playerInsts[ply] = LoadedPlayer
        end)    
end

local function removePlayerInstance(ply)
    PlyRepo.SavePlayerData(playerInsts[ply], function()
            playerInsts[ply] = nil
        end)
end

local function saveAllData(callBack)
    print("[BW] saving all data")
    for ply, playerInst in pairs(playerInsts) do
        if playerInsts[#playerInsts] == playerInst then
            PlyRepo.SavePlayerData(playerInst,callBack)
        else
            PlyRepo.SavePlayerData(playerInst)
        end
    end
end

concommand.Add("bw_prep_shutdown", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsSuperAdmin() then
        ply:PrintMessage(HUD_PRINTCONSOLE, "You do not have permission to use this command.")
        return
    end

    print("[BW] preping shut down.")
    saveAllData(function()
        print("[BW] its now safe for you to run quit")
    end)
end)

--i know this all looks bad i plab to make a command file some where.
local initConfirmation = false
concommand.Add("bw_init_db", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsSuperAdmin() then
        ply:PrintMessage(HUD_PRINTCONSOLE, "You do not have permission to use this command.")
        return
    end

    if initConfirmation then 
        initConfirmation = false
        ply:PrintMessage(HUD_PRINTCONSOLE, "[BW] formating database..")

        require("mysqloo")
        local mysql = conf.mysqlDB

        local db = mysqloo.connect(mysql.host, mysql.user, mysql.pass, "", mysql.port, mysql.sock)
        
        function db:onConnected()
            local query = db:query("DROP DATABASE IF EXISTS basewars;CREATE DATABASE basewars;")
            function query:onSuccess(data)
                ply:PrintMessage(HUD_PRINTCONSOLE, "[BW] database formated.")

                PlyRepo.initdb(function()
                    ply:PrintMessage(HUD_PRINTCONSOLE, "[BW] database player tabled created.")
                end,function()
                    ply:PrintMessage(HUD_PRINTCONSOLE, "[BW] database player tabled failed to be created.")
                end)

                --add inits for other db as they are made.
            end
            function query:onError(err)
                ply:PrintMessage(HUD_PRINTCONSOLE, "[BW] unable to format db. error:", err)
            end
            query:start()
        end
        function db:onConnectionFailed(err) 
            ply:PrintMessage(HUD_PRINTCONSOLE, "[BW] (bw_init_db) can not connect to db. is your mysql server down? error:", err)
        end
        db:connect() 
        return
    end
    --i hate non monospaced fonts
    ply:PrintMessage(HUD_PRINTCONSOLE, "[BW]   ___________________________________________")
    ply:PrintMessage(HUD_PRINTCONSOLE, "[BW] |                                                                                     |")
    ply:PrintMessage(HUD_PRINTCONSOLE, "[BW] |  WARNING THIS WILL DELETE ALL DATABASES |")
    ply:PrintMessage(HUD_PRINTCONSOLE, "[BW] |            Only run this if its your first time             |")
    ply:PrintMessage(HUD_PRINTCONSOLE, "[BW] |                                                                                     |")
    ply:PrintMessage(HUD_PRINTCONSOLE, "[BW]  \\__________________________________________/")
    ply:PrintMessage(HUD_PRINTCONSOLE, "[BW] run bw_init_db again to confirm and run the command")

    initConfirmation = true

    timer.Simple(15, function() 
        if initConfirmation == false then return end
        initConfirmation = false
        ply:PrintMessage(HUD_PRINTCONSOLE, "[BW] bw_init_db has been canceled due to no confirmation")
    end)

end)

hook.Add("PlayerInitialSpawn", "bw_masterPlayerInitSpawn", function(ply)
    createPlayerInstance(ply)
end)

hook.Add("PlayerDisconnected", "bw_masterPlayerDisconnected", function(ply)
    removePlayerInstance(ply)
end)

timer.Create("AutoSavePlayerData", conf.autoSaveTime or 30, 0, saveAllData)

PlyRepo.connect()