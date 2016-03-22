-- util lib
-- by diki
-- version 0.1 - 14-09-04

local m = {}

--------------------------------------------------------------------------------
-- maths

function m.piWrap( f )
  -- always positive, never > 2 pi
  if f < 0 then
    return m.piWrap( f + math.pi * 2 )
  elseif f > math.pi * 2 then
    return m.piWrap( f - math.pi * 2 )
  else
    return f
  end
end

function m.rotate( x, y, angle )
  local tx = x * math.cos( angle ) - y * math.sin( angle )
  local ty = x * math.sin( angle ) + y * math.cos( angle )
  return tx, ty
end

function m.walk( x, y, angle, amount )
  local tx = x + math.cos( angle )* amount
  local ty = y + math.sin( angle )* amount
  return tx, ty
end

--------------------------------------------------------------------------------
-- vector
vector_mt = {
  __index = function( tbl, key )
    if key == 'x' then return tbl[1]
    elseif key == 'y' then return tbl[2] 
    elseif key == 'z' then return tbl[3]
    end
    -- TODO include 'magnitude'/'length', 'normalized'
    return nil
  end,
  __newindex = function( tbl, key, value )
    if key == 'x' then tbl[1] = value
    elseif key == 'y' then tbl[2] = value
    elseif key == 'z' then tbl[3] = value
    end
  end,
  __add = function( lhs, rhs ) -- vector addition
    local r = {}
    for i = 1, math.max( #lhs, #rhs ) do
      r[i] = (lhs[i] or 0) + (rhs[i] or 0)
    end
    setmetatable( r, vector_mt )
    return r
  end,
  __sub = function( lhs, rhs ) -- vector subtraction
    local r = {}
    for i = 1, math.max( #lhs, #rhs ) do
      r[i] = (lhs[i] or 0) - (rhs[i] or 0)
    end
    setmetatable( r, vector_mt )
    return r
  end,
  __mul = function( lhs, rhs ) -- scalar multiplication
    local r = {}
    for i = 1, #lhs do
      r[i] = (lhs[i] or 0) * rhs
    end
    setmetatable( r, vector_mt )
    return r
  end }

function m.newVector( ... )
  local tbl = {}
  for i = 1, select( "#", ... ) do
    tbl[i] = select( i, ... )
  end
  return setmetatable( tbl, vector_mt )
end

--------------------------------------------------------------------------------
-- graphics

function m.drawCentered( img, x, y, scale )
  love.graphics.draw( img, x, y, 0,
                      scale, scale,
                      img:getWidth() / 2,
                      img:getHeight() / 2 )
end

--------------------------------------------------------------------------------
-- meta

function m.rerequire( name )
  package.loaded[ name ] = nil
  return require( name )
end

--------------------------------------------------------------------------------
return m