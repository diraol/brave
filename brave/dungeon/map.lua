
module ('dungeon', package.seeall) do

  require 'base.vec2'
  require 'dungeon.tile'
  require 'lux.object'

  map = lux.object.new {
    width = nil,
    height = nil,
  }

  function map:__init()
    assert(self.width)
    assert(self.height)

    self.matrix = {}
    for j = 1,self.height do
      self.matrix[j] = {}
      for i = 1,self.width do
        self.matrix[j][i] = tile:new{}
      end
    end

    self.visible_size = vec2:new{
      self.width * TILE_SIZE,
      self.height * TILE_SIZE,
    }
  end

  function map:get_tile(pos)
    return self.matrix[pos.y] and self.matrix[pos.y][pos.x]
  end

  function map:draw(graphics, state)
    for j = 1,self.height do
      for i = 1,self.width do
        if self.matrix[j][i] then
          self.matrix[j][i]:draw(graphics, i, j, state)
        end
      end
    end
  end
end
