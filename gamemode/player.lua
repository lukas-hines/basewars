local Money = include("money.lua")
local Level = include("level.lua")
local Prestige = include("prestige.lua")
local conf = include("conf.lua").player

--local Inventory = include("inventory.lua")

local plyClass = {}
plyClass.__index = plyClass

--print(money, level, xp, prestige, prestigePoints)
--make db get these as tables.
function plyClass.new(ply, plyData, prestigeData, inventoryData)
    local self = setmetatable({}, plyClass)
    self.ply = ply
    self.Money = Money.new(plyData.money)
    self.Level = Level.new(plyData.level, plyData.xp, conf.maxLevel or 80)
    self.Prestige = Prestige.new(prestigeData)
    --self.InventorySys = Inventory.new(inventoryData)

    return self
end


function plyClass:SpendMoney(amount, success, fail)
    self.Money:SpendMoney(amount / self.PrestigeSys:GetMoneyReduction(), success, fail)
end
function plyClass:SpendMoneyRaw(amount, success, fail)
    self.Money:SpendMoney(amount, success, fail)
end

function plyClass:AddMoney(amount)
    self.Money:AddMoney(amount * self.Prestige:GetMoneyBoost())
end
function plyClass:AddMoneyRaw(amount)
    self.Money:AddMoney(ammount)
end

function plyClass:RemoveMoney(amount)
    self.Money:RemoveMoney(amount) 
end

function plyClass:DropMoney(amount)
    --get position where you want to drop money.
    --ply wont work. fix this
    self.Money:DropMoney(self.ply, ammount, function()
        
    end)
end

function plyClass:GetMoneyAsString()
    return self.Money:GetMoneyAsString()
end

function plyClass:GetMoney()
    --do not use this for any logic. output use only!!!
    return self.Money:GetMoney()
end


function plyClass:AddXp(amount)
    self.Level:AddXp(amount * self.Prestige:GetXpBoost())
end
function plyClass:AddXpRaw()
    self.Level:AddXp(amount)
end

function plyClass:GetXp()
    self.Level:GetXp()
end

function plyClass:GetLevel()
    self.Level:GetLevel()
end


if SERVER then
    util.AddNetworkString("UpdatePlyMoney")
    util.AddNetworkString("UpdatePlyXp")
    util.AddNetworkString("UpdatePlyLevel")
    util.AddNetworkString("UpdatePlyPrestige")
    util.AddNetworkString("UpdatePlyPrestigePoints")
end 

if CLIENT then
    net.Receive("UpdatePlyMoney", function()
    
    end)

    net.Receive("UpdatePlyXp", function()
    
    end)

    net.Receive("UpdatePlyLevel", function()
    
    end)

    net.Receive("UpdatePlyPrestige", function()
    
    end)

    net.Receive("UpdatePlyPrestigePoints", function()
    
    end)
end

return plyClass