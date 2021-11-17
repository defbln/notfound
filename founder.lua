
g = grid.connect()

function init()
  
  
  midi_device = {} -- container for connected midi devices
  midi_device_names = {}
  target = 1
  voices = {}
  voicestealingtoggle = 1
  
  xgid = 0
  ygid = 0
  bankaf = 0
  voicedeled = false
 
  hold = 1
    xgidoff = 0
    ygidoff = 0
    bankafoff = 0
    voicedeledoff = false
  
  althold = 1
  
  screenbankaf = 0
  screenmidi = 0
  screenpadnumber = 0
  screenbanknumber = 0
  screenbankletter = {"A","B","C","D","E","F","G","H","I"}
  
  
  alpha ={{0,1,0,0,1,1,1,0},
          {1,1,1,0,1,1,0,0},
          {1,0,1,0,1,0,0,0},
          {1,1,0,0,1,1,0,0},
          {1,1,1,0,1,0,1,0},
          {1,1,1,0,1,1,1,0},
          {1,1,1,0,1,0,1,0},
          {1,0,0,0,1,1,1,0},
          {1,1,1,0,1,0,1,0},
          {1,1,0,0,1,1,1,0},
          {1,0,1,0,0,1,0,0},
          {1,1,0,0,1,1,1,0},
          {1,1,1,0,0,0,1,0},
          {1,1,0,0,1,0,1,0},
          {1,1,1,0,1,1,1,0}
  }
   grid_redraw()
     
  --clock.run(letter)
  --
 
 

  


  
  for i = 1,#midi.vports do -- query all ports
    midi_device[i] = midi.connect(i) -- connect each device
    local full_name = 
    table.insert(midi_device_names,"port "..i..": "..util.trim_string_to_width(midi_device[i].name,40)) -- register its name
  end
  
  params:add_option("midi target", "midi target",midi_device_names,1)
  params:set_action("midi target", function(x) target = x end)
  redraw()
end

function letter()
local alpharow = 1
local alphabank = 0
for i=1,2 do
  for i=1,5 do
    for i=1,3 do
      for i=1,4 do
        if 15*alpha[alpharow][i+(alphabank*4)]~=0 then
          g:led(alpharow,9-i-(alphabank*4),15*alpha[alpharow][i+(alphabank*4)])
          clock.sleep(0.1)
          g:refresh()
        end
      end
    alpharow = alpharow + 1
    end
    if xgib==0 then
      return
    end
  clock.sleep(0.1)
  end
alphabank = 1
alpharow = 1  
end
end

--[[
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
--]]

g.key = function(x,y,z)
  if x<=15 then
    if y>=5 and z==1 then
      xgid = x - 1
      ygid = 8 - y
      bankaf = 0
      --print("a", bankaf, xgid, ygid)
      voicestealing()
      end
    if y<=4 and z==1 then
      xgid = x - 1
      ygid = 4 - y
      bankaf = 1
     -- print("f", bankaf, xgid, ygid)
      voicestealing()
     -- print("dog f")
    end
  if hold==0 and z==0 then
if y>=5 then
  xgidoff = x - 1
  ygidoff = 8 - y
  bankafoff = 0
elseif y<=4 then
  xgidoff = x - 1
  ygidoff = 4 - y
  bankafoff = 1
end
voicedeledoff = false
for i=1,#voices do
  if voicedeledoff == false then
   if xgidoff==voices[i][1] and ygidoff==voices[i][2] and bankafoff==voices[i][3] then
     midi_device[target]:note_off(47+ygidoff + (xgidoff * 4),100,bankafoff+1)
     table.remove(voices, i)
     voicedeledoff = true
     
   end
  end 
    redraw()
    grid_redraw()
    end
  end
end

