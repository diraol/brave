
module ('dungeon', package.seeall) do

  require 'dungeon.tile'
  require 'dungeon.mapscene'
  require 'dungeon.entity'

  function enter()
    local map = mapscene:new{ width = 15, height = 8 }
    for j = 3,map.height do
      map.matrix[j][7].passable = false
    end

    local hero = entity:new {
      image = love.graphics.newImage 'resources/avt1_fr1.gif',
    }
    function hero:input_pressed(button)
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
      if next_tile and next_tile.passable then
        self.position = next_pos
      end
    end

    map:add_entity(hero)

    message.send [[main]] {'change_scene', map }
  end

end