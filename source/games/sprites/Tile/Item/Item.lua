class('Item').extends(TileObject)

function Item:init(i, j, imageIndex)
    Item.super.init(self, i, j, 2, 1, true)
    self:setGroups({})
    local sound = playdate.sound.sampleplayer
    self.takeItem = sound.new('sounds/Item Get.wav')
    self:setCollideRect(2, 2, 12, 12)
    self:setImageWithIndex(imageIndex)
end

function Item:activate()
    self:setGroups({ collisionGroup.item })
end

function Item:take()
    self:remove()
    self.takeItem:play(1, 1)
end

class('Empty').extends(TileObject)

function Empty.new(i, j)
    return Empty(i, j)
end

function Empty:init(i, j)
    local x, y = getPositionAtCoordonate(i, j)
    self:moveTo(x, y)
end

class('BombItem').extends('Item')

function BombItem.new(i, j)
    return BombItem(i, j)
end

function BombItem:init(i, j)
    BombItem.super.init(self, i, j, 40)
end

class('FlameItem').extends('Item')

function FlameItem.new(i, j)
    return FlameItem(i, j)
end

function FlameItem:init(i, j)
    FlameItem.super.init(self, i, j, 38)
end

class('MegaFlameItem').extends('Item')

function MegaFlameItem.new(i, j)
    return MegaFlameItem(i, j)
end

function MegaFlameItem:init(i, j)
    MegaFlameItem.super.init(self, i, j, 39)
end

class('SpeedItem').extends('Item')

function SpeedItem.new(i, j)
    return SpeedItem(i, j)
end

function SpeedItem:init(i, j)
    SpeedItem.super.init(self, i, j, 37)
end

class('ItemExplode').extends(ObjectMap)

function ItemExplode.new(i, j)
    return ItemExplode(i, j)
end

function ItemExplode:init(i, j)
    ItemExplode.super.init(self, i, j, 3, true)
    local speedAnimation = 10
    self:addState('destructionAnimation', 1, 4, { tickStep = speedAnimation, loop = false, frames = { 50, 51, 52, 53 } })

    self:playAnimation()
    self:setGroups({ collisionGroup.explosion })

    self.states.destructionAnimation.onAnimationEndEvent = function(self)
        self:remove()
    end
end