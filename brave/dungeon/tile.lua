
module ('dungeon', package.seeall) do

  require 'lux.object'

  TILE_SIZE = 48

  tile = lux.object.new{
    entity = nil,
    bodies = nil,
  }

  function distance(v1, v2)
    return (v1 - v2):norm1()
  end

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
  
  function tile:draw(graphics, x, y, state)
    if self.passable then
      if state.attacking and state.hero.weapon:can_attack(vec2:new{x, y}) then
        graphics.setColor(230, 127, 127)
      else
        graphics.setColor(230, 230, 230)
      end
    else
      graphics.setColor(127, 127, 127)
    end
    if self.image then
      graphics.draw(self.image, x * TILE_SIZE, y * TILE_SIZE)
    else
      graphics.rectangle('fill', x * TILE_SIZE, y * TILE_SIZE, TILE_SIZE, TILE_SIZE)
    end
    if self.entity then
      self.entity:draw(graphics)
    end
    if state.selection_image and state.confirm_attack and
      distance(state.hero.position + state.confirm_attack, vec2:new{x, y}) == 0 then
        graphics.setColor(255, 0, 0)
        graphics.draw(state.selection_image, x * TILE_SIZE, y * TILE_SIZE)
    end
  end
end
