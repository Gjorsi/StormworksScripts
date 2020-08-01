ti = 0
operator=1

function onTick()
  
  ti = ti+1
  if ti > 2000 then ti = 61 end
  
  if ti > 60 then
    if input.getBool(1) then
      operator = 1
      ti = 0
    elseif input.getBool(2) then
      operator = 2
      ti = 0
    elseif input.getBool(3) then
      operator = 3
      ti = 0
    end
  end

  if operator == 1 then
    output.setBool(1, true)
    output.setBool(2, true)
  elseif operator == 2 then
    output.setBool(1, false)
    output.setBool(2, true)
  elseif operator == 3 then
    output.setBool(1, true)
    output.setBool(2, false)
  end

end

function onDraw()
end