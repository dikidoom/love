local m = {}

----------------------------------------------------------------
-- data

-- images
m.imgFiles = { }
m.img = {}

-- sounds
m.sndFiles = { save = "sfx/save.wav" }
m.snd = {}

----------------------------------------------------------------
-- function
function load( from, to, fn )
  for k,v in pairs( from ) do
    to[k] = fn( v )
  end
end

function loadImages( from, to )
  load( from, to, love.graphics.newImage )
end

function loadSounds( from, to )
  load( from, to, love.audio.newSource )
end

function m.load()
  loadImages( m.imgFiles, m.img )
  loadSounds( m.sndFiles, m.snd )
end

return m
