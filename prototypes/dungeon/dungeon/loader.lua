
module ('dungeon', package.seeall) do

  require 'dungeon.tile'
  require 'dungeon.mapscene'

  function enter()
    local map = mapscene:new{ width = 15, height = 8 }
    for j = 3,map.height do
      map.matrix[j][7].passable = false
    end

    message.send [[main]] {'change_scene', map }
  end

end