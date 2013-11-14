require 'dungeon.entity'
require 'base.message'
require 'base.vec2'
require 'dungeon.builder.util'

return function(args)
  
  local pandarila = dungeon.entity:new {
    image = love.graphics.newImage 'resources/entities/pandarila.png',
    scale = 1.2,
    p_attack_ratio = 0.9, --attack probability
    p_attack_distance = 2, -- distance pandarila can attack
    damage = 5,
    p_act = .2,
  }
  pandarila.playturn = enemy_dumb_turn

  --pandarila.weapon

  return pandarila
end
