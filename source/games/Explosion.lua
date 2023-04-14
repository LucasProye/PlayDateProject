class('Explosion').extends(TileObject)

function Explosion.new(i, j, explosionState)
    return Explosion(i, j, explosionState)
end

function Explosion:init(i, j, explosionState)
    Explosion.super.init(self, i, j, 4, true)

    local animationSpeed = 5

    self:addState('explosionLeft', 1, 5,
        { tickStep = animationSpeed, frames = { 15, 8, 1, 8, 15 }, loop = false })
    self:addState('explosionHorizontal', 1, 5,
        { tickStep = animationSpeed, frames = { 16, 9, 2, 9, 16 }, loop = false })
    self:addState('explosionMiddle', 1, 5,
        { tickStep = animationSpeed, frames = { 17, 10, 3, 10, 17 }, loop = false }).asDefault()
    self:addState('explosionRight', 1, 5,
        { tickStep = animationSpeed, frames = { 18, 11, 4, 11, 18 }, loop = false })
    self:addState('explosionUp', 1, 5,
        { tickStep = animationSpeed, frames = { 19, 12, 5, 12, 19 }, loop = false })
    self:addState('explosionVertical', 1, 5,
        { tickStep = animationSpeed, frames = { 20, 13, 6, 13, 20 }, loop = false })
    self:addState('explosionDown', 1, 5,
        { tickStep = animationSpeed, frames = { 21, 14, 7, 14, 21 }, loop = false })

    for _, state in pairs(self.states) do
        state.onAnimationEndEvent = function(self)
            self:remove()
        end
    end

    self:changeState(explosionState, true)
    self:playAnimation()
    self:setGroups({ collisionGroup.explosion })
    self:setCollidesWithGroups({ collisionGroup.bomb, collisionGroup.p1, collisionGroup.p2, collisionGroup.item,
        collisionGroup.block })

    local sound = playdate.sound.sampleplayer
    self.backgroundMusic = sound.new('sounds/Bomb Explodes.wav')
    self.backgroundMusic:setVolume(0.6)
    self.backgroundMusic:play(1, 1)
end