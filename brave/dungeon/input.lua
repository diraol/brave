
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
        self.state.attack_location = nil
      else
        self.state.attack_location = self.state.hero.position:clone()
      end

    elseif #button == 1 and ('1' <= button and button <= '7') then
      local weapon_slot = tonumber(button)
      if weapon_slot and self.state.hero.weapons[weapon_slot] then
        self.state.hero.weapons.current = self.state.hero.weapons[weapon_slot]
      end

    elseif button == 'tab' then

    -- Logic for multiple buttons. Mostly arrow keys and enter.
    else
      local dir = button_to_direction[button]

      -- Confirm attack
      if button == 'return' and self.state.attacking then
        run_action('attack', self.state.attack_location)

        self.state.attack_location = nil
        self.state.attacking = false

      -- Cancel attack
      elseif not dir then
        self.state.attack_location = nil
        self.state.attacking = false

      -- If no menu, means movement.
      elseif not self.state.attacking then
        run_action('move', dir)

      else
        self.state.attack_location = self.state.attack_location + dir
      end
    end
  end
end
