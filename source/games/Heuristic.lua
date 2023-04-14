class("Heuristic").extends()


function manhattanDistance(ax, ay, bx, by)
    local dx = math.abs(ax - bx)
    local dy = math.abs(ay - by)
    return dx + dy
end

function sqrDistance(ax, ay, bx, by)
    local dx = math.abs(ax - bx)
    local dy = math.abs(ay - by)
    return dx * dx + dy * dy
end

function distance(ax, ay, bx, by)
    return math.sqrt(sqrDistance(ax, ay, bx, by))
end