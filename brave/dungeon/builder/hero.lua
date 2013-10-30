
module ('dungeon.builder', package.seeall) do

  require 'dungeon.entity'

  function hero()
    local hero = dungeon.entity:new {
      image = love.graphics.newImage 'resources/entities/herov0.png',
    }
    hero.weapon = {
      range = 1,

      can_attack = function(self, pos)
        local dist = (pos - hero.position):norm1()
        return 1 <= dist and dist <= self.range
      end
    }
    function hero:playturn()
      local action, direction = coroutine.yield()

      if action == 'move' then
        local next_pos = self.position + direction
        local next_tile = self.map:get_tile(next_pos)
        if next_tile and next_tile:available() then
          self.map:get_tile(self.position):remove_entity()
          self.map:get_tile(next_pos):add_entity(self)
          self.position = next_pos
        end
      else
        error(action)
      end
    end
    return hero
  end

end
