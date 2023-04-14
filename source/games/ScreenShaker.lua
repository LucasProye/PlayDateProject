class('ScreenShaker').extends(NobleSprite)

function ScreenShaker:init()
    ScreenShaker.super.init(self)
    self:add()
end

function ScreenShaker:start(duration, amplitude, easing)
    self.animator = playdate.graphics.animator.new(duration * 1000, amplitude * 2, 0, easing)
end

function ScreenShaker:update()
    if self.animator:ended() then
        self:remove()
        playdate.display.setOffset(0, 0)
        return
    end
    local factor = self.animator:currentValue()
    playdate.display.setOffset(math.random() * factor, math.random() * factor)
end