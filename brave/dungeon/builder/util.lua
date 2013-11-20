require 'base.message'
require 'base.vec2'

function random_side()
  local button_to_direction = {
    right = vec2:new{ 1, 0},
    left  = vec2:new{-1, 0},
    up    = vec2:new{ 0,-1},
    down  = vec2:new{ 0, 1},
  }
  
  local r = math.random()
  if r < 0.25 then
    return button_to_direction.right
  elseif r < 0.5 then
    return button_to_direction.down
  elseif r < 0.75 then
    return button_to_direction.left
  else
    return button_to_direction.up
  end
end

function hero_distance(pos, min_range, max_range)
  local local_scene = message.send [[main]] {'current_scene'}
  hero_pos = local_scene.state.hero.position
  return hero_pos:distance(pos) <= max_range and hero_pos:distance(pos) >= min_range
end

function enemy_dumb_turn(self)
  if math.random() < self.p_act then return end

  local wtd = math.random() -- What to do?

  if wtd < self.weapons.current.p_attack_ratio * self.hp /self.maxhp then
    -- when the enemy has been hit it get's more difficult to him to attack
    -- try to attack
    if hero_distance(self.position, self.weapons.current.min_range, self.weapons.current.max_range) then
      -- hero on attack range
      local local_scene = message.send [[main]] {'current_scene'}
      hero_pos = local_scene.state.hero.position
      local target_tile = self.map:get_tile(hero_pos)
      if target_tile.entity then
        target_tile.entity:take_damage(self.weapons.current.damage)
        return 0.1
      else
        return
      end
    else
      return
    end
  else
    --do move to somewhere!
    local next_pos = self.position:clone() + random_side()
    local next_tile = self.map:get_tile(next_pos)
    if next_tile and next_tile:available() then
      self.map:get_tile(self.position):remove_entity()
      self.map:get_tile(next_pos):add_entity(self)
      self.position = next_pos
      return 0.1
    end
  end
end
