
module ('dungeon', package.seeall) do

  require 'base.scene'
  require 'base.vec2'
  require 'dungeon.tile'
  require 'dungeon.timecontroller'
  require 'dungeon.map'

  mapscene = scene:new{
    map = nil,
  }

  BORDER_X_LEFT   = 30
  BORDER_X_RIGHT  = 30
  BORDER_Y_TOP    = 30
  BORDER_Y_BOTTOM = 50


  function mapscene:__init()
    self.timecontroller = timecontroller:new{map = self.map}
    self.state = {}
    function self.state:is_highlighted(pos)
      if not self.attacking then return false end
      return self.hero.weapon:can_attack(pos)
    end

    self.camerapos = vec2:new{0, 0}

    self.hud = {
      background = love.graphics.newImage 'resources/hud/hud_lateral_fundo.png',
      foreground = love.graphics.newImage 'resources/hud/hud_lateral_frente.png',

      boxes = {
        empty_off = love.graphics.newImage 'resources/hud/gaveta_item_apagada.png',
        empty_on  = love.graphics.newImage 'resources/hud/gaveta_item_acessa.png',
      },
    }
  end

  function mapscene:focus()
    self.timecontroller:start()
  end

  function mapscene:update(dt)
    if self.state.hero then
      self.camerapos.x = (self.state.hero.position.x - 1) / (self.map.width - 1)
      self.camerapos.y = (self.state.hero.position.y - 1) / (self.map.height - 1)
    end
    self.timecontroller:continue(dt)
  end

  function mapscene:draw(graphics)
    graphics.push()
    graphics.scale(2.0, 2.0)
    graphics.translate(-TILE_SIZE + BORDER_X_LEFT, -TILE_SIZE + BORDER_Y_TOP)
    graphics.translate(-self.camerapos.x * ((self.map.visible_size.x + BORDER_X_LEFT + BORDER_X_RIGHT) - graphics:get_screensize().x / 2),
                       -self.camerapos.y * ((self.map.visible_size.y + BORDER_Y_TOP  + BORDER_Y_BOTTOM) - graphics:get_screensize().y / 2))
    self.map:draw(graphics, self)


    if self.state.selection_image and self.state.confirm_attack then
      local selection_pos = self.state.hero.position + self.state.confirm_attack
      graphics.setColor(255, 0, 0)
      graphics.draw(self.state.selection_image, selection_pos.x * TILE_SIZE, selection_pos.y * TILE_SIZE)
    end

    graphics.pop()

    graphics.setColor(255, 255, 255)
    --graphics.draw(self.hud.background, graphics:get_screensize().x - self.hud.background:getWidth(), 0)
    local off_x = self.hud.boxes.empty_on:getWidth() + 20
    for i=1,7 do
      local img, off
      if i == self.hud.selected_action then
        img, off = self.hud.boxes.empty_on,  off_x
      else
        img, off = self.hud.boxes.empty_off, off_x - 30
      end
      graphics.draw(img, graphics:get_screensize().x - off, i*self.hud.boxes.empty_on:getHeight())
    end
    graphics.draw(self.hud.foreground, graphics:get_screensize().x - self.hud.background:getWidth(), 0)
  end
end
