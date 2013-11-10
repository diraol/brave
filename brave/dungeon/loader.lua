
module ('dungeon', package.seeall) do

  require 'dungeon.tile'
  require 'dungeon.map'
  require 'dungeon.mapscene'
  require 'dungeon.entity'
  require 'dungeon.builder.hero'
  require 'dungeon.builder.falcoelho'

  function load_level_file(filename)
    local content = love.filesystem.read("dungeon/levels/" .. filename .. ".txt"):gsub("\r", "")
    local has_extra = (content:sub(#content) == '\n')
    local width, height = content:find("\n", 1, true) - 1, nil

    content, height = content:gsub("\n", "")
    if not has_extra then height = height + 1 end

    return content, width, height
    -- body
  end

  function enter()
    local level_name = "1"

    local types = (love.filesystem.load "dungeon/levels/tiles.lua")()
    assert(types['.'], "Missing tile type '.'")

    local content, width, height = load_level_file(level_name)
    assert(#content == (height * width), "Content size (" .. #content .. ") isn't " .. width .. " x " .. height)

    local tileset = {
      ground    = love.graphics.newImage 'resources/tiles/floor-wood-01.png',
      wall      = love.graphics.newImage 'resources/tiles/wall-brickwood-00.png',
      --wall_head = love.graphics.newImage 'resources/tiles/wall-brickwood-01.png',
    }

    local map = map:new { width = width, height = height }
    local dungeonscene = mapscene:new{ map = map }

    for j = 1,map.height do
      for i = 1,map.width do
        local start = (j - 1) * width + i
        local data = types[content:sub(start, start)]
        assert(data, "Unknown tile type: '" .. content:sub(start, start) .. "'")

        -- Use um chão padrão para todo os objetos/entidades
        local tile = (data.type == 'tile') and data or types['.']
        map.matrix[j][i].passable = not tile.blocks
        map.matrix[j][i].image = tileset[tile.name]

        -- Coloca a entidade na cena
        if data.type == 'entity' then
          local build = love.filesystem.load('dungeon/builder/' .. data.name .. '.lua')()
          dungeonscene.timecontroller:add_entity(build(), vec2:new{i, j})
        end
      end
    end

    dungeonscene.inputstate.selection_image = love.graphics.newImage 'resources/cursor.png'
    local button_to_direction = {
      right = vec2:new{ 1, 0},
      left  = vec2:new{-1, 0},
      up    = vec2:new{ 0,-1},
      down  = vec2:new{ 0, 1},
    }
    function dungeonscene:input_pressed(button)

      function run_action(...)
        assert(coroutine.resume(self.timecontroller.routine, ...))
      end

      -- Pressing the 'attack' button
      if button == "a" then
        self.inputstate.attacking = not self.inputstate.attacking
        if not self.inputstate.attacking then
          self.inputstate.confirm_attack = nil
        end

      -- Logic for multiple buttons. Mostly arrow keys and enter.
      else
        local dir = button_to_direction[button]

        -- Confirming the attack direction.
        if self.inputstate.confirm_attack then

          -- Same direction or enter
          if dir == self.inputstate.confirm_attack or button == 'return' then
            run_action('attack', self.inputstate.confirm_attack)
            self.inputstate.confirm_attack = nil
            self.inputstate.attacking = false

          -- Chose another valid direction
          elseif dir then
            self.inputstate.confirm_attack = dir

          -- Cancel attack
          else
            self.inputstate.confirm_attack = nil
            self.inputstate.attacking = false
          end

        -- An arrow key.
        elseif dir then
          -- Attack menu up, means selecting a direction to attack.
          if self.inputstate.attacking then
            self.inputstate.confirm_attack = dir

          -- If no menu, means movement.
          else
            run_action('move', button_to_direction[button])

          end

        -- If unregistered button, cancel all menus.
        else
          self.inputstate.attacking = nil
          self.inputstate.confirm_attack = nil
        end
      end
    end

    local hero = builder.hero()
    dungeonscene.inputstate.hero = hero
    dungeonscene.timecontroller:add_entity(hero, vec2:new{1, 1})

    message.send [[main]] {'change_scene', dungeonscene }
  end

end
