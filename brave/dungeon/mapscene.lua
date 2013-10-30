
module ('dungeon', package.seeall) do

  require 'base.scene'
  require 'base.vec2'
  require 'dungeon.tile'
  require 'dungeon.timecontroller'
  require 'dungeon.map'

  mapscene = scene:new{
    map = nil,
  }

  BORDER = 30

  function mapscene:__init()
    self.timecontroller = timecontroller:new{map = self.map}
    self.inputstate = {}
    self.camerapos = vec2:new{0, 0}
  end

  function mapscene:focus()
    self.timecontroller:start()
  end

  function mapscene:update(dt)
    if self.inputstate.hero then
      self.camerapos.x = (self.inputstate.hero.position.x - 1) / (self.map.width - 1)
      self.camerapos.y = (self.inputstate.hero.position.y - 1) / (self.map.height - 1)
    end
  end

  function mapscene:draw(graphics)
    graphics.scale(2.0, 2.0)
    graphics.translate(-TILE_SIZE + BORDER, -TILE_SIZE + BORDER)
    graphics.translate(-self.camerapos.x * ((self.map.visible_size.x + BORDER * 2) - graphics:get_screensize().x / 2),
                       -self.camerapos.y * ((self.map.visible_size.y + BORDER * 2) - graphics:get_screensize().y / 2))
    self.map:draw(graphics, self.inputstate)
  end
end
