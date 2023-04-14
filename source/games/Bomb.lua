class('Bomb').extends(TileObject)

function Bomb:init(i, j, power)
    Bomb.super.init(self, i, j, 3, true)

    local animationSpeed = 10

    self.power = power

    local sound = playdate.sound.sampleplayer
    self.bombExplode = sound.new('sounds/Bomb Explodes.wav')

    print(self:isa(TileObject))

    self:addState('BombStart', 1, 3, {
        tickStep = animationSpeed,
        yoyo = true,
        loop = 4,
        nextAnimation = 'BombEnd',
        frames = { 29, 30, 31 }
    }).asDefault()

    self:addState('BombEnd', 1, 10, {
        tickStep = animationSpeed / 2,
        yoyo = true,
        loop = false,
        frames = { 30, 31, 30, 29, 30, 31, 30, 29, 30, 31 }
    })

    self:addState('ExplosionCenter', 1, 6, {
        tickStep = animationSpeed / 2,
        yoyo = true,
        loop = false,
        frames = { 24, 17, 10, 3 }
    })

    function Bomb:AddExplosionChunk()

    end

    self:playAnimation()

    self:setGroups({ collisionGroup.bomb })

    self.states.BombEnd.onAnimationEndEvent = function(self)
        self:explode()
    end

    function Bomb:explodeDirection(i, j, di, dj)
        local sprites = playdate.graphics.sprite.querySpritesAtPoint(Noble.currentScene():getPositionAtCoordinates(i + di, j + dj))

        local needToCreateExplosion = true

        if sprites ~= nil then
            for index = 1, #sprites, 1 do
                local sprite = sprites[index]

                if sprite ~= nil then
                    if sprite:isa(Item) then
                        sprite:remove()
                        GameScene:addElement(ItemExplode, i + di, j + dj)
                        return true
                    end

                    if sprite:isa(BreakableBlock) then
                        sprite:breakBloc()
                        return true
                    end

                    if sprite:isa(UnbreakableBlock) then
                        return true
                    end

                    if sprite:isa(Bomb) then
                        playdate.timer.performAfterDelay(50, sprite.explode, sprite)
                        return true
                    end

                    if sprite:isa(Player) then
                        playdate.timer.performAfterDelay(50, sprite.kill, sprite)
                    end

                    if sprite:isa(Explosion) then
                        needToCreateExplosion = false
                        local state = sprite.currentState
                        sprite:stopAnimation()
                        sprite:changeState(state, true)
                        sprite:changeState('explosionMiddle', true)
                    end
                end
            end
        end

        if needToCreateExplosion then
            if di == self.power then
                Noble.currentScene():addElement(Explosion, i + di, j + dj, 'explosionRight')
            elseif di == -self.power then
                Noble.currentScene():addElement(Explosion, i + di, j + dj, 'explosionLeft')
            elseif dj == -self.power then
                Noble.currentScene():addElement(Explosion, i + di, j + dj, 'explosionUp')
            elseif dj == self.power then
                Noble.currentScene():addElement(Explosion, i + di, j + dj, 'explosionDown')
            elseif di > 0 or di < 0 then
                Noble.currentScene():addElement(Explosion, i + di, j + dj, 'explosionHorizontal')
            elseif dj > 0 or dj < 0 then
                Noble.currentScene():addElement(Explosion, i + di, j + dj, 'explosionVertical')
            end
        end

        return false
    end

    function Bomb:explode()
        self:remove()
        self.isExploded = true

        self.bombExplode:play(1, 1)

        local screenShaker = ScreenShaker()
        screenShaker:start(0.8, 3, playdate.easingFunctions.inOutCubic)

        local i, j = Noble.currentScene():getcoordinates(self.x, self.y)

        Noble.currentScene():addElement(Explosion, i, j, 'explosionMiddle')

        for index = 1, self.power, 1 do
            if self:explodeDirection(i, j, index, 0) then
                break
            end
        end

        for index = 1, self.power, 1 do
            if self:explodeDirection(i, j, -index, 0) then
                break
            end
        end

        for index = 1, self.power, 1 do
            if self:explodeDirection(i, j, 0, -index) then
                break
            end
        end

        for index = 1, self.power, 1 do
            if self:explodeDirection(i, j, 0, index) then
                break
            end
        end
    end

    self.states.ExplosionCenter.onAnimationEndEvent = function(self)
        self:remove()
    end
end