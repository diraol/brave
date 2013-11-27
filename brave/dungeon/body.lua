
module ('dungeon', package.seeall) do

  require 'lux.object'
  require 'base.vec2'

  body = lux.object.new{
    scale = 1.0,
    image = nil
  }

  function body:__init()
  end

  function body:draw(graphics, x, y)
    if self.image then
      local drawx = x * TILE_SIZE + (TILE_SIZE - self.image:getWidth() * self.scale) * 0.5
      local drawy = y * TILE_SIZE + TILE_SIZE - self.image:getHeight() * self.scale

      graphics.setColor(255, 255, 255)
      graphics.draw(self.image, drawx, drawy, 0, self.scale, self.scale)
    end
  end
end
