local Level = {}
Level.__index = Level

function Level.new(level, xp, maxLevel, growth, basexp)
    local self = setmetatable({}, Level)
    self.level = level or 1
    self.xp = xp or 0
    self.maxLevel = maxLevel or 80
    self.growth = growth or 1
    self.basexp = basexp or 100

    self:xpToNextLevel = -1
    CalcNewMaxXp()
    return self
end

function Level:CalcNewMaxXp()
    self.xpToNextLevel = self.basexp * math.pow(self.growth, self.level - 1)
end

function Level:addLevel(amount)
    amount = amount or 1
    if self.level + amount > self.maxLevel then
        self.level = self.maxLevel
    else
        self.level = math.max(1, self.level + amount)
    end
    self:CalcNewMaxXp()
end

function Level:AddXp(amount)
    while amount > 0 and self.level < self.maxLevel do
        if self.xp + amount >= self.xpToNextLevel then
            amount = (self.xp + amount) - self.xpToNextLevel
            -- Level up and recalculate xpToNextLevel inside AddLevel
            self:AddLevel()
            if self.level == self.maxLevel then
                self.xp = math.min(amount, self.xpToNextLevel)
                break
            end
        else
            self.xp = self.xp + amount
            amount = 0
        end
    end
end

function Level:GetLevel()
    return self.level
end

function Level:GetXp()
    return self.xp
end

function Level:SetLevelSafe(num)
    if num < 1 then print("[BW] cannot set level to a invalid number.") return end
    self.level = num -1
    self:CalcNewMaxXp()
    self.xp = self.xpToNextLevel
    self.level = num
    self:CalcNewMaxXp()
end

function Level:SetLevel(num)
    self.level = num
end

function Level:SetXP(num)
    self.xp = num
end

return Level