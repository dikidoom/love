local p = {}
local g = love.graphics
local f = love.filesystem
local console = require( "console" )

----------------------------------------------------------------
-- buttons
local function makeLabel( x, y, name )
  local l = {}
  l.draw = function()
    g.setColor( 192, 192, 192 )
    g.rectangle( "fill", x, y, 200, 19 )
    g.setColor( 0, 0, 0 )
    g.print( name, x+10, y+3 )
  end
  l.mouseInside = function( my ) return false end
  return l
end

local function makeButton( x, y, pO, name )
  local b = {}
  b.draw = function()
    g.setColor( 255, 255, 255 )
    g.rectangle( "fill", x, y, 200, 19 )
    g.setColor( 0, 0, 0 )
    g.print( name, x+10, y+3 )
    g.printf( pO[name], x, y+3, 190, "right" )
  end
  b.change = function( x )
    pO[name] = pO[name] + x
  end
  b.mouseInside = function( my ) return my >= y and my < y + 20 end
  return b
end

local buttons = {}

local function recMake( pO, k, v, pos )
  if type( v ) == "table" then
    pos.y = pos.y + 20
    table.insert( buttons,
                  makeLabel( pos.x, pos.y, k ))
    pos.x = pos.x + 20
    for rk, rv in pairs( v ) do
      recMake( v, rk, rv, pos )
    end
    pos.x = pos.x - 20
  else
    pos.y = pos.y + 20
    table.insert( buttons,
                  makeButton( pos.x, pos.y, pO, k ))
  end
end

local function createButtons( from )
  buttons = {}
  local tempPos = { x = 0, y = 0 }
  for k, v in pairs( from ) do
    recMake( from, k, v, tempPos )
  end
end

----------------------------------------------------------------
-- params
p.defaults = {
  speed = {
    run = 200,
    walk = 100,
    crawl = 50 },
  player = {
    size = .3,
    dotSize = .25,
    dotDistance = 100,
    speed = 200 }
}
p.settings = {}

local function serialize( tbl )
  function recur( tbl )
    local collect = {}
    for k,v in pairs( tbl ) do
      table.insert( collect, stringify( k, v ))
    end
    return table.concat( collect, ",\n" )
  end
  function stringify( key, value )
    if type( value ) == "table" then
      return tostring( key ) .. " = {\n" .. recur( value ) .. "}"
    elseif type( value ) == "number" then
      return tostring( key ) .. " = " .. tostring( value )
    end    
  end      
  return "return {\n" .. recur( tbl ) .. "}"
end

p.save = function()
  console.log( "saving settings" )
  myFile = f.newFile( "settings.lua" )
  myFile:open( "w" )
  myFile:write( serialize( p.settings ))
  myFile:close()
end

p.load = function()
  console.log( "loading settings" )
  local chunk = f.load( "settings.lua" )
  local result = chunk()
  p.settings = result
  createButtons( p.settings )
end

local myFile
if f.exists( "settings.lua" ) then
  console.log( "found setting file" )
  p.load()
else
  console.log( "no setting file found, using defaults" )
  p.settings = p.defaults
  p.save()
  createButtons( p.settings )
end

----------------------------------------------------------------
-- drawing
p.drawParams = function()
  for i = 1, #buttons, 1 do
    buttons[i].draw()
  end
end

----------------------------------------------------------------
-- interaction
local modifierValues = {
  base = { 10, 0.1 },
  mult1 = { 0, 1 },
  mult2 = { 0, 1 }}

local modifierKeys = {
  base = "3",
  mult1 = "1",
  mult2 = "2" }

local modifier = {
  base = 10,
  mult1 = 0,
  mult2 = 0 }

local function keypressed( key, isrepeat )
  if isrepeat then return end
  if key == "tab" then p.takeBack() return end
  if key == "s"   then p.save()     return end
  if key == "l"   then p.load()     return end
  for k,v in pairs( modifierKeys ) do
    if key == v then
      modifier[k] = modifierValues[k][2]
    end
  end
end

local function keyreleased( key )
  for k,v in pairs( modifierKeys ) do
    if key == v then modifier[k] = modifierValues[k][1] end
  end
end

local function mousepressed( x, y, button )
  -- select button
  local selected
  for i = 1, #buttons, 1 do
    if buttons[i].mouseInside( y ) then
      selected = buttons[i]
      break
    end
  end
  if selected == nil then return end
  -- change value
  local amount = 0.1
  local modAmount = amount*(modifier.base^(modifier.mult1+modifier.mult2))
  if button == "wu" then
    selected.change( modAmount )
  elseif button == "wd" then
    selected.change( -modAmount )
  end
end

p.takeOver = function()
  love.keypressed = keypressed
  love.keyreleased = keyreleased
  love.mousepressed = mousepressed
end

p.takeBack = function() end

return p
