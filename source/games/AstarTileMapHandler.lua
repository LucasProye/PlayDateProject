class("AstarTileMapHandler").extends()

-- on initialise note map avec un tableau de 1 et de 0
function AstarTileMapHandler:init(tiles)
    self.tiles = tiles
end

-- on définit une fonction qui permet de récuperer le node aux coordonées i , j
function AstarTileMapHandler:getNode(i, j)
		-- si i et j sont en dehors des limites on renvoie nil
    if i > #self.tiles[1] or j > #self.tiles then
        return nil
    end

    if i < 1 or j < 1 then
        return nil
    end


		-- si la case i j contient un 1 on revoie nil
    if self.tiles[i][j] == 1 then
        return nil
    end

		-- Sinon on crée et on renvoie un Node
    return AstarNode(i, j)
end

-- cette fonction permet de renvoyer la liste des voisins de notre noeud
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

-- calcule de la distance entre deux noeud du graph en utilisant une heuristique
function AstarTileMapHandler:GetDistanceBetweenNode(A, B, heuristicFunction)
    return heuristicFunction(A.i, A.j, B.i, B.j)
end

