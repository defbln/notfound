-- NotFound, 
-- Seqencer and extra 
-- table space for sp404
-- samplers.
--
-- A daughter and handmaid who
-- aspires for so much more.



pattern_time = require 'pattern_time' -- use the pattern_time lib in this script

lattice = require("lattice")


--my_lattice:toggle()


function init()
  
my_lattice = lattice:new()

  
  grid_pattern = pattern_time.new() -- establish a pattern recorder
  grid_pattern.process = grid_pattern_execute -- assign the function to be executed when the pattern plays back
  midi_device = {} -- container for connected midi devices
  midi_device_names = {}
  target = 1
  
  random_note = {56,0,0}
  velocity = 100
  channel = 1
  liverec = 0
  play = 0
  retrig_pattern = 0
  padmute = 0
  bank = 1
  bankab = {0,0,0,0,0}
  clockrun = 1
  step = 0
  step2 = step
  seq = {{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}}
  seq2 = {{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}}
grid_redraw()
  --g:refresh()
  -- for i=1,4 do g:led(i+4,6,3) g:led(i+4,7,4) g:led(i+4,8,3) end

  pattern_a = my_lattice:new_pattern{
    action = function() 

    step = step + 1
    step = step % 16
      clock.run(zed)
      clock.run(bag) 
    --print(step, t) 
      end,
    division = 1/16
    
  }

pattern_b = my_lattice:new_pattern{
    action = function(t) 
      --print("dogwoman", t) 
       if retrig_pattern == 1 and step==0 then
    grid_pattern:start() -- start playing
    print("u live")
  elseif retrig_pattern == 0 then
     print("u die ;(")
      end
      
      end,
    division = 1/16
  }

  --my_lattice:start()

  
  for i = 1,#midi.vports do -- query all ports
    midi_device[i] = midi.connect(i) -- connect each device
    local full_name = 
    table.insert(midi_device_names,"port "..i..": "..util.trim_string_to_width(midi_device[i].name,40)) -- register its name
  end
  
  params:add_option("midi target", "midi target",midi_device_names,1)
  params:set_action("midi target", function(x) target = x end)
end
g = grid.connect()
----- MIDI CONNECT
function enc(n,d)
  if n == 2 then
    if #midi_device > 0 then
      params:delta("midi target",d)
      redraw()
    end
  end
    if n == 3 and d>=1 then
    step = step + 1
    step = step % 16
    clock.run(bag)

    elseif n == 3 and d<=-1 then
      step = step - 1
      step = step % 16
      clock.run(bag)
end
end
function zed()
  if play==1 then
    midi_device[target]:note_on(seq[step+1][1],100,seq[step+1][2]+1) 
    midi_device[target]:note_on(seq2[step+1][1],100,seq2[step+1][2]+1) 
    print("dsss")
end
end

---- CLOCKS
--function forever(freq)
--while true do
   -- clock.sync(1/4)
  --  step = step + 1
   -- step = step % 16
    --print(step)
    --clock.run(bag)
    --midi_device[target]:note_on(seq[step+1][1],100,seq[step+1][2]+1) 
    --midi_device[target]:note_on(seq2[step+1][1],100,seq2[step+1][2]+1) 
 -- end
--end


 function bag()

      g:led(step+1,1,15) -- turn on that LED!
      g:led(step+1,2,15) -- turn on that LED!
      g:refresh()
    --clock.sync(1/4)
      if seq[step+1][1]~=0 then
      g:led(step+1,1,7)
      end
       if seq2[step+1][1]~=0 then
      g:led(step+1,2,7)
      end
      if seq[step+1][1]==0 then
      g:led(step+1,1,0)
      end
      if seq2[step+1][1]==0 then
      g:led(step+1,2,0)
      end
print("step")
end


---- GRID INPUT
g.key = function(x,y,z)

    if y==1 and z==1 then
      if pad==1 then
        seq[x] = {random_note[1],random_note[2]}
         g:led(x,1,7)
      elseif pad==0 then
        seq[x] = {0,0}
         g:led(x,1,0)
      end 
      g:refresh()
      end
    if y==2 and z==1 then
      if pad==1 then
        seq2[x] = {random_note[1],random_note[2]}
         g:led(x,2,7)
      elseif pad==0 then
        seq2[x] = {0,0}
         g:led(x,2,0)
      end 
    end
    if y==7 and x==5 and z==1 then
      padmute = 1 - padmute
      if padmute==1 then
        g:led(5,7,15)
      elseif padmute==0 then
        g:led(5,7,0)
      end
      end
    if y>=6 and x<=4 then
        if z==1 then 
        random_note = {46+x+((y-6)*4)+((bank-1)*12),bankab[bank],1}
        pad = 1
        --print(random_note[1], random_note[2])
       if padmute==0 then
         midi_device[target]:note_on(random_note[1],100,random_note[2]+1) 
        g:led(x,y,15)
        end
        elseif z==0 then
        random_note = {46+x+((y-6)*4)+((bank-1)*12),bankab[bank],0}
        if padmute==0 then
          midi_device[target]:note_off(random_note[1],100,random_note[2]+1)  
        end
        g:led(x,y,4)
        --print(random_note[1],random_note[2])
         pad = 0
         --print(random_note[1], random_note[2])
      end end
    if x<=5 and y==5 and z==1 then
      if bank ~= x then
      bank = x
      print("one")
        --g:led(bank,5,15)
     elseif bank == x then
        bankab[x] = 1 - bankab[x]
        print(bankab[x])
     end
    if bankab[x]==0 then
      for i=1,5 do g:led(i,5,1) end
        g:led(bank,5,15)
       print("teo")
    elseif bankab[x]==1 then
    for i=1,5 do g:led(i,5,1) end
        g:led(bank,5,8)
        print("thre")
        end
  end

