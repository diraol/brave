
module ('dungeon', package.seeall) do

  require 'lux.object'
  require 'base.vec2'
  require 'dungeon.tile'

  entity = lux.object.new{
    image = nil
  }

  function entity:__init()
    self.position = self.position or vec2:new{1,1}
  end

  function entity:update(dt)
  end

  function entity:draw(graphics)
    if self.image then
      graphics.setColor(255, 255, 255)
      graphics.draw(self.image, (self.position * TILE_SIZE):get())
    end
  end
end