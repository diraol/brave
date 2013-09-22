
module ('dungeon.map', package.seeall) do

  require 'base.scene'
  require 'base.vec2'

  local mapscene = scene:new{}

  function mapscene:__init()
    self.hero = love.graphics.newImage 'resources/avt1_fr1.gif'
    self.hero_pos = vec2:new{1, 1}
  end

  function mapscene:input_pressed(button)
    if button == 'right' then
      self.hero_pos.x = self.hero_pos.x + 1
    elseif button == 'left' then
      self.hero_pos.x = self.hero_pos.x - 1
    elseif button == 'up' then
      self.hero_pos.y = self.hero_pos.y - 1
    elseif button == 'down' then
      self.hero_pos.y = self.hero_pos.y + 1
    end
  end

  function mapscene:draw(graphics)
    for j = 1,5 do
      for i = 1,10 do
        graphics.rectangle('fill', i*33, j * 33, 32, 32)
        graphics.draw(self.hero, (self.hero_pos * 33):get())
      end
    end
  end

  function enter()
    message.send [[main]] {'change_scene', mapscene:new{} }
  end

end