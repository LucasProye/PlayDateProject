class("AstarPathFinder").extends()

function AstarPathFinder:init(mapHandler)
    self.mapHandler = mapHandler
end

function containsNode(list, node)
    for _, nodeInList in pairs(list) do
        if nodeInList:asSameCoordinate(node) then
            return true
        end
    end
    return false
end

function AstarPathFinder:findPath(startNode, endNode, heuristicFunction)
    self.openNodes = {}
    self.closedNodes = {}

    startNode.H = heuristicFunction(startNode.i, startNode.j, endNode.i, endNode.j)
    table.insert(self.openNodes, startNode)


    local success = false

    while not success and #self.openNodes ~= 0 do
        local bestOpenNode = self:getBestOpenNode()

        table.remove(self.openNodes, table.indexOfElement(self.openNodes, bestOpenNode))
        table.insert(self.closedNodes, bestOpenNode)
				
				if bestOpenNode:asSameCoordinate(endNode) then
            success = true
            break
        end

				local adjacentNodes = self.mapHandler:getAdjacentNodes(bestOpenNode)

        for i = 1, #adjacentNodes, 1 do
            local node = adjacentNodes[i]

						if containsNode(self.closedNodes, node) then
                goto continue
            end
						
						node:update(
                bestOpenNode.G + self.mapHandler:GetDistanceBetweenNode(node, bestOpenNode, heuristicFunction),
                heuristicFunction(node.i, node.j, endNode.i, endNode.j),
                bestOpenNode
            )

						local indexOfNode = table.indexOfElement(self.openNodes)

            if indexOfNode == nil then
                table.insert(self.openNodes, node)
                print("add", node.i, node.j)
            elseif self.openNodes[indexOfNode].F > node.F then
                self.openNodes[indexOfNode] = node
            end

						::continue::
				end

		end

		local path = AstarPath(success, {})

		local pathNode = self.closedNodes[#self.closedNodes]

        if not success then
            for i = 1, #self.closedNodes - 1, 1 do
                if self.closedNodes[i].H < pathNode.H then
                    pathNode = self.closedNodes[i]
                end
            end
        end

        repeat
            print(pathNode.i, pathNode.j)
            table.insert(path.nodes, pathNode)
            pathNode = pathNode.parent
        until pathNode == nil

        return path  
end