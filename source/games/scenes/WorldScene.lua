WorldScene = {}
class("WorldScene").extends(NobleScene)

WorldScene.baseColor = Graphics.kColorWhite

function WorldScene:enter()
    WorldScene.super.init(self)

    self.background = NobleSprite("images/background")

    self.background:add()
    self.background:moveTo(200, 120)
end