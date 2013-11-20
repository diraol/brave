
module ('sound', package.seeall) do

  local music
  local sounds = {}

  function sound.load (audio)
    sounds.menu_error    = audio.newSource('resources/sfx/negative_2.ogg', 'static')
  end

  function sound.effect (id, pos)
    local effect = sounds[id]
    if not effect then return end
    effect:stop()
    effect:play()
  end

  function sound.set_bgm(path)
    if music then music:stop() end
    music = love.audio.newSource(path, 'stream')
    music:setLooping(true)
    if music then music:play() end
  end

end