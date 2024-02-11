local Item = {}
Item.__index = Item

function Item.new(name, description, value, sellable)
    local self = setmetatable({}, Item)
    self.id = nil
    self.name = name or "no name"
    self.description = description or "no description"
    self.value = value

    return self
end

function Item:SetId(id)
    self.id = id
end

function Item:use()
    print("[BW] item ".. self.name .. " id: " .. self.id .. " did nothing intresting")
end

function Item:__tostring()
    return "[BW] item ".. self.name .. " id: " .. self.id 
end

return Item