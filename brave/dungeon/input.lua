
module ('dungeon', package.seeall) do

  local button_to_direction = {
    right = vec2:new{ 1, 0},
    left  = vec2:new{-1, 0},
    up    = vec2:new{ 0,-1},
    down  = vec2:new{ 0, 1},
  }

  function player_input_handler(self, button)
    function run_action(...)
      assert(coroutine.resume(self.timecontroller.routine, ...))
    end

    -- Pressing the 'attack' button
    if button == "a" then
      self.inputstate.attacking = not self.inputstate.attacking
      if not self.inputstate.attacking then
        self.inputstate.confirm_attack = nil
      end

    -- Logic for multiple buttons. Mostly arrow keys and enter.
    else
      local dir = button_to_direction[button]

      -- Confirming the attack direction.
      if self.inputstate.confirm_attack then

        -- Same direction or enter
        if dir == self.inputstate.confirm_attack or button == 'return' then
          run_action('attack', self.inputstate.confirm_attack)
          self.inputstate.confirm_attack = nil
          self.inputstate.attacking = false

        -- Chose another valid direction
        elseif dir then
          self.inputstate.confirm_attack = dir

        -- Cancel attack
        else
          self.inputstate.confirm_attack = nil
          self.inputstate.attacking = false
        end

      -- An arrow key.
      elseif dir then
        -- Attack menu up, means selecting a direction to attack.
        if self.inputstate.attacking then
          self.inputstate.confirm_attack = dir

        -- If no menu, means movement.
        else
          run_action('move', button_to_direction[button])

        end

      -- If unregistered button, cancel all menus.
      else
        self.inputstate.attacking = nil
        self.inputstate.confirm_attack = nil
      end
    end
  end
end
