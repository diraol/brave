
module ('dungeon', package.seeall) do

  require 'base.utils'
  require 'lux.object'

  timecontroller = lux.object.new{
    map = nil,
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

  function timecontroller:run()
    while true do
      local entity = self.timeline[1]
      table.remove(self.timeline,1)
      entity:playturn()
      if entity.timecontroller == self then
        table.insert(self.timeline,entity)
      end
    end
  end

end

