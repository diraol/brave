
module ('dungeon', package.seeall) do

  require 'base.scene'
  require 'base.vec2'
  require 'dungeon.tile'

  mapscene = scene:new{}

  function mapscene:__init()
    assert(self.width)
    assert(self.height)

    self.entities = {}
    self.pending_entities = {}

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

  function mapscene:add_entity(entity)
    entity.map = self
    table.insert(self.pending_entities, entity)
  end

  function mapscene:get_tile(pos)
    return self.matrix[pos.y] and self.matrix[pos.y][pos.x]
  end

  function mapscene:input_pressed(button)
    for _, entity in ipairs(self.entities) do
      if entity.input_pressed then
        entity:input_pressed(button)
      end
    end
  end

  function mapscene:update(dt)
    for _, pending in ipairs(self.pending_entities) do
      table.insert(self.entities, pending)
    end
    self.pending_entities = {}

    for _, entity in ipairs(self.entities) do
      entity:update(dt)
    end
  end

  function mapscene:draw(graphics)
    for j = 1,self.height do
      for i = 1,self.width do
        if self.matrix[j][i] then
          self.matrix[j][i]:draw(graphics, i, j)
        end
      end
    end
    for _, entity in ipairs(self.entities) do
      entity:draw(graphics)
    end
  end
end