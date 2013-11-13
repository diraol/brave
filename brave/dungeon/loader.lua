
module ('dungeon', package.seeall) do

  require 'dungeon.tile'
  require 'dungeon.map'
  require 'dungeon.mapscene'
  require 'dungeon.entity'
  require 'dungeon.input'
  require 'dungeon.builder.hero'

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
        map.matrix[j][i].set   = tileset[tile.name]

        -- Coloca a entidade na cena
        if data.type == 'entity' then
          local build = love.filesystem.load('dungeon/builder/' .. data.name .. '.lua')()
          dungeonscene.timecontroller:add_entity(build(), vec2:new{i, j})
        end
      end
    end

    dungeonscene.state.selection_image = love.graphics.newImage 'resources/cursor.png'
    dungeonscene.input_pressed = player_input_handler

    local hero = builder.hero()
    dungeonscene.state.hero = hero
    dungeonscene.timecontroller:add_entity(hero, vec2:new{1, 1})

    message.send [[main]] {'change_scene', dungeonscene }
  end

end
