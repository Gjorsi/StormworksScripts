clutch, rps, deltaC = 0,0,0
preferredRPS = 0

function onTick()
  
  readInputs()
  
  if rps > preferredRPS*1.2 and clutch < 1 then
    incClutch(rps-preferredRPS)
  elseif rps < preferredRPS then
    redClutch(preferredRPS-rps)
  end
  
  -- Anti-stalling feature
  if rps < 2.2 then 
    clutch = 0
  end
  
  output.setNumber(1, clutch)
end

function incClutch(delta)
  if clutch < 0.45 then
    clutch = math.min(clutch+deltaC*4*delta, 1)
  elseif clutch < 1 then
    clutch = math.min(clutch+deltaC*delta, 1)
  end
end

function redClutch(delta)
  if clutch > 0.45 then
    clutch = math.max(clutch-deltaC*4*delta, 0)
  elseif clutch > 0 then
    clutch = math.max(clutch-deltaC*2*delta, 0)
  end
end

function readInputs()
  rps = input.getNumber(1)
  deltaC = input.getNumber(2)
  preferredRPS = input.getNumber(3)
end

function onDraw()
end