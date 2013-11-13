require 'dungeon.entity'
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

function hero_distance(pos, range)
  local local_scene = message.send [[main]] {'current_scene'}
  hero_pos = local_scene.inputstate.hero.position
  return math.abs((hero_pos - pos):norm1()) <= range
end

return function(args)
  
  local falcoelho = dungeon.entity:new {
    image = love.graphics.newImage 'resources/entities/falcoelho.png',
    scale = 0.5,
    p_attack_ratio = 0.9, --attack probability
    p_attack_distance = 1, -- distance falcoelho can attack
    damage = 5,
    p_act = .2,
  }

  function falcoelho:playturn()
    if math.random() < self.p_act then return end

    local wtd = math.random() -- What to do?

    if wtd < self.p_attack_ratio then
      if hero_distance(self.position, self.p_attack_distance) then
        local local_scene = message.send [[main]] {'current_scene'}
        hero_pos = local_scene.inputstate.hero.position
        local target_tile = self.map:get_tile(hero_pos)
        if target_tile.entity then
          target_tile.entity:take_damage(self.damage)
        else
          return
        end
      else
        return
      end
    else
      --do move to somewhere!
      local next_pos = self.position:clone()
      next_post = next_pos + random_side()

      local next_tile = self.map:get_tile(next_pos)
      if next_tile and next_tile:available() then
        self.map:get_tile(self.position):remove_entity()
        self.map:get_tile(next_pos):add_entity(self)
        self.position = next_pos
      end
    end
    
  end

  return falcoelho
end
