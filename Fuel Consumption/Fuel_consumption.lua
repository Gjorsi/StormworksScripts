init = false
prevLevel1=0
prevLevel2=0
fuelConsumption=0
timeToEmpty=0
deltaTime=1

function onTick()
  
  if input.getBool(1) then
    capacity = input.getNumber(2)
    deltaTime = input.getNumber(3)
    level=input.getNumber(1)
    used1=prevLevel1-level
    used2=prevLevel2-prevLevel1
    
    if used1>=0 and used2>=0 then
      used = avg(used1,used2)
      fuelConsumption = used*(60/deltaTime)
      if fuelConsumption ~= 0 then timeToEmpty = capacity/fuelConsumption end
    end
    
    prevLevel2=prevLevel1
    prevLevel1=level
  end
  
  output.setNumber(1,fuelConsumption)
  output.setNumber(2,timeToEmpty)
end

function avg(a,b)
  return (a+b)/2
end

function onDraw()
  screen.drawText(2,2,"dT:"..deltaTime)
end