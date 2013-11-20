
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

      graphics.setColor(255, 255, 255)
      graphics.draw(self.image, draw_pos.x, draw_pos.y, 0, self.scale, self.scale)

      if self.lifebar then
        --calculando posição da barra de vida
        local draw_pos_lifebar = self.position * TILE_SIZE
        draw_pos_lifebar.x = (draw_pos_lifebar.x - 5) * 2
        draw_pos_lifebar.y = draw_pos.y * 2 - self.lifebar.background:getHeight() + 8

        graphics.push()
        graphics.scale(0.5, 0.5)

        graphics.draw(self.lifebar.background, draw_pos_lifebar.x, draw_pos_lifebar.y)

        local count_bar = math.ceil(7 * (self.hp / self.maxhp))
        for i=1,count_bar do
          if i < count_bar then
            graphics.setColor(0, 255, 0)
          else
            local diff = (count_bar - (7 * (self.hp / self.maxhp))) * 2

            -- diff = 0 ->   0, 255
            -- diff = 1 -> 255, 255
            -- diff = 2 -> 255,   0
            local red   = math.min(255, diff * 255)
            local green = math.min(255, 510 - diff * 255)
            graphics.setColor(red, green, 0)
          end
          graphics.draw(self.lifebar.bar_image, draw_pos_lifebar.x + 12 + i * 11, draw_pos_lifebar.y + 4)
        end

        graphics.pop()
      end
    end
  end
end
