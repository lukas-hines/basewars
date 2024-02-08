--lost to drive fail, only i could recover

local Money = {}
Money.__index = Money

function Money:new(amount)
    local self = setmetatable({}, Money)
    self.value = amount or 5000
    return self
end

function Money:AddMoney(amount)
    self.value = self.value + amount
    self:formatMoney()
end

function Money:SetAmount(amount)
    self.value = amount
    self:formatMoney()
    print("i have " .. self.value .. " or ".. self.valueStr)
end

function Money:RemoveMoney(amount)
    if amount > self.value then
        error("Not enough money to remove.")
        return
    end
    self.value = self.value - amount
    self:formatMoney()
end

function Money:CanAfford(amount)
    return self.value >= amount
end

function Money:GetMoneyString()
    local num = self.value
    local units = {[10^18] = "Quintillion", [10^15] = "Quadrillion", [10^12] = "Trillion", [10^9] = "Billion", [10^6] = "Million"}

    local absNum = math.abs(num)
    for Div, Str in pairs(units) do
        if absNum >= Div then
            return string.Comma(math.Round(num / Div, 1)) .. " " .. Str
        end
    end
    return tostring(num)
end

function Money:GetMoney()
    return self.value
end

function Money:SetMoney(num)
    self.value = num
end

return Money