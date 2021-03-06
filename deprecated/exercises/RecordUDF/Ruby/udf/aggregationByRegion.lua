local function aggregate_stats(map,rec)
  -- Examine value of 'region' bin in record rec and increment respective counter in the map
  debug("what the aggregate_stats")

  if rec.region == 'n' then
      map['n'] = (map['n'] or 0) + 1
  elseif rec.region == 's' then
      map['s'] = (map['s'] or 0) + 1
  elseif rec.region == 'e' then
      map['e'] = (map['e'] or 0) + 1
  elseif rec.region == 'w' then
      map['w'] = (map['w'] or 0) + 1
  end
  -- return updated map
  return map
end

local function reduce_stats(a,b)
  -- Merge values from map b into a
  debug(" what the reduce_stats")
  a.n = a.n + b.n
  a.s = a.s + b.s
  a.e = a.e + b.e
  a.w = a.w + b.w
  -- Return updated map a
  return a
end

function sum(stream)
  -- Process incoming record stream and pass it to aggregate function, then to reduce function
  --   NOTE: aggregate function aggregate_stats accepts two parameters: 
  --    1) A map that contains four variables to store number-of-users counter for north, south, east and west regions with initial value set to 0  
  --    2) function name aggregate_stats -- which will be called for each record as it flows in
  -- Return reduced value of the map generated by reduce function reduce_stats
  debug("what the sum udf")
  return stream : aggregate(map{},aggregate_stats) : reduce(reduce_stats)
end
