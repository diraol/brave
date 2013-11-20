
module ('dungeon.builder', package.seeall) do

  require 'dungeon.entity'
  require 'dungeon.weapon'

  function hero()
    local hero = dungeon.entity:new {
      image = love.graphics.newImage 'resources/entities/herov0.png',
      p_act = 1, -- probability of  attack.
      can_attack = function(self, pos)
        local dist = (pos - self.position):norm1()
        return 1 <= dist and dist <= self.weapons.current.max_range and self.weapons.current.min_range <= dist
      end
    }
    hero.weapons = {
      current = nil,
    --list of available weapons
    --and current weapon
    }
    hero.weapons.punch = dungeon.weapon:new {
      max_range = 1, --min distance the target has to be.
      min_range = 1, --max distance the target could be.
      damage = 10, -- damage of an attack.
      p_attack_ratio = 0.95, --success attack probability
    }
    hero.weapons.current = hero.weapons.punch
    function hero:playturn()
      local action, direction = coroutine.yield()

      if action == 'move' then
        local next_pos = self.position + direction
        local next_tile = self.map:get_tile(next_pos)
        if next_tile and next_tile:available() then
          self.map:get_tile(self.position):remove_entity()
          self.map:get_tile(next_pos):add_entity(self)
          self.position = next_pos
          return 0.1
        end

      elseif action == 'attack' then
        local target_pos = self.position + direction
        local target_tile = self.map:get_tile(target_pos)
        if target_tile and target_tile.entity then
          target_tile.entity:take_damage(self.weapons.current.damage)
          return 0.1
        end

      else
        error(action)

      end
    end
    return hero
  end

end
