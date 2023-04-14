WorldScene = {}
class("WorldScene").extends(NobleScene)

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

function WorldScene:init()
    WorldScene.super.init(self)

    self.tileSize = 16       -- la size d'une tile en pixels
    self.gameTileShiftX = 6  -- le décallage horizontale en nombre de tile
    self.gameTileShiftY = 1  -- le décallage verticale en nombre de tile
    self.gameTileWidth = 13  -- la largeur en nombre de tile
    self.gameTileHeight = 13 -- la hauteur en nombre de tile

    WorldScene.inputHandler = {
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

function WorldScene:enter()
    WorldScene.super.enter(self)

    playdate.graphics.setBackgroundColor(playdate.graphics.kColorBlack)

    math.randomseed(playdate.getSecondsSinceEpoch())

    self.player1 = Player(2, 2, P1)
    Player(12, 7, P2)


    self.gameTileTable = {}
    for i = 1, self.gameTileWidth, 1 do
        self.gameTileTable[i] = {}
        for j = 1, self.gameTileHeight, 1 do
            self.gameTileTable[i][j] = {}
        end
    end

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

    self:addElement(NoBlock, 2, 2)
    self:addElement(NoBlock, 3, 2)
    self:addElement(NoBlock, 2, 3)

    self:addElement(NoBlock, self.gameTileWidth - 1, self.gameTileHeight - 1)
    self:addElement(NoBlock, self.gameTileWidth - 1, self.gameTileHeight - 2)
    self:addElement(NoBlock, self.gameTileWidth - 2, self.gameTileHeight - 1)

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
    local nbBloc = 80

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

    local nbBloc = math.floor(#emptySpace * 0.6)

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
end

function WorldScene:start()
    WorldScene.super.start(self)
end

function WorldScene:drawBackground()
    WorldScene.super.drawBackground(self)
end

function WorldScene:update()
    WorldScene.super.update(self)
end

function WorldScene:exit()
    WorldScene.super.exit(self)
end

function WorldScene:finish()
    WorldScene.super.finish(self)
end

function WorldScene:getPositionAtCoordinates(i, j)
    return ((i - 1) + 0.5 + self.gameTileShiftX) * self.tileSize,
        ((j - 1) + 0.5 + self.gameTileShiftY) * self.tileSize
end

function WorldScene:getcoordinates(x, y)
    return math.floor((x / self.tileSize) - self.gameTileShiftX + 1),
        math.floor((y / self.tileSize) - self.gameTileShiftY + 1)
end

function WorldScene:addElement(Type, i, j, ...)
    local tileSprites = self.gameTileTable[i][j]
    tileSprites[#tileSprites + 1] = Type(i, j, ...)
end

function WorldScene:updateFloor(i, j)
    local floor = self:getElementOfTypeAt(Floor, i, j)

    local caseTable = self.gameTileTable[i][j - 1]
    local shadow = containsClass(caseTable, Block)

    if floor then
        floor:setShadow(shadow)
    end
end

function WorldScene:getElementOfTypeAt(type, i, j)
    return getObjectOfClass(self.gameTileTable[i][j], type)
end