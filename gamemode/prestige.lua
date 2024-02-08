local Prestige = {}
Prestige.__index = Prestige

function Prestige.new(p)
    local self = setmetatable({}, Prestige)
    self.prestige = p.prestige or 0
    self.prestigePoints = p.points or 0
    self.boosts = {
        moneyBoost = p.moneyBoost or 1,
        xpBoost = p.xpBoost or 1,
        helthBoost = p.helthBoost or 1,
        armorBoost = p.armorBoost or 1,
        speedBoost = p.speedBoost or 1,
        propDamageBoost = p.propDamageBoost or 1
    }
    --do something here or in the player to add there default defualt items.
    return self
end

function Prestige:CanAfford(amount)
    return self.prestige >= amount
end

function Prestige:SpendPrestigePoints(amount, callback)
    if not CanAfford(amount) then
        error("Not enough prestige points to remove.")
        return
    end
    self.prestige = self.prestige - amount
    callback()
end

function Prestige:AddPrestige(num)
    num = num or 1
    self.prestige = self.prestige + num
    self.prestigePoints = self.prestigePoints + num
end

function Prestige:GetPoint()
    return self.prestigePoints
end

function Prestige:SetPoints(amount)
    self.prestigePoints =  amount
end

function Prestige:GetPrestige()
    return self.prestige
end

function Prestige:SetPrestige(num)
    self.prestige = num
end

return Prestige