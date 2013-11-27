
module ('dungeon.builder', package.seeall) do

  require 'dungeon.body'

  return function()
    local potion = dungeon.body:new {
      image = love.graphics.newImage 'resources/hud/life_potion2.png',
      heal_ammount = 30,
      scale = 0.5,
    }
    function potion:interact(other)
      other.hp = math.min(other.hp + self.heal_ammount, other.maxhp)
      self.tile:remove_body(self)
    end
    return potion
  end

end
