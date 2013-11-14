require 'dungeon.entity'
require 'base.message'
require 'base.vec2'
require 'dungeon.builder.util'

return function(args)
  
  local crocochorro = dungeon.entity:new {
    image = love.graphics.newImage 'resources/entities/crocochorro.png',
    scale = 0.8,
    p_attack_ratio = 0.9, --attack probability
    p_attack_distance = 1, -- distance crocochorro can attack
    damage = 5,
    p_act = .2,
  }
  crocochorro.playturn = enemy_dumb_turn

  return crocochorro
end
