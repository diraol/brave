
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

    local lifebar_sprites = {
      background = love.graphics.newImage 'resources/hud/hud_topo_fundo_frente.png',

      life = {
        red    = love.graphics.newImage 'resources/hud/pt_vida_VERMELHA.png',
        yellow = love.graphics.newImage 'resources/hud/pt_vida_AMARELA.png',
        green  = love.graphics.newImage 'resources/hud/pt_vida_VERDE.png',
      },
    }

    local tileset = {
      ground = {
        simple = love.graphics.newImage 'resources/tiles/floor-wood-01.png',
      },
      wall = {
        simple = love.graphics.newImage 'resources/tiles/wall-brickwood-00-bottom.png',
        grid_offset = vec2:new{0, -48},
        grid = love.graphics.newImage 'resources/tiles/wall-brickwood-00-alltops.png',
      },
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
        map.matrix[j][i].set   = tileset[tile.name]

        -- Coloca a entidade na cena
        if data.type == 'entity' then
          local build = love.filesystem.load('dungeon/builder/' .. data.name .. '.lua')()
          local ent = build()
          ent.lifebar = lifebar_sprites
          dungeonscene.timecontroller:add_entity(ent, vec2:new{i, j})
        end
      end
    end

    dungeonscene.state.selection_image = love.graphics.newImage 'resources/cursor.png'
    dungeonscene.input_pressed = player_input_handler

    local hero = builder.hero()
    hero.lifebar = lifebar_sprites
    dungeonscene.state.hero = hero

    --[[
      right = 1
      left  = 2
      up    = 4
      down  = 8

      0 = all     = (0, 0)
      1 = no-R    = (1, 0)
      2 = no- L   = (3, 0)
      3 = no-RL   = (2, 0)
      4 = no-  U  = (0, 3)
      5 = no-R U  = (1, 3)
      6 = no- LU  = (3, 3)
      7 = no-RLU  = (2, 3)
      8 = no-   D = (0, 1)
      9 = no-R  D = (1, 1)
      10= no- L D = (3, 1)
      11= no-RL D = (2, 1)
      12= no-  UD = (0, 2)
      13= no-R UD = (1, 2)
      14= no- LUD = (3, 2)
      15= no-RLUD = (2, 2)
    ]]
    dungeonscene.state.tile_quads = {
      [ 0] = love.graphics.newQuad(0*48, 0*48, 48, 48, 48*4, 48*4),
      [ 1] = love.graphics.newQuad(1*48, 0*48, 48, 48, 48*4, 48*4),
      [ 2] = love.graphics.newQuad(3*48, 0*48, 48, 48, 48*4, 48*4),
      [ 3] = love.graphics.newQuad(2*48, 0*48, 48, 48, 48*4, 48*4),
      [ 4] = love.graphics.newQuad(0*48, 3*48, 48, 48, 48*4, 48*4),
      [ 5] = love.graphics.newQuad(1*48, 3*48, 48, 48, 48*4, 48*4),
      [ 6] = love.graphics.newQuad(3*48, 3*48, 48, 48, 48*4, 48*4),
      [ 7] = love.graphics.newQuad(2*48, 3*48, 48, 48, 48*4, 48*4),
      [ 8] = love.graphics.newQuad(0*48, 1*48, 48, 48, 48*4, 48*4),
      [ 9] = love.graphics.newQuad(1*48, 1*48, 48, 48, 48*4, 48*4),
      [10] = love.graphics.newQuad(3*48, 1*48, 48, 48, 48*4, 48*4),
      [11] = love.graphics.newQuad(2*48, 1*48, 48, 48, 48*4, 48*4),
      [12] = love.graphics.newQuad(0*48, 2*48, 48, 48, 48*4, 48*4),
      [13] = love.graphics.newQuad(1*48, 2*48, 48, 48, 48*4, 48*4),
      [14] = love.graphics.newQuad(3*48, 2*48, 48, 48, 48*4, 48*4),
      [15] = love.graphics.newQuad(2*48, 2*48, 48, 48, 48*4, 48*4),
    }

    dungeonscene.timecontroller:add_entity(hero, vec2:new{1, 1})

    message.send [[main]] {'change_scene', dungeonscene }
  end

end
