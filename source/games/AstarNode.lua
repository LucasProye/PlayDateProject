class("AstarNode").extends()

function AstarNode:init(i, j)
    self.i = i
    self.j = j
    self.G = 0
    self.H = 0
    self.F = 0
    self.parent = nil
end

function AstarNode:update(G, H, parent)
    self.G = G
    self.H = H
    self.F = G + H
    self.parent = parent
end

function AstarNode:asSameCoordinate(node)
    return node.i == self.i and node.j == self.j
end