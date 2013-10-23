
module ('dungeon.builder', package.seeall) do

  require 'dungeon.entity'

  function slime(args)
    local slime = dungeon.entity:new {
      image = love.graphics.newImage 'resources/green_slime.png',
    }
    return slime
  end

end