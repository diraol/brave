
module ('dungeon.builder', package.seeall) do

  require 'dungeon.entity'

  function falcoelho(args)
    local falcoelho = dungeon.entity:new {
      image = love.graphics.newImage 'resources/entities/falcoelho.png',
      scale = 0.5,
    }
    function falcoelho:playturn()
      if math.random() < 0.75 then return end

      local next_pos = self.position:clone()
      local r = math.random()
      if r < 0.25 then
        next_pos.x = next_pos.x + 1
      elseif r < 0.5 then
        next_pos.x = next_pos.x - 1
      elseif r < 0.75 then
        next_pos.y = next_pos.y - 1
      else
        next_pos.y = next_pos.y + 1
      end
      local next_tile = self.map:get_tile(next_pos)
      if next_tile and next_tile:available() then
        self.map:get_tile(self.position):remove_entity()
        self.map:get_tile(next_pos):add_entity(self)
        self.position = next_pos
      end
      
    end
    return falcoelho
  end

end