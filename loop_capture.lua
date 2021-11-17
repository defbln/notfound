--loop_capture
--sp-555 clone

pattern_time = require 'pattern_time' -- use the pattern_time lib in this script

lattice = require("lattice")

rate = 1.0
rec = 1.0
pre = 1.0

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
  
  lc_rec_arm = 0
  lc_rec = 0
  
  
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
       if retrig_pattern == 1 and step==15 then
    --grid_pattern:start() -- start playing
    softcut.position(1,1)
  elseif retrig_pattern == 0 then

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
  
--SOFTCUT
  -- send audio input to softcut input
	audio.level_adc_cut(1)
  
  softcut.buffer_clear()
  softcut.enable(1,1)
  softcut.buffer(1,1)
  softcut.level(1,1.0)
  softcut.rate(1,1.0)
  softcut.loop(1,1)
  softcut.loop_start(1,1)
  softcut.loop_end(1,5)
  softcut.position(1,1)
  softcut.play(1,0)
  softcut.fade_time(1,0.0)
  -- set input rec level: input channel, voice, level
  softcut.level_input_cut(1,1,1.0)
  softcut.level_input_cut(2,1,1.0)
  -- set voice 1 record level 
  softcut.rec_level(1,1)
  -- set voice 1 pre level
  softcut.pre_level(1,1)
  -- set record state of voice 1 to 1
  softcut.rec(1,0)
  
  
  
  

end
g = grid.connect()








function enc(n,d)
  if n == 2 then
    --if #midi_device > 0 then
   --   params:delta("midi target",d)
   --   redraw()
    --end
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

end

end


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

end


---- GRID INPUT
g.key = function(x,y,z)
  if y<5 then topgrid(x,y,z) else bottomgrid(x,y,z) end
end

function topgrid(x,y,z)
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
  end
function bottomgrid(x,y,z)
  
    
    if y==8 and x==5 and z==1 then
      padmute = 1 - padmute
      if padmute==1 then
        g:led(5,8,15)
      elseif padmute==0 then
        g:led(5,8,0)
      end
    end
    
    if y>=6 and x<=4 then
      
        if z==1 then 
        random_note = {46+x+((y-6)*4)+((bank-1)*12),bankab[bank],1}
        pad = 1

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

         pad = 0

        end 
        end

      
    if x<=5 and y==5 and z==1 then
      if bank ~= x then
      bank = x
      print("one")
        --g:led(bank,5,15)
     elseif bank == x then
        bankab[x] = 1 - bankab[x]

     end
    if bankab[x]==0 then
      for i=1,5 do g:led(i,5,1) end
        g:led(bank,5,15)

    elseif bankab[x]==1 then
    for i=1,5 do g:led(i,5,1) end
        g:led(bank,5,8)

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

 
 if clockrun==0 then
 clock.cancel(clock_id)

 end
if clockrun==1 then
  clock.run(forever)
   step = 0
 step2 = 0

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

  end
-- if y>=5 then
 -- g:refresh()
--  grid_redraw()
-- end
 
  if x==6 and y==5 and z==1 then --arm loop capture
    if lc_rec_arm==0 then 
      lc_rec_arm=1
      g:led(6,5,15)
    else
        lc_rec_arm=0 
        g:led(6,5,3)
    end
         g:refresh()
  end
  
  if x==7 and y==5 and z==1 then --just start record!
     if lc_rec==0 then
      softcut.play(1,1)
      softcut.position(1,1)
      softcut.rec(1,1)
      lc_rec=1
      g:led(7,5,15)
    elseif lc_rec==1 then
      softcut.rec(1,0)
      softcut.play(1,0)
      lc_rec=0
      g:led(7,5,3)
    end
    
    lc_rec_arm=0
    g:led(6,5,3)
        
    g:refresh()
end
  if y>=6 and x<=4 and z==1 then --listen to pad start record
      if lc_rec_arm==1 and lc_rec==0 then
        softcut.play(1,1)
        softcut.position(1,1)
        softcut.rec(1,1)
        
        lc_rec=1
        g:led(7,5,15)
        
        lc_rec_arm=0
        g:led(6,5,3)
        
        g:refresh()
      end
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


function grid_redraw()
    for i=1,5 do 
      g:led(i,5,7) end
    if bankab[bank] == 0 then
  g:led(bank,5,15)
    elseif bankab[bank] == 1 then
    clock.run(bankfblink, bank)
    end
  for i=1,4 do 
    g:led(i,6,4)
    g:led(i,7,4) 
    g:led(i,8,4) end
  for i=1,3 do
    g:led(i+5,5,2)
    end
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

function bankfblink(j)
while true do

  g:led(j,5,15)
  g:refresh()
  clock.sleep(0.1)
  g:led(j,5,7)
  g:refresh()
  clock.sleep(0.1)
 if bankab[j] ~= 1 or j~= bank then
   return
 end
 
end
 g:led(j,5,15)
end


function key(n,z)
  if n==2 and z==1 and play==0 then
    my_lattice:start()
    softcut.position(1,1)
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
 -- screen.move(0,10)
  --screen.text(params:string("midi target"))
  screen.update()
end