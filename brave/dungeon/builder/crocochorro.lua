require 'dungeon.entity'
require 'dungeon.weapon'
require 'base.message'
require 'base.vec2'
require 'dungeon.builder.util'

return function(args)
  
  local crocochorro = dungeon.entity:new {
    image = love.graphics.newImage 'resources/entities/crocochorro.png',
    scale = 0.8,
    p_act = 0.2,
  }
  crocochorro.weapons = {
    current = nil,
  --list of available weapons
  --and current weapon
  }
  crocochorro.weapons.punch = dungeon.weapon:new {
    max_range = 1, --min distance the target has to be.
    min_range = 1, --max distance the target could be.
    damage = 5, -- damage of an attack.
    p_attack_ratio = .2, -- probability of doing something.
  }
  crocochorro.weapons.current = crocochorro.weapons.punch
  crocochorro.on_take_damage = pursuit_on_damage
  function crocochorro:calculate_p_attack_multiplier()
    return math.max(0.5, self.hp / self.maxhp)
  end

  crocochorro.playturn = enemy_dumb_turn

  return crocochorro
end
