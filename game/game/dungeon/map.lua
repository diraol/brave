
module ('dungeon.map', package.seeall) do

  require 'game.scene'

  function enter()
      message.send [[main]] {'change_scene', nil}
  end

end