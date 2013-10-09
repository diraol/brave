
module ('dungeon', package.seeall) do

  require 'lux.object'

  TILE_SIZE = 48

  tile = lux.object.new{
  }

  function tile:__init()
    self.passable = self.passable or true
  end

  function tile:draw(graphics, x, y)
    if self.passable then
      graphics.setColor(255, 255, 255)
    else
      graphics.setColor(127, 127, 127)
    end
    graphics.rectangle('fill', x * TILE_SIZE, y * TILE_SIZE, TILE_SIZE, TILE_SIZE)
  end
end