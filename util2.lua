local m = {}

function m.string2index( str, char )
  -- return the [x,y]-indices of all CHAR in STR
  result = {}
  x, y = 0, 0
  for i = 1, string.len( str ) do
    s = string.sub( str, i, i)
    if s == char then
      table.insert( result, { x, y })
    end
    if s == "\n" then
      x = 0
      y = y + 1
    else
      x = x + 1
    end
  end
  return result
end

-- function m.join( t1, t2 )
--   for k, v in pairs( t2 ) do t1[k] = v end
--   return r
-- end

function m.append( t1, t2 )
  -- destructive
  for k, v in pairs( t2 ) do
    table.insert( t1, v )
  end
  return t1
end

return m
