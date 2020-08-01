pushed = false
in1, in2 = false, false
out1, out2 = false, false

function onTick()
  
  if not pushed then
    
    if input.getBool(1) then
      if out1 then 
        out1 = false
      else 
        if out2 then out2 = false end
        out1 = true
      end
      
    elseif input.getBool(2) then
      if out2 then
        out2 = false
      else
        if out1 then out1 = false end
        out2 = true
      end
      
    end
  end
  
  pushed = (input.getBool(1) or input.getBool(2))
  output.setBool(1, out1)
  output.setBool(2, out2)
  end