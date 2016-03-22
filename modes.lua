-- modes are chaining: if a callback returns FALSE, the chained modes' callback is invoked (recursively)

local m = {
  modes = {}, -- key-value storage for modes
  currentMode = nil,
  lastMode = nil 
}

function m.make( tbl )
  local mode = {
    name = '',
    chain = '',
    init = function() end,
    exit = function() end,
    draw = function() end,
    update = function( dt ) end,
    keypressed = function( key, isrepeat ) end,
    keyreleased = function( key ) end,
    mousepressed = function( x, y, button ) end,
    mousereleased = function( x, y, button ) end
  }
  for k, v in pairs( mode ) do
    if tbl[k] == nil then tbl[k] = mode[k] end
  end
  return tbl
end

function m.add( name, mode )
  m.modes[ name ] = mode
end

function m.switch( name )
  m.lastMode = m.currentMode
  m.currentMode = m.modes[ name ]
  if m.lastMode ~= nil then
    m.lastMode.exit()
  end
  if m.currentMode ~= nil then
    m.currentMode.init()
  end
end

--------------------------------------------------------------------------------
-- generalized functionality
local function invoke( who, what, ... )
  if (who ~= nil) and (who ~= false) then
    local r = who[what](...)
    if not r then
      invoke( m.modes[ who.chain ], what, ... )
    end
  end
end

m.invoke = invoke -- TODO FIXME this api is leaky. find a better solution.

--------------------------------------------------------------------------------
-- love bindings
function love.draw()
  invoke( m.currentMode, 'draw' )
end

function love.update( dt )
  invoke( m.currentMode, 'update', dt )
end

function love.mousepressed( x, y, button )
  invoke( m.currentMode, 'mousepressed', x, y, button )
end

function love.mousereleased( x, y, button )
  invoke( m.currentMode, 'mousereleased', x, y, button )
end

function love.keypressed( key, isrepeat )
  invoke( m.currentMode, 'keypressed', key, isrepeat )
end

function love.keyreleased( key )
  invoke( m.currentMode, 'keyreleased', key )
end

--------------------------------------------------------------------------------
return m