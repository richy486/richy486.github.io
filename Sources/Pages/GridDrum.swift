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
for each instrument (and starting at index 1!) 
"""
    )
  }
}
