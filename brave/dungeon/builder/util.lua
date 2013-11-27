require 'base.message'
require 'base.vec2'

local button_to_direction = {
  right = vec2:new{ 1, 0},
  left  = vec2:new{-1, 0},
  up    = vec2:new{ 0,-1},
  down  = vec2:new{ 0, 1},
}

function random_side()  
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

function pursuit_on_damage(self)
  self.pursing_hero = true
end

local function get_heropos()
  local local_scene = message.send [[main]] {'current_scene'}
  return local_scene.state.hero.position
end

function hero_distance(pos, min_range, max_range)
  local hero_pos = get_heropos()
  return hero_pos:distance(pos) <= max_range and hero_pos:distance(pos) >= min_range
end

function enemy_dumb_turn(self)
  if math.random() < self.p_act then return end

  local wtd = math.random() -- What to do?

  if wtd < self.weapons.current.p_attack_ratio * self:calculate_p_attack_multiplier() then
    -- when the enemy has been hit it get's more difficult to him to attack
    -- try to attack
    if hero_distance(self.position, self.weapons.current.min_range, self.weapons.current.max_range) then
      -- hero on attack range
      local hero_pos = get_heropos()
      local target_tile = self.map:get_tile(hero_pos)
      if target_tile.entity then
        target_tile.entity:take_damage(self.weapons.current.damage)
        return 0.1
      end
    end
  end

  local next_pos
  if self.pursing_hero then
    local hero_pos = get_heropos()
    local best_dir, best_dist = nil, hero_pos:distance(self.position)

    for _, dir in pairs(button_to_direction) do
      local t = self.position + dir
      local tile = self.map:get_tile(t)
      if tile and tile:available() then
        -- if can move to this tile, check distance
        local dist = hero_pos:distance(t)
        if dist < best_dist then
          best_dir = dir
          best_dist = dist
        end
      end
    end

    if best_dir then
      next_pos = self.position + best_dir
    end

  else
    next_pos = self.position + random_side()

  end

  if next_pos then
    local next_tile = self.map:get_tile(next_pos)
    if next_tile and next_tile:available() then
      self.map:get_tile(self.position):remove_entity()
      self.map:get_tile(next_pos):add_entity(self)
      self.position = next_pos
      return 0.1
    end
  end
end
