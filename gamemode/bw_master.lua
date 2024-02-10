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
            PlyRepo.SavePlayerData(playerInst, function()
                print("[BW] all player data hase been saved.")
            end)
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

hook.Add("PlayerInitialSpawn", "bw_masterPlayerInitSpawn", function(ply)
    createPlayerInstance(ply)
end)

hook.Add("PlayerDisconnected", "bw_masterPlayerDisconnected", function(ply)
    removePlayerInstance(ply)
end)

timer.Create("AutoSavePlayerData", conf.autoSaveTime or 30, 0, saveAllData)

PlyRepo.connect()