require 'base.vec2'
require 'base.message'
require 'base.sound'
require 'ui.menubuilder'

local debug = false
local graphics
local current_scene
local scene_stack = {}
local main_message_handler = {}

function main_message_handler.change_scene(newscene, stack)
  if current_scene then
    current_scene:unfocus()
  end
  if stack then
    table.insert(scene_stack, current_scene)
  end
  newscene = newscene or table.remove(scene_stack)
  if newscene == nil then
    return love.event.push("quit")
  end
  current_scene = newscene
  current_scene:focus()
end

function main_message_handler.gotomenu()
  main_message_handler.change_scene(ui.mainmenu())
end

function main_message_handler.current_scene()
  return current_scene
end

function love.load()
  graphics = {}
  setmetatable(graphics, { __index = love.graphics })
  function graphics:get_screensize()
    return vec2:new{self.getWidth(), self.getHeight()}
  end
  graphics.setFont(graphics.newFont(12))

  -- Setup sound
  sound.load(love.audio)

  -- Setup message handler
  message.add_receiver('debug', function (...) return debug end)
  message.add_receiver('main', main_message_handler)

  -- Initial scene
  message.send [[main]] {'change_scene', ui.mainmenu()}
end

function love.update(dt)
  current_scene:update(dt < 0.1 and dt or 0.1)
end

function love.keypressed (button)
  current_scene:input_pressed(button)
end

function love.keyreleased (button)
  current_scene:input_released(button)
end

function love.mousepressed (x, y, button)
  current_scene:input_pressed(button, nil, vec2:new{ x, y })
end

function love.mousereleased (x, y, button)
  current_scene:input_released(button, nil, vec2:new{ x, y })
end

function love.draw ()
  current_scene:draw(graphics)
end
