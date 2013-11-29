
module ('dungeon.builder', package.seeall) do

  require 'dungeon.entity'
  require 'dungeon.weapon'
  require 'base.sound'
  require 'dungeon.loader'

  return function()
    local hero = dungeon.entity:new {
      image = love.graphics.newImage 'resources/entities/herov0.png',
      p_act = 1, -- probability of  attack.
      can_attack = function(self, pos)
        local dist = pos:distance(self.position)
        return self.weapons.current.min_range <= dist and dist <= self.weapons.current.max_range
      end
    }
    hero.weapons = {
      current = nil,
    --list of available weapons
    --and current weapon
    }

    hero.weapons[1] = dungeon.weapon:new {
      max_range = 1, --min distance the target has to be.
      min_range = 1, --max distance the target could be.
      damage = 10, -- damage of an attack.
      p_attack_ratio = 0.95, --success attack probability

      name = 'rapier',
      icon = love.graphics.newImage 'resources/hud/rapier-00.png',
    }
    hero.weapons[2] = dungeon.weapon:new {
      max_range = 3, --min distance the target has to be.
      min_range = 2, --max distance the target could be.
      damage = 8, -- damage of an attack.
      p_attack_ratio = 0.95, --success attack probability

      name = 'bow',
      icon = love.graphics.newImage 'resources/hud/bow-00.png',
    }
    hero.weapons.current = hero.weapons[1]

    function hero:playturn()
      self.timecontroller.delay_multiplier = self.timecontroller.original_delay_multiplier
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
        local target_pos = direction
        if not self:can_attack(target_pos) then
          return
        end
        sound.effect 'player_attack'

        local target_tile = self.map:get_tile(target_pos)
        if target_tile and target_tile.entity then
          target_tile.entity:take_damage(self.weapons.current.damage)
          return 0.1
        end

      elseif action == 'interact' then
        local current_tile = self.map:get_tile(self.position)
        if #current_tile.bodies > 0 then
          current_tile.bodies[1]:interact(self)
        else
          if current_tile.tilename == 'stairs' then
            local next_level = tostring(tonumber(self.map.name) + 1)
            dungeon.change_level(self, dungeon.load_level(next_level))
          end
        end

      else
        error(action)

      end
    end
    return hero
  end

end
