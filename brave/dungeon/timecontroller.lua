
module ('dungeon', package.seeall) do

  require 'base.utils'
  require 'lux.object'

  timecontroller = lux.object.new{
    map = nil,
    delay = 0.0,
    waiting_delay = false,
  }

  function timecontroller:__init()
    self.timeline = {}
    self.routine = coroutine.create(timecontroller.run)
  end

  function timecontroller:add_entity(entity, pos)
    if not self.map:get_tile(pos):add_entity(entity) then
      print "Espaço indisponível"
      return
    end
    entity.timecontroller = self
    entity.position = pos
    entity.map = self.map
    table.insert(self.timeline, entity)
  end

  function timecontroller:remove_entity(entity)
    assert(entity.timecontroller == self, "Entity belongs to another Timecontroller")
    assert(self.map:get_tile(entity.position), "Entity has invalid position")
    assert(self.map:get_tile(entity.position).entity == entity, "Entity position points to another tile")

    self.map:get_tile(entity.position):remove_entity()
    entity.timecontroller = nil

    arrayremoveelement(self.timeline, entity)
  end

  function timecontroller:start()
    assert(coroutine.resume(self.routine,self))
  end

  function timecontroller:continue(dt)
    if self.waiting_delay then
      self.delay = self.delay - dt
      if self.delay <= 0 then
        assert(coroutine.resume(self.routine,self))
      end
    end
  end

  function timecontroller:accepting_input()
    return not self.waiting_delay
  end

  function timecontroller:send_input(...)
    assert(coroutine.resume(self.routine, ...))
  end

  function timecontroller:run()
    while true do
      self.waiting_delay = false

      local entity = self.timeline[1]
      table.remove(self.timeline, 1)

      self.delay = entity:playturn()
      if entity.timecontroller == self then
        table.insert(self.timeline,entity)
      end

      if self.delay > 0.0 then 
        self.waiting_delay = true
        coroutine.yield()
        self.waiting_delay = false
      end
    end
  end

end

