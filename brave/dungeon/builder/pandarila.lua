require 'dungeon.entity'
require 'dungeon.weapon'
require 'base.message'
require 'base.vec2'
require 'dungeon.builder.util'

return function(args)
  
  local pandarila = dungeon.entity:new {
    image = love.graphics.newImage 'resources/entities/pandarila.png',
    scale = 1.2,
    p_act = .3, -- probability acting.
  }
  pandarila.weapons = {
    current = nil,
  --list of available weapons
  --and current weapon
  }
  pandarila.weapons.punch = dungeon.weapon:new {
    max_range = 2, --min distance the target has to be.
    min_range = 1, --max distance the target could be.
    damage = 5, -- damage of an attack.
    p_attack_ratio = 0.9, --success attack probability
  }
  pandarila.weapons.current = pandarila.weapons.punch
  pandarila.on_take_damage = pursuit_on_damage
  function pandarila:calculate_p_attack_multiplier()
    return math.max(0.5, 1 - self.hp / self.maxhp)
  end

  pandarila.playturn = enemy_dumb_turn

  --pandarila.weapon

  return pandarila
end
