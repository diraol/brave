
module ('dungeon', package.seeall) do

  require 'dungeon.tile'
  require 'dungeon.map'
  require 'dungeon.mapscene'
  require 'dungeon.entity'
  require 'dungeon.builder.hero'
  require 'dungeon.builder.falcoelho'

  local button_to_direction = {
    right = vec2:new{ 1, 0},
    left  = vec2:new{-1, 0},
    up    = vec2:new{ 0,-1},
    down  = vec2:new{ 0, 1},
  }

  function enter()
    local map = map:new { width = 15, height = 8 }
    for j = 3,map.height do
      map.matrix[j][7].passable = false
    end

    local dungeonscene = mapscene:new { map = map }
    dungeonscene.inputstate.selection_image = love.graphics.newImage 'resources/cursor.png'
    function dungeonscene:input_pressed(button)
      function run_action(...)
        assert(coroutine.resume(self.timecontroller.routine, ...))
      end

      -- 1, 2, 3, ... seleciona arma

      if button == "a" then
        self.inputstate.attacking = not self.inputstate.attacking
        if not self.inputstate.attacking then
          self.inputstate.confirm_attack = nil
        end

      elseif button_to_direction[button] then

        if self.inputstate.confirm_attack then
          local dir = button_to_direction[button]
          if dir == self.inputstate.confirm_attack then
            run_action('attack', dir)
            self.inputstate.attacking = false
            self.inputstate.confirm_attack = nil

          elseif dir then -- Valid direction
            self.inputstate.confirm_attack = dir

          else
            -- Cancel attack
            self.inputstate.attacking = false
            self.inputstate.confirm_attack = nil
          end

        elseif self.inputstate.attacking then
          self.inputstate.confirm_attack = button_to_direction[button]

        else
          run_action('move', button_to_direction[button])
        end

      else
        self.inputstate.attacking = nil
        self.inputstate.confirm_attack = nil
      end

    end

    local hero = builder.hero()
    local monster = builder.falcoelho()

    dungeonscene.inputstate.hero = hero
    dungeonscene.timecontroller:add_entity(hero,   vec2:new{1, 1})
    dungeonscene.timecontroller:add_entity(monster,vec2:new{12,7})

    message.send [[main]] {'change_scene', dungeonscene }
  end

end
