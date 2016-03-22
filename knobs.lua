local m = {}
local colors = require( 'colors' )

local knobs = {}

local function inside( self, x, y )
  return (x > (self.x - self.size))
    and (x < (self.x + self.size ))
    and (y > (self.y - self.size ))
    and (y < (self.y + self.size ))
end

local function draw( self )
  local gap = 0.3
  local angle = ((math.pi * 2) - ( 2 * gap)) * self.value + gap
  love.graphics.push()
  love.graphics.translate( self.x, self.y )
  love.graphics.rotate( math.pi / 2 )
  love.graphics.setColor( colors.black )
  love.graphics.arc( 'fill', 0, 0, self.size, gap, (math.pi * 2) - gap )
  love.graphics.setColor( colors.white )
  love.graphics.line( 0, 0,
                      math.cos( angle ) * self.size,
                      math.sin( angle ) * self.size )
  love.graphics.pop()
  love.graphics.printf( self.label,
                        self.x - self.size,
                        self.y + self.size,
                        self.size * 2, 'center' )
end

local function inc( self, amount )
  self.value = self.value + amount
  if self.value > 1 then self.value = 1
  elseif self.value < 0 then self.value = 0
  end
end

local function dec( self, amount )
  self:inc( -amount )
end

function m.list()
  return knobs
end

function m.get( name )
  return knobs[name]
end

function m.add( name, x, y, size, label )
  local protoKnob = {
    x = x, y = y,
    size = size,
    value = 0.5,
    active = false,
    label = label,
    draw = draw,
    inside = inside,
    inc = inc,
    dec = dec
  }
  knobs[name] = protoKnob
  return knobs[name]
end

return m