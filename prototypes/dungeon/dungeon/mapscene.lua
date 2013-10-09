
module ('dungeon', package.seeall) do

  require 'base.scene'
  require 'base.vec2'
  require 'dungeon.tile'

  mapscene = scene:new{}

  function mapscene:__init()
    self.hero = love.graphics.newImage 'resources/avt1_fr1.gif'
    self.hero_pos = vec2:new{1, 1}

    assert(self.width)
    assert(self.height)

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

  function mapscene:get_tile(pos)
    return self.matrix[pos.y] and self.matrix[pos.y][pos.x]
  end

  function mapscene:input_pressed(button)
    local next_pos = self.hero_pos:clone()
    if button == 'right' then
      next_pos.x = next_pos.x + 1
    elseif button == 'left' then
      next_pos.x = next_pos.x - 1
    elseif button == 'up' then
      next_pos.y = next_pos.y - 1
    elseif button == 'down' then
      next_pos.y = next_pos.y + 1
    end
    local next_tile = self:get_tile(next_pos)
    if next_tile and next_tile.passable then
      self.hero_pos = next_pos
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
    graphics.setColor(255, 255, 255)
    graphics.draw(self.hero, (self.hero_pos * TILE_SIZE):get())
  end
end