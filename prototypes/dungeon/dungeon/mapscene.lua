
module ('dungeon', package.seeall) do

  require 'base.scene'
  require 'base.vec2'
  require 'dungeon.tile'

  mapscene = scene:new{
    width = nil,
    height = nil,
  }

  function mapscene:__init()
    assert(self.width)
    assert(self.height)

    self.timeline = {}

    self.matrix = {}
    for j = 1,self.height do
      self.matrix[j] = {}
      for i = 1,self.width do
        self.matrix[j][i] = tile:new{}
      end
    end
    for j = 3,self.height do
      self.matrix[j][7].passable = false
    end
  end

  function mapscene:add_entity(entity, pos)
    if not self:get_tile(pos):add_entity(entity) then
      print "Espaço indisponível"
      return
    end
    entity.map = self
    entity.position = pos
    table.insert(self.timeline, entity)
  end

  function mapscene:get_tile(pos)
    return self.matrix[pos.y] and self.matrix[pos.y][pos.x]
  end

  function mapscene:input_pressed(button)
    self.hero:input_pressed(button)  
  end

  function mapscene:update(dt)
  end

  function mapscene:draw(graphics)
    for j = 1,self.height do
      for i = 1,self.width do
        if self.matrix[j][i] then
          self.matrix[j][i]:draw(graphics, i, j)
        end
      end
    end
  end
end