if z==1 and y==7 and x==15 then
  if retrig_pattern == 1 then
    retrig_pattern = 0
    g:led(15,7,0)
  elseif retrig_pattern == 0 then
    retrig_pattern = 1
    g:led(15,7,15)
end
end
if z==1 and y==7 and x==16 then
 clockrun = 1 - clockrun
 print("flip")
 
 if clockrun==0 then
 clock.cancel(clock_id)
 print("stop")
 end
if clockrun==1 then
  clock.run(forever)
   step = 0
 step2 = 0
 print("start")
end
end

if z == 1 and y == 8 and x == 15 then -- the bottom left key is the pattern control key, if i press it...
    if grid_pattern.rec == 1 then -- if we're recording...
      grid_pattern:rec_stop() -- stop recording
      grid_pattern:start() -- start playing
      --retrig_pattern = 1
    elseif grid_pattern.count == 0 then -- otherwise, if there are no events recorded..
      grid_pattern:rec_start() -- start recording
      liverec = 0
     -- retrig_pattern = 0
    elseif grid_pattern.play == 1 then -- if we're playing...
      grid_pattern:stop() -- stop playing
      --retrig_pattern = 0
    else -- if by this point, we're not playing...
      grid_pattern:start() -- start playing
     -- retrig_pattern = 1
    end
  elseif z == 1 and y == 8 and x == 16 then -- the key to the right of the pattern control key...
    grid_pattern:rec_stop() -- stops recording
    grid_pattern:stop() -- stops playback
    grid_pattern:clear() -- clears the pattern
    --g:all(0) -- clear the grid
  end
  if random_note[2] <= 1 and y >= 6 and x<=4 then -- if we press any key above the bottom row...
    record_this = {} -- create a table called "record_this" to put our events!
    record_this.x = (random_note[1]) -- here's an event, the key's x position
    record_this.y = (random_note[2]+1)
    record_this.z = (random_note[3])-- here's another event, the key's y position
    grid_pattern:watch(record_this) -- tell the pattern recorder to watch these events + commit them to memory
    --g:all(0)
    --g:led(x,y,z*15)
    print(record_this.x)
    print(record_this.y)
  end
 if y>=5 then
 -- g:refresh()
  grid_redraw()
   end
end
  



--XXXXXXXXX
function grid_pattern_execute(recorded) -- when the pattern plays back, do the following with each entry we recorded in 31-35
  -- g:all(0)
  if recorded.z>=1 then
  midi_device[target]:note_on(recorded.x,100,recorded.y)
  -- g:led(recorded.x,recorded.y,15) -- remember "record_this.x" and "record_this.y"? here, we're using that data and doing something with it!
  -- grid_redraw()
  -- g:refresh()
  --print("on")
  elseif recorded.z==0 then 
    midi_device[target]:note_off(recorded.x,0,recorded.y)
    --print("off")
end
end
--XXXXXXXXX
function grid_redraw()
    for i=1,5 do g:led(i,5,1) end
  g:led(bank,5,15)
  for i=1,4 do g:led(i,6,4) g:led(i,7,4) g:led(i,8,4) end
----
  if grid_pattern.rec == 1 then -- if we're recording...
    g:led(15,8,10) -- medium-high brightness
  elseif grid_pattern.play == 1 then -- if we're playing...
    g:led(15,8,15) -- highest brightness
  elseif grid_pattern.play == 0 and grid_pattern.count > 0 then -- if we're not playing, but the pattern isn't empty...
    g:led(15,8,5) -- lower brightness
  else -- otherwise, if we're not recording/playing and the pattern is empty...
    g:led(15,8,3) -- lowest brightness
  end
  g:refresh()
end


function key(n,z)
  if n==2 and z==1 and play==0 then
    my_lattice:start()
    play = 1
    print("start")
    step = 0
   clock.run(zed)
    clock.run(bag)
-- midi_device[target]:note_on(seq[step+1][1],100,seq[step+1][2]+1) 
 --midi_device[target]:note_on(seq2[step+1][1],100,seq2[step+1][2]+1) 


  elseif n==2 and z==1 and play==1 then
    my_lattice:toggle()
    --my_lattice:stop()
    play = 0
    print("stop")

  
    end
end
----- SCREEN OUTPUT
function redraw()
  screen.clear()
  screen.move(0,60)
  screen.text("look where you last saw it")
  screen.move(0,10)
  screen.text(params:string("midi target"))
  screen.move(0,30)
  screen.update()
end