module ('dungeon', package.seeall) do

  require 'base.message'
  require 'base.vec2'
  require 'dungeon.tile'
  require 'lux.object'

  weapon = lux.object.new{
    max_range = 1, --min distance the target has to be.
    min_range = 1, --max distance the target could be.
    damage = 10, -- damage of an attack.
    p_attack_ratio = 0.95, -- probability of a successfull attack.
    
    icon = nil,
  }
  full_weapons = {
    current = nil,
  }
end
