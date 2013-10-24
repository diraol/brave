
module ('dungeon', package.seeall) do

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
    entity.position = pos
    entity.map = self.map
    table.insert(self.timeline, entity)
  end

  function timecontroller:start()
      local ok, err = coroutine.resume(self.routine,self)
      if not ok then error(err) end
  end

  function timecontroller:run()
      while true do
        local entity = self.timeline[1]
        table.remove(self.timeline,1)
        entity:playturn()
        table.insert(self.timeline,entity)
    end
  end

end