if x==16 then
    if y==1 and z==1 then
      for i=1,60 do
      midi_device[target]:note_off(46+i,1,1)
      midi_device[target]:note_off(46+i,1,2)
      while #voices ~= 0 do 
        table.remove(voices, #voices, nil) end
      end
      grid_redraw()
      redraw()
    end 
    if y==2 then
    if z==1 then
    althold = 1
    elseif z==0 then
    althold = 0  
    end
    print(althold)
    end
    
    if y<=6 and y>=3 then
      if althold==0 then
      elseif althold==1 then
        end
    end
    
    if y==7  and z==1 then
      voicestealingtoggle = 1 - voicestealingtoggle
      g:led(16,7,7+(voicestealingtoggle*8))
      g:refresh()
    end
    if y==8  and z==1 then
      hold = 1 - hold
      g:led(16,8,7+(hold*8))
      g:refresh()
    end
   
   redraw() 
end
end

function chordsave()
end

function chordload()
end

function voicestealing()
if #voices==0 then
  table.insert(voices, {xgid,ygid,bankaf})
  midi_device[target]:note_on(47+ygid + (xgid * 4),100,bankaf+1)
elseif #voices~=0 then
for i=1,#voices do
  if voicedeled == false then
   if xgid==voices[i][1] and ygid==voices[i][2] and bankaf==voices[i][3] then
     midi_device[target]:note_off(47+ygid + (xgid * 4),100,bankaf+1)
     print("silenced")
     print(i, voices[i][1], voices[i][2], voices[i][3])
     table.remove(voices, i)
     voicedeled = true
   end
end
end
  if voicedeled==false and voicestealingtoggle==1 then
    midi_device[target]:note_on(47+ygid + (xgid * 4),100,bankaf+1)
    table.insert(voices, {xgid,ygid,bankaf})
    if #voices==7 and voicestealingtoggle==1 then
      print(#voices,"x-------y-------bank")
      print("remo", xgid, ygid, bankaf)
      midi_device[target]:note_off(47+voices[1][2] + (voices[1][1] * 4),100,voices[1][3]+1)
      table.remove(voices, 1)
    end
elseif voicedeled==false and voicestealingtoggle==0 and #voices<=5 then
  midi_device[target]:note_on(47+ygid + (xgid * 4),100,bankaf+1)
  table.insert(voices, {xgid,ygid,bankaf})
end
end
voicedeled = false
grid_redraw()
  redraw()
end

function grid_redraw()
  g:all(0)
  local interbank = 0
  g:led(16,1,7)
  g:led(16,2,7)

  for i=1,4 do
  g:led(16,i+2,3)
  end

  g:led(16,7,7+(voicestealingtoggle*8))
  g:led(16,8,7+(hold*8)) 
for i=1,5 do
  local interx = 0
  local intery = 0
  for i=1,12 do
    g:led((interx+1)+(interbank*3),8-intery,15-(10+interx+intery))
    g:led((interx+1)+(interbank*3),4-intery,15-(10+interx+intery))
    interx = interx + 1
    intery = intery + 1
    interx = interx%3
    intery = intery%4
  end
  interbank = interbank + 1
end
if #voices ~= 0 then
  print(#voices,"x-------y-------bank")
  for i=1,#voices do
    g:led((voices[i][1]+1), 8 - (voices[i][2])-(voices[i][3]*4),15)
    print(i, voices[i][1], voices[i][2], voices[i][3])
  end
  elseif #voices == 0 then
  print("All is queit")
  end

g:refresh()
end

function redraw()
screenbankaf = 0
screenmidi = 0
screenpadnumber = 0
screenbanknumber = 0

screen.clear()
screen.font_face(15)
screen.font_size(8)

for i=1,6 do
screen.move(((i-1)*22)+1,7)  
screen.text(" " .. i .. " ")
end
if #voices~=0 then
  for i=1,6 do
    if i<=#voices then
    screenbankaf = voices[i][3]
    screenmidi = voices[i][2] + (voices[i][1] * 4)
    screenpadnumber = screenmidi%12+1
    screenbanknumber = math.floor((screenmidi/12)+1)+(screenbankaf*4)
  screen.move(((i-1)*22)+1,17)
  screen.text(screenbankletter[screenbanknumber] .. screenpadnumber)
  screen.move(((i-1)*22)-1,17)
  screen.text("|_____")
  screen.update()
 -- elseif i~=#voices then
 --screen.move(((i-1)*22)-1,17)
-- screen.text("|     ")
    end
end
  screen.move(0,60)
  screen.font_size(20)
  screen.text(screenbankletter[screenbanknumber] .. screenpadnumber)
elseif #voices==0 then

end
screen.update()
end