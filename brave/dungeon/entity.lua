
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

  function entity:playturn()
  end
  
  function entity:draw(graphics)
    if self.image and self.position then
      local draw_pos = self.position * TILE_SIZE
      draw_pos.y = draw_pos.y + TILE_SIZE - self.image:getHeight()

      graphics.setColor(255, 255, 255)
      graphics.draw(self.image, draw_pos:get())
    end
  end
end
