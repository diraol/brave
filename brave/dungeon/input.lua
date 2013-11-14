
module ('dungeon', package.seeall) do

  local button_to_direction = {
    right = vec2:new{ 1, 0},
    left  = vec2:new{-1, 0},
    up    = vec2:new{ 0,-1},
    down  = vec2:new{ 0, 1},
  }

  function player_input_handler(self, button)
    if not self.timecontroller:accepting_input() then return end
    function run_action(...)
      self.timecontroller:send_input(...)
    end

    -- Pressing the 'attack' button
    if button == "a" then
      self.state.attacking = not self.state.attacking
      if not self.state.attacking then
        self.state.confirm_attack = nil
      end

    -- Logic for multiple buttons. Mostly arrow keys and enter.
    else
      local dir = button_to_direction[button]

      -- Confirming the attack direction.
      if self.state.confirm_attack then

        -- Same direction or enter
        if dir == self.state.confirm_attack or button == 'return' then
          run_action('attack', self.state.confirm_attack)
          self.state.confirm_attack = nil
          self.state.attacking = false

        -- Chose another valid direction
        elseif dir then
          self.state.confirm_attack = dir

        -- Cancel attack
        else
          self.state.confirm_attack = nil
          self.state.attacking = false
        end

      -- An arrow key.
      elseif dir then
        -- Attack menu up, means selecting a direction to attack.
        if self.state.attacking then
          self.state.confirm_attack = dir

        -- If no menu, means movement.
        else
          run_action('move', button_to_direction[button])

        end

      -- If unregistered button, cancel all menus.
      else
        self.state.attacking = nil
        self.state.confirm_attack = nil
      end
    end
  end
end
