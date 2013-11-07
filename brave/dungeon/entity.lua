
module ('dungeon', package.seeall) do

  require 'lux.object'
  require 'base.vec2'
  require 'dungeon.tile'

  entity = lux.object.new{
    scale = 1.0,
    hp = 50,
    maxhp = 50,
    image = nil
  }

  function entity:__init()
    self.position = self.position or vec2:new{1,1}
    self.hp = self.maxhp
  end

  function entity:update(dt)
  end

  function entity:playturn()
  end

  function entity:die()
    self.timecontroller:remove_entity(self)
  end

  function entity:take_damage(damage)
    self.hp = self.hp - damage
    if self.hp <= 0 then
      self:die()
    end
  end
  
  function entity:draw(graphics)
    if self.image and self.position then
      local draw_pos = self.position * TILE_SIZE
      draw_pos.x = draw_pos.x + (TILE_SIZE - self.image:getWidth() * self.scale) * 0.5
      draw_pos.y = draw_pos.y + TILE_SIZE - self.image:getHeight() * self.scale
      --calculando posição da barra de vida
      local draw_pos_lifebar = self.position * TILE_SIZE
      draw_pos_lifebar.x = draw_pos_lifebar.x
      draw_pos_lifebar.y = draw_pos.y - 12

      graphics.setColor(255, 255, 255)
      graphics.draw(self.image, draw_pos.x, draw_pos.y, 0, self.scale, self.scale)
      --Desenhando barra de vida
      graphics.setColor(0, 255, 0)
      graphics.rectangle("fill", draw_pos_lifebar.x, draw_pos_lifebar.y, TILE_SIZE * self.hp / 50, 8)
      graphics.setColor(255, 255, 255)
      graphics.rectangle("line", draw_pos_lifebar.x, draw_pos_lifebar.y, TILE_SIZE * self.maxhp / 50, 8)
    end
  end
end
