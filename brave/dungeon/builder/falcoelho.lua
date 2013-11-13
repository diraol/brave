require 'dungeon.entity'
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

return function(args)
  
  local falcoelho = dungeon.entity:new {
    image = love.graphics.newImage 'resources/entities/falcoelho.png',
    scale = 0.5,
    p_attack = 0.3, --attack probability
  }

  function falcoelho:playturn()
    if math.random() < 0.75 then return end

    local wtd = math.random() -- What to do?

    if wtd < self.p_attack then
      --do attack!
      return      
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
