local conf = include("conf.lua").player
local Level = {}
Level.__index = Level

function Level.new(level, xp, maxLevel)
    local self = setmetatable({}, Level)
    self.level = 1
    self.xp = 0
    self.maxLevel = maxLevel or conf.maxLevel or 200
    self.maxXp = 100
    return self
end

function Level:CalcNewMaxXp()
    self.maxXp = baseXP * math.pow(conf.growthFactor, self.level - 1)
end

function Level:addLevel(amount)
    amount = amount or 1
    self.level = self.level + amount
    self:CalcNewMaxXp()
end

function Level:AddXp(amount)
    if self.xp + amount >= self.maxXp then
        amount = (self.xp + amount) - self.maxXp
        self:AddLevel()
        self:AddXp(amount)
    else
        self.xp = self.xp + amount
    end
end

function Level:GetLevel()
    return self.level
end

function Level:GetXp()
    return self.xp
end

function Level:SetLevel(num)
    self.level = num
end

function Level:SetXP(num)
    self.xp = num
end

return Level