require 'dungeon.entity'
require 'base.message'
require 'base.vec2'
require 'dungeon.builder.util'

return function(args)
  
  local falcoelho = dungeon.entity:new {
    image = love.graphics.newImage 'resources/entities/falcoelho.png',
    scale = 0.5,
    p_attack_ratio = 0.9, --attack probability
    p_attack_distance = 1, -- distance falcoelho can attack
    damage = 5,
    p_act = .2,
  }
  falcoelho.playturn = enemy_dumb_turn

  return falcoelho
end
