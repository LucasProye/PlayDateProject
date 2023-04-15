class("AstarTileMapHandler").extends()

function AstarTileMapHandler:init(tiles)
    self.tiles = tiles
end

function AstarTileMapHandler:getNode(i, j)
    if i > #self.tiles[1] or j > #self.tiles then
        return nil
    end

    if i < 1 or j < 1 then
        return nil
    end

    if self.tiles[i][j] == 1 then
        return nil
    end

    return AstarNode(i, j)
end

function AstarTileMapHandler:getAdjacentNodes(currentNode)
    local nodes = {}

    local adjacentNode = nil

    adjacentNode = self:getNode(currentNode.i + 1, currentNode.j)
    if adjacentNode ~= nil then
        table.insert(nodes, adjacentNode)
    end

    adjacentNode = self:getNode(currentNode.i - 1, currentNode.j)
    if adjacentNode ~= nil then
        table.insert(nodes, adjacentNode)
    end

    adjacentNode = self:getNode(currentNode.i, currentNode.j + 1)
    if adjacentNode ~= nil then
        table.insert(nodes, adjacentNode)
    end

    adjacentNode = self:getNode(currentNode.i, currentNode.j - 1)
    if adjacentNode ~= nil then
        table.insert(nodes, adjacentNode)
    end

    return nodes
end

function AstarTileMapHandler:GetDistanceBetweenNode(A, B, heuristicFunction)
    return heuristicFunction(A.i, A.j, B.i, B.j)
end
