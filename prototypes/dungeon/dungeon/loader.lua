
module ('dungeon', package.seeall) do

  require 'dungeon.tile'
  require 'dungeon.mapscene'
  require 'dungeon.entity'
  require 'dungeon.builder.hero'
  require 'dungeon.builder.slime'

  function enter()
    local map = mapscene:new{ width = 15, height = 8 }
    for j = 3,map.height do
      map.matrix[j][7].passable = false
    end

    local slime = builder.slime()
    slime.position = vec2:new{12, 7}

    map:add_entity(builder.hero())
    map:add_entity(slime)

    message.send [[main]] {'change_scene', map }
  end

end