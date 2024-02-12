local Item = {}
Item.__index = Item

function Item.new(name, description, value, icon, model, sellable, dropable)
    local self = setmetatable({}, Item)
    self.id = nil
    self.name = name or "no name"
    self.description = description or "no description"
    self.value = value or 0
    self.icon = icon or nil
    self.model = model or nil
    self.sellable = sellable or false 
    self.dropable = dropable or false

    return self
end

function Item:Drop(pos)
    
end

function Item:use()
    print("[BW] item ".. self.name .. " id: " .. self.id .. " did nothing intresting")
end

function Item:SetId(id)
    self.id = id
end

function Item:__tostring()
    return "[BW] item ".. self.name .. " id: " .. self.id 
end

return Item