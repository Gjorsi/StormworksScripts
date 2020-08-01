initialised = false
values={0,0,0,0,0,0,0,0}
n_values = 0
current_value = 0
pushed = false

function onTick()
  if not initialised then initialise() end
  
  if input.getBool(1) and not pushed then 
    increment()
  elseif input.getBool(2) and not pushed then
    decrement()
  end
  
  pushed = input.getBool(1) or input.getBool(2)
  
  output.setNumber(1, values[current_value])
end

function initialise()
  for i=1,8 do
    values[i-1] = input.getNumber(i)
    if values[i-1] ~= 0 then 
      initialised = true
      n_values = input.getNumber(9)
    end
  end
end

function increment()
  current_value = (current_value+1)%n_values
end

function decrement()
  current_value = (current_value-1)%n_values
end