
module ('ui', package.seeall) do

  require 'ui.menuscene'
  require 'game.message'

  local themes = {
    default = theme:new {
      background_color = { 96, 96, 96 },
      border_color = { 160, 160, 160 },
      text_color = { 240, 240, 240 },
    },
    hover = theme:new {
      background_color = { 80, 80, 150 },
      border_color = { 160, 160, 255 },
      text_color = { 255, 255, 255 },
    },
    clicking = theme:new {
      background_color = { 40, 40, 98 },
      border_color = { 120, 120, 192 },
      text_color = { 255, 255, 255 },
    },
    selected = theme:new {
      background_color = { 96, 96, 110 },
      border_color = { 140, 140, 255 },
      text_color = { 240, 240, 240 },
    },
  }
  local function closemenu()
    message.send [[main]] {'change_scene', nil}
  end

  function mainmenu()
    return menuscene:new {
      xcenter = love.graphics.getWidth() / 2,
      ystart = 100,
      border = 20,
      buttons = {
        button:new{ text = "Quit", onclick = closemenu, themes = themes },
      }
    }
  end
end
