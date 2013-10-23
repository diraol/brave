
module ('dungeon', package.seeall) do

  require 'base.scene'
  require 'base.vec2'
  require 'dungeon.tile'
  require 'dungeon.timecontroller'
  require 'dungeon.map'

  mapscene = scene:new{
    map = nil,
  }

  function mapscene:__init()
    self.timecontroller = timecontroller:new{map = map}
  end

  function mapscene:input_pressed(button)
    self.hero:input_pressed(button)  
  end

  function mapscene:update(dt)
  end

  function mapscene:draw(graphics)
    self.map:draw(graphics)
  end
end
