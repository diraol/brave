require 'dungeon.entity'
require 'dungeon.weapon'
require 'base.message'
require 'base.vec2'
require 'dungeon.builder.util'

return function(args)
  
  local falcoelho = dungeon.entity:new {
    image = love.graphics.newImage 'resources/entities/falcoelho.png',
    scale = 0.5,
    p_act = .3, -- probability of a successfull attack.
  }
  falcoelho.weapons = {
    current = nil,
  --list of available weapons
  --and current weapon
  }
  falcoelho.weapons.punch = dungeon.weapon:new {
    max_range = 1, --min distance the target has to be.
    min_range = 1, --max distance the target could be.
    damage = 5, -- damage of an attack.
    p_attack_ratio = 0.1,
  }
  falcoelho.weapons.current = falcoelho.weapons.punch
  function falcoelho:calculate_p_attack_multiplier()
    return self.hp / self.maxhp
  end

  falcoelho.playturn = enemy_dumb_turn

  return falcoelho
end
