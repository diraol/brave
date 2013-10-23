
module ('dungeon', package.seeall) do

  require 'lux.object'

  TILE_SIZE = 48

  tile = lux.object.new{
    entity = nil,
    bodies = nil,
  }

  function tile:__init()
    self.bodies = self.bodies or {}
    self.passable = self.passable or true
  end

  function tile:add_entity(entity)
    if self.entity then
      return false
    else
      self.entity = entity
      return true
    end
  end

  function tile:remove_entity()
    self.entity = nil
  end
  
  function tile:draw(graphics, x, y)
    if self.passable then
      graphics.setColor(230, 230, 230)
    else
      graphics.setColor(127, 127, 127)
    end
    graphics.rectangle('fill', x * TILE_SIZE, y * TILE_SIZE, TILE_SIZE, TILE_SIZE)
    if self.entity then
      self.entity:draw(graphics)
    end
  end
end
