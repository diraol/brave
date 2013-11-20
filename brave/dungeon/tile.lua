
module ('dungeon', package.seeall) do

  require 'lux.object'

  TILE_SIZE = 48

  tile = lux.object.new{
    set = nil,
    entity = nil,
    bodies = nil,
  }

  function tile:__init()
    self.bodies = self.bodies or {}
    self.passable = self.passable or true
  end

  function tile:available()
      return not self.entity and self.passable
  end

  function tile:add_entity(entity)
    if self:available() then
      self.entity = entity
      return true
    else
      return false
    end
  end

  function tile:remove_entity()
    self.entity = nil
  end
  
  function tile:draw(graphics, x, y, scene)
    local state = scene.state
    if self.set then
      graphics.setColor(255, 255, 255)
      if self.set.grid then
        local right = scene.map:get_tile(x + 1, y)
        local left  = scene.map:get_tile(x - 1, y)
        local up    = scene.map:get_tile(x, y - 1)
        local down  = scene.map:get_tile(x, y + 1)

        local has_right = right and right.set == self.set and 1 or 0
        local has_left  = left  and left.set  == self.set and 2 or 0
        local has_up    = up    and up.set    == self.set and 4 or 0
        local has_down  = down  and down.set   == self.set and 8 or 0

        local sum = has_right + has_left + has_up + has_down

        local draw_x, draw_y = x * TILE_SIZE, y * TILE_SIZE
        if self.set.grid_offset then
          draw_x, draw_y = draw_x + self.set.grid_offset.x, draw_y + self.set.grid_offset.y
        end
        graphics.drawq(self.set.grid, state.tile_quads[sum], draw_x, draw_y)
      end
      if self.set.simple then
        graphics.draw(self.set.simple, x * TILE_SIZE, y * TILE_SIZE)
      end
    end
    if state:is_highlighted(vec2:new{x, y}) then
      graphics.setColor(230, 0, 0, 127)
      graphics.rectangle('fill', x * TILE_SIZE, y * TILE_SIZE, TILE_SIZE, TILE_SIZE)
    end
    if self.entity then
      graphics.setColor(255, 255, 255)
      self.entity:draw(graphics)
    end    
  end
end
