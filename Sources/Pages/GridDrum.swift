//
//  GridDrum.swift
//  IgniteStarter
//
//  Created by Richard Adem on 06/04/2025.
//

import Foundation
import Ignite

struct GridDrum: StaticPage {
  var title = "Simple step sequencer for playing Volca Drums on a Grid via Norns"

  var parentLayout = SuggestedArticleLayout()

  var body: some HTML {
    Text(title)
      .font(.title1)
    Text("2025-04-06")

    Image("https://res.cloudinary.com/dxhxohuwc/image/upload/t_1024/v1743966546/gridDrum_launch.jpg",
          description: "The launch screen of the Grid Drum app on Norns")
    .resizable()
    .frame(width: 512)

    Text(markdown:
"""
I've had a 256 [Monome Grid](https://monome.org/docs/grid/editions/#series-64-128-256--2007-2010)
for a few years and version of the [Norns](https://monome.org/docs/norns/) called [Fates](https://github.com/okyeron/fates)
that I use to control it. I also built a 8x8 Monome Grid called an [Arduinome](https://en.wikipedia.org/wiki/Arduinome) before that.
I have a [Volca](https://en.wikipedia.org/wiki/Korg_Volca) Drum which is a drum simulator
synthesiser which can make all kinds of crazy sounds. I wanted to use these instruments together.
"""
    )

    Text(markdown:
"""
I love the large size of the 256 for Step Sequencers, you can see all the instrument channels at
once down the Y axis (and the 256 could show 16 channels!), and 16 steps on the X axis. The current
step position is shown by a line from top to bottom that moves left to right. You select 
instruments, e.g. bass drum or clap, on rows and the step to play them on the columns. Since you can
see everything thats happening at once, it's really easy to make and change rhythms while it's 
playing.     
"""
    )

    Text(markdown:
"""
There are a lot of step sequencers for Norns and the Grid and I've tried a bunch over the years. But
I thought i'd try to build one myself. I'd only tried to make a sort of [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life)
midi trigger script inspired by 100 Rabbits' [Orca](https://100r.co/site/orca.html) but didn't get
very far.
"""
    )

    ZStack {
      Embed(title: "Flyers Norns script", url: URL(string: "https://player.cloudinary.com/embed/?cloud_name=dxhxohuwc&public_id=IMG_7926_opm80r&profile=cld-default")!)
        .aspectRatio(.square)
    }
    .frame(maxWidth: 512)

    Text(markdown:
"""
Norns scripts are written in [Lua](https://www.lua.org/) which is a scripting language that's used
in a lot of game engines to do simple scripting things. One difference with most other languages is
that array indexes start at 1 instead of 0, this is meant to be initiative for non-programmers to
get started with but it trips me up a lot! One issue I had with my step sequencer was that there was
a little gap of time after the sequence restarted, I wasn't sure what it was until I remembered the
index 1.    
"""
    )

    Text(markdown:
"""
I started off by going through the Norns tutorials and the basis for the step sequencer is [Grid Tutorial 9](https://github.com/neauoire/tutorial/blob/master/9_grid.lua)
which talks about how to draw to the grid. These tutorials are great and cover a lot of what you can
do with Norns. I added a clock and drew the position line on the Grid and also mirrored that on the
Norns screen itself. I wanted to keep the Grid just for the sequencer with no controls on the grid
apart from setting step trigger positions and only displaying the triggers and the position line.
This way I can use all 256 buttons for the sequencer and have the Norns screen and controls for any
other utilities.
"""
    )

    // Lua code but Swift highlighting works ok since Ignite doesn't support Lua highlighting.
    CodeBlock(.swift) {
"""
function update()
  g:all(0)

  for x = 1, gridSize.width do
    for y = 1, gridSize.height do

      if (beatColumn == x) or (beatColumn ~= x and grid[x][y] == true) then
        g:led(x, y, focus.brightness)
      end
    end
  end

  g:refresh()
  redraw()
end
"""
    }
    Emphasis {
      Text("The update loop for drawing to the Grid.")
    }

    Text(markdown:
"""
Next was to send the midi signals, I am using a cheap USB to 5pin midi adapter that I connect to the
Norns. When you setup Midi you specify the OS Device, in this case there was one Midi device, my USB
adapter, on port 1 (remember index starts at 1). Then you send the note on (and then off) with the
command `:note_on(note, velocity, channel)`, so I tried note 0 (midi index starts at 0), velocity
127 and channel 10. I could see that the midi messages were being sent to the USB adapter because
the light was flashing, but the Volca Drum wasn't doing anything.
"""
    )

    Text(markdown:
"""
After a little research on how the Volca Mdi works I found out that first you have to set the Midi
mode by holding down the record button when you turn it on. And then send Midi to a separate channel
for each instrument (and starting at index 1!). The Volca Drum has 6 instruments that can be
triggered by the buttons on the device or by Midi. When sending Midi to trigger the first instrument
you send an "on" message with the key being anything, I used 100, a velocity, I used 127, and on
channel 1. For the second instrument I send the same but on channel 2 and so on. There may be a way
to have this all sent on channel 10 with an update to the firmware.
"""
    )

    Text(markdown:
"""
Next I wanted to use one of the Norns buttons to play and pause. I used button 2 (sometimes called KEY2) to update a bool.
"""
    )

    CodeBlock(.swift) {
"""
function key(id,state)
  if id == 2 and state == 1 then
    play = not play
    print("play: ", play)
  elseif id == 3 and state == 1 then
    -- nothing
  end
end

-- ...

function update()
  g:all(0)

  for x = 1, gridSize.width do
    for y = 1, gridSize.height do
      if (beatColumn == x) then
        
        if (play == true) and (grid[x][y] == true) then
          -- Selected position is on the line, play the note.
          key = 100
          velocity = 127
          channel = y
          out_midi:note_on(key, velocity, channel)
          out_midi:note_off(key, velocity, channel)
        end
        -- Draw the line.
        g:led(x, y, focus.brightness)
      end
      
      -- Draw selected positions if they are not on the line.
      if (beatColumn ~= x and grid[x][y] == true) then
        g:led(x, y, focus.brightness)
      end
      
      
    end
  end
  
  g:refresh()
  redraw()
end
"""
    }
    Emphasis {
      Text("The updated update code with sending the Midi on and off right afterwards as well as play/pause.")
    }

  Text(markdown:
"""
Finally I wanted to use one of the rotary encoder knobs to change the BPM. This works at the Norns
OS level and is referred to as "tempo". I originally thought it would be the `clock.sync()` function
but that is to do with how many steps per beat. You can fetch the current tempo with
`clock.get_tempo()`, but to change the tempo you pass the delta from the encoder to
`params:delta("clock_tempo", delta)`. It's also possible to set the tempo directly with
`params:set("clock_tempo", 100)` but when I tried this with keeping a local copy of the tempo the
updates were slow, updating the delta directly is much faster when turning the encoder. 
"""
    )


    ZStack {
      Embed(title: "Playing the Grid Drum with a 256 Monome Grid and the Volca Drum",
            url: URL(string: "https://player.cloudinary.com/embed/?cloud_name=dxhxohuwc&public_id=IMG_7923_zsgcvb&profile=cld-default")!)
        .aspectRatio(.square)
    }
    .frame(maxWidth: 512)

    Text(markdown:
"""
Here is the script working, this is an older version without the play/pause and bpm on the Norns but
you can set the triggers and it plays through the Volca! If you have a Volca Drum and a 256 Grid and
want to try it out, or if you want to take the code and change it for your set up, it's
[hosted on github](https://github.com/richy486/gridDrum).
"""
    )
  }
}
