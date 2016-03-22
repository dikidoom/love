--local utx = {}

---------------------------------------------------------------- general functions
local function rangeHelper( n, start )
  if not start then start = 0 end
  local f = function( state, var )
    if var < n then return var + 1 end
    return nil
  end
  return f, nil, start
end

function range( n ) return rangeHelper( n, 0 ) end
function range0( n ) return rangeHelper( n-1, -1 ) end

function map( list, fn )
  local result = {}
  for k,v in pairs( list ) do
    table.insert( result, fn( v ))
  end
  return result
end

function filter( list, predicate ) -- !!!!!!!! UNTESTET !!!!!!!!
  local result = {}
  for k,v in pairs( list ) do
    if predicate( v ) then table.insert( result, v ) end
  end
  return result
end

function signum( number )
  if number < 0 then return -1 elseif number > 0 then return 1 else return 0 end
end

---------------------------------------------------------------- specific fns
function atlas( img, tilesizex, tilesizey )
  -- create a texture atlas
  -- returns: an array of quads with proper tile mappings
  local imgwidth, imgheight = img:getWidth(), img:getHeight()
  local tilecountx, tilecounty = imgwidth / tilesizex, imgheight / tilesizey
  local quads = {}
  for i in range0( tilecountx * tilecounty ) do
    quads[i] = love.graphics.newQuad( ( i % tilecountx ) * tilesizex,
                                      math.floor(i / tilecountx) * tilesizey,
                                      tilesizex, tilesizey,
                                      imgwidth, imgheight )
  end
  return quads
end

---------------------------------------------------------------- return
return {
  range = range,
  range0 = range0,
  atlas = atlas }