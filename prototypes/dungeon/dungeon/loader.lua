
module ('dungeon', package.seeall) do

  require 'dungeon.tile'
  require 'dungeon.map'
  require 'dungeon.mapscene'
  require 'dungeon.entity'
  require 'dungeon.builder.hero'
  require 'dungeon.builder.slime'

  function enter()
    local map = map:new { width = 15, height = 8 }
    for j = 3,map.height do
      map.matrix[j][7].passable = false
    end

    local dungeonscene = mapscene:new { map = map }

    local slime = builder.slime()

    local hero = builder.hero()

    dungeonscene.timecontroller:add_entity(hero,vec2:new{1,1})
    dungeonscene.timecontroller:add_entity(slime,vec2:new{12,7})

    function dungeonscene:input_pressed(button)
      local ok, err = coroutine.resume(self.timecontroller.routine,button)
      if not ok then error(err) end
    end

    message.send [[main]] {'change_scene', dungeonscene }
  end

end
