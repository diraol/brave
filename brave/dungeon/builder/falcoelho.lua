
module ('dungeon.builder', package.seeall) do

  require 'dungeon.entity'

  function falcoelho(args)
    local falcoelho = dungeon.entity:new {
      image = love.graphics.newImage 'resources/entities/falcoelho.png',
    }
    return falcoelho
  end

end