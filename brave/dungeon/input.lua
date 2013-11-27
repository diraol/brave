
module ('dungeon', package.seeall) do

  require 'base.sound'

  local button_to_direction = {
    right = vec2:new{ 1, 0},
    left  = vec2:new{-1, 0},
    up    = vec2:new{ 0,-1},
    down  = vec2:new{ 0, 1},
  }

  function player_input_handler(self, button)
    if not self.timecontroller:accepting_input() then
      self.timecontroller.delay_multiplier = 0.0
      return
    end
    function run_action(...)
      self.timecontroller:send_input(...)
    end

    local state = self.state
    local hero  = state.hero

    -- Pressing the 'attack' button
    if button == "a" then
      state.attacking = not state.attacking
      if state.attacking then

        if state.last_attack and state.last_attack.weapon == hero.weapons.current 
          and hero:can_attack(state.last_attack.location) then
          state.attack_location = state.last_attack.location
        else
          state.attack_location = hero.position:clone()
        end
      else
        state.attack_location = nil
      end

    elseif #button == 1 and ('1' <= button and button <= '7') then
      local weapon_slot = tonumber(button)
      if weapon_slot and hero.weapons[weapon_slot] then
        hero.weapons.current = hero.weapons[weapon_slot]
      end

    elseif button == 'tab' and state.attacking then
      -- search nearby target to auto-target

    elseif button == ' ' then
      run_action('interact')      

    -- Logic for multiple buttons. Mostly arrow keys and enter.
    else
      local dir = button_to_direction[button]

      -- Confirm attack
      if button == 'return' and state.attacking then
        if hero:can_attack(state.attack_location) then
          state.last_attack = { 
            weapon    = hero.weapons.current,
            location  = state.attack_location,
          }

          run_action('attack', state.attack_location)

          state.attack_location = nil
          state.attacking = false
        else
          sound.effect 'menu_error'
        end

      -- Cancel attack
      elseif not dir then
        state.attack_location = nil
        state.attacking = false

      -- If no menu, means movement.
      elseif not state.attacking then
        run_action('move', dir)

      else
        state.attack_location = state.attack_location + dir
      end
    end
  end
end
