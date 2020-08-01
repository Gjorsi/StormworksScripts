init = false
prevLevel1=0
prevLevel2=0
fuelConsumption=0
timeToEmpty=0
range=0
deltaTime=5

function onTick()
  
  if input.getBool(1) then
    speed = input.getNumber(2)
    deltaTime = input.getNumber(3)
    level=input.getNumber(1)
    used1=prevLevel1-level
    used2=prevLevel2-prevLevel1
    
    if used1>=0 and used2>=0 then
      used = avg(used1,used2)
      fuelConsumption = used*(60/deltaTime)
      timeToEmpty = level/fuelConsumption
      range = speed*60*timeToEmpty/1000
      if not input.getBool(2) then
        range = range*0.54
      end
    else
      fuelConsumption, timeToEmpty, range = 0,0,0
    end
    
    prevLevel2=prevLevel1
    prevLevel1=level
  end
  
  output.setNumber(1,fuelConsumption)
  output.setNumber(2,timeToEmpty)
  output.setNumber(3,range)
end

function avg(a,b)
  return (a+b)/2
end

function onDraw()
  screen.drawText(2,2,"dT:"..deltaTime)
end