local PlyRepo = include("playerRepo.lua")
local PlyClass = include("player.lua")
local conf = include("conf.lua")

PlyRepo.connect()

local playerInsts = {}

local function createPlayerInstance(ply)
    if not IsValid(ply) or playerInsts[ply] then return end
    PlayerRepo.LoadPlayerData(ply, 
        function(LoadedPlayer)
            LoadedPlayer.ply = ply
            playerInsts[ply] = LoadedPlayer
        end)
end

--make a save to database in playerRepo
local function removePlayerInstance(ply)
    local data = playerInsts[ply]
    PlyRepo.SavePlayerData(data)

    playerInsts[ply] = nil
end

local function saveAllData(callBack)
    print("[BW] saving all data")
    for ply, playerInst in pairs(playerInsts) do
        if playerInsts[#playerInsts] == playerInst then
            PlyRepo.SavePlayerData(playerInst, function()
                print("[BW] all player data hase been saved.")
            end)
        else
            PlyRepo.SavePlayerData()
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

--timer.Create("AutoSavePlayerData", conf.autoSaveTime, 0, saveAllData)

hook.Add("PlayerInitialSpawn", "bw_masterPlayerInitSpawn", function(ply)
    createPlayerInstance(ply)
end)

hook.Add("PlayerDisconnected", "bw_masterPlayerDisconnected", function(ply)
    removePlayerInstance(ply)
end)

