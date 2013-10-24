
module ('dungeon.builder', package.seeall) do

  require 'dungeon.entity'

  function hero()
    local hero = dungeon.entity:new {
      image = love.graphics.newImage 'resources/entities/herov0.png',
    }
    function hero:playturn()
      local button = coroutine.yield()
      local next_pos = self.position:clone()
      if button == 'right' then
        next_pos.x = next_pos.x + 1
      elseif button == 'left' then
        next_pos.x = next_pos.x - 1
      elseif button == 'up' then
        next_pos.y = next_pos.y - 1
      elseif button == 'down' then
        next_pos.y = next_pos.y + 1
      end
      local next_tile = self.map:get_tile(next_pos)
      if next_tile and next_tile:available() then
        self.map:get_tile(self.position):remove_entity()
        self.map:get_tile(next_pos):add_entity(self)
        self.position = next_pos
      end
      
    end
    return hero
  end

end
