margin = 0.001
current, change = 0,0
stop = true
tar, minT, maxT = 0,-1,1
up, down = false, false

function onTick()

  current = input.getNumber(1)
  change = input.getNumber(2)
  margin = input.getNumber(3)
  minT = input.getNumber(4)
  maxT = input.getNumber(5)
  stop = input.getBool(1)
  
  adjustTar()
    
  if tar < current-margin then
    up,down = false,true
  elseif tar > current+margin then
    up,down = true,false
  else
    up, down = false, false
  end
  
  if stop then
    tar = 0
    output.setNumber(1, 0)
  else
    output.setNumber(1, current)
  end
  
  output.setBool(1, up)
  output.setBool(2, down)
end

function adjustTar()
  
  if change > 0 then
    tar = math.min(maxT,tar+margin)
  elseif change < 0 then
    tar = math.max(minT,tar-margin)
  end
  
end

function onDraw()
end