function containsClass(list, type)
    for _, value in pairs(list) do
        if value:isa(type) then
            return true
        end
    end
    return false
end


function getObjectOfClass(list, type)
    for _, value in pairs(list) do
        if value:isa(type) then
            return value
        end
    end
    return nil
end