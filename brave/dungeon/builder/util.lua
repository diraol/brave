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
  hero_pos = local_scene.state.hero.position
  return hero_pos:distance(pos) <= range
end
