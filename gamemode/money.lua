--lost to drive fail, only i could recover

local Money = {}
Money.__index = Money

function Money:new(money)
    local self = setmetatable({}, Money)
    self.money = money or 5000
    return self
end

function Money:CanAfford(amount)
    return self.money >= amount
end

function Money:SpendMoney(amount, success, fail)
    if self.CanAfford(amount) then
        self.money = self.money - amount
        if success then success() end
    else
        if fail then fail() end
    end
end

function Money:AddMoney(amount)
    --prob want to check max number so i dont overflow..
    self.money = self.money + amount
end

function Money:RemoveMoney(amount)
    if amount > self.money then
        print("[BW] Not enough money to remove.")
        --should i just dump there account?
        return
    else
        self.money = self.money - amount
    end
end

function Money:DropMoney(pos, amount, fail)
    if self.CanAfford(amount) then
    --sanitise the position. maybe have a lib for that stuff.
    --drop money at position passed
    elseif fail then
        print("[BW] could not afford to drop money")
        print(debug.traceback())
        fail()
    end
end

function Money:GetMoneyAsString()
    local num = self.money
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
    return self.money
end

function Money:SetMoney(value)
    self.money = value
end

return Money