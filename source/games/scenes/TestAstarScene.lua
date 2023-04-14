TestAstarScene = {}
class("TestAstarScene").extends(NobleScene)

collisionGroup = {
    p1 = 1,
    p2 = 2,
    bomb = 3,
    item = 4,
    block = 5,
    explosion = 6,
    ignoreP1 = 7,
    ignoreP2 = 8,
}

function TestAstarScene:init()
    TestAstarScene.super.init(self)

    self.tileSize = 16    
    self.gameTileShiftX = 6  
    self.gameTileShiftY = 1  
    self.gameTileWidth = 13  
    self.gameTileHeight = 13 

    TestAstarScene.inputHandler = {
        upButtonHold = function()
            self.player1:Move(self.player1.inputMovement.x, -1)
        end,
        downButtonHold = function()
            self.player1:Move(self.player1.inputMovement.x, 1)
        end,
        leftButtonHold = function()
            self.player1:Move(-1, self.player1.inputMovement.y)
        end,
        rightButtonHold = function()
            self.player1:Move(1, self.player1.inputMovement.y)
        end,
        AButtonDown = function()
            self.player1:dropBomb()
        end
    }

end

function TestAstarScene:enter()
    TestAstarScene.super.enter(self)

    playdate.graphics.setBackgroundColor(playdate.graphics.kColorBlack)

    local sound = playdate.sound.sampleplayer
    self.backgroundMusic = sound.new('sounds/theme.wav')
    self.backgroundMusic:setVolume(0.3)
    self.backgroundMusic:play(0, 1)

    self.gameTileTable = {}
    for i = 1, self.gameTileWidth, 1 do
        self.gameTileTable[i] = {}
        for j = 1, self.gameTileHeight, 1 do
            self.gameTileTable[i][j] = {}
        end
    end

    self.astarTileMapHandler = AstarTileMapHandler(self.tiles)
    self.pathfinder = AstarPathFinder(self.astarTileMapHandler)

    --local path = self.pathFinder:findPath(AstarNode(2, 7), AstarNode(12, 7), manhattanDistance)

    --for i = 2, #path.nodes - 1, 1 do
        --local node = path.nodes[i]
        --self:addElement(Bomb, node.i, node.j)
    --end

    --if not path.success then  
        --local node = path.nodes[1]
        --self:addElement(Bomb, node.i, node.j)
    --end

    for i = 1, self.gameTileWidth, 1 do
        self:addElement(UnbreakableBlock, i, 1)
        self:addElement(UnbreakableBlock, i, self.gameTileHeight)
    end

    for j = 2, self.gameTileHeight - 1, 1 do
        self:addElement(UnbreakableBlock, 1, j)
        self:addElement(UnbreakableBlock, self.gameTileWidth, j)
    end

    for i = 3, self.gameTileWidth - 2, 2 do
        for j = 3, self.gameTileHeight - 2, 2 do
            self:addElement(UnbreakableBlock, i, j)
        end
    end

    self:addElement(NoBlock, 2, 7)
    self:addElement(NoBlock, 12, 7)

    self.player1 = Player(2, 2, P1)
    Player(12, 7, P2)

    local emptySpace = {}
    local emptySpaceIndex = 1

    for i = 2, self.gameTileWidth - 1, 1 do
        for j = 2, self.gameTileHeight - 1, 1 do
            if #self.gameTileTable[i][j] <= 0 then
                emptySpace[emptySpaceIndex] = { i, j }
                emptySpaceIndex = emptySpaceIndex + 1
            end
        end
    end

    local items = {}
    for i = 1, 15, 1 do
        items[#items + 1] = FlameItem
        items[#items + 1] = BombItem
        items[#items + 1] = SpeedItem
    end
    items[#items + 1] = MegaFlameItem

    local index = 1
    local nbBloc = 15

    while nbBloc ~= 0 do
        local elementsIndex = math.random(#emptySpace)
        local coord = table.remove(emptySpace, elementsIndex)
        local i = coord[1]
        local j = coord[2]

        self:addElement(BreakableBlock, i, j)

        if index <= #items then
            self:addElement(items[index], i, j)
            index = index + 1
        end
        nbBloc = nbBloc - 1
    end

    local nbBloc = math.floor(#emptySpace * 0.2)

    while nbBloc ~= 0 do
        local elementsIndex = math.random(#emptySpace)
        local coord = table.remove(emptySpace, elementsIndex)
        local i, j = coord[1], coord[2]
        self:addElement(BreakableBlock, i, j)
        nbBloc = nbBloc - 1
    end

    for i = 2, self.gameTileWidth - 1, 1 do
        for j = 2, self.gameTileHeight - 1, 1 do
            self:addElement(Floor, i, j)
            self:updateFloor(i, j)
        end
    end

    self.tiles = {}

    for i = 1, self.gameTileWidth, 1 do
        self.tiles[i] = {}
        for j = 1, self.gameTileHeight, 1 do
            self.tiles[i][j] = containsClass(self.gameTileTable[i][j], Block) and 1 or 0
        end
    end

end

function TestAstarScene:start()
    TestAstarScene.super.start(self)
end

function TestAstarScene:drawBackground()
    TestAstarScene.super.drawBackground(self)
end

function TestAstarScene:update()
    TestAstarScene.super.update(self)
end

function TestAstarScene:exit()
    TestAstarScene.super.exit(self)
end

function TestAstarScene:finish()
    TestAstarScene.super.finish(self)
end

function TestAstarScene:getPositionAtCoordinates(i, j)
    return ((i - 1) + 0.5 + self.gameTileShiftX) * self.tileSize,
        ((j - 1) + 0.5 + self.gameTileShiftY) * self.tileSize
end

function TestAstarScene:getcoordinates(x, y)
    return math.floor((x / self.tileSize) - self.gameTileShiftX + 1),
        math.floor((y / self.tileSize) - self.gameTileShiftY + 1)
end

function TestAstarScene:addElement(Type, i, j, ...)
    local tileSprites = self.gameTileTable[i][j]
    tileSprites[#tileSprites + 1] = Type(i, j, ...)
end

function TestAstarScene:updateFloor(i, j)
    local floor = self:getElementOfTypeAt(Floor, i, j)

    local caseTable = self.gameTileTable[i][j - 1]
    local shadow = containsClass(caseTable, Block)

    if floor then
        floor:setShadow(shadow)
    end
end

function TestAstarScene:getElementOfTypeAt(type, i, j)
    return getObjectOfClass(self.gameTileTable[i][j], type)
end