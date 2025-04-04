//
//  Platformer.swift
//  IgniteStarter
//
//  Created by Richard Adem on 07/02/2025.
//

import Foundation
import Ignite

struct Platformer: StaticPage {
  var title = "Platformer game on Embedded Swift with Playdate Kit"

  var parentLayout = SuggestedArticleLayout()

  var body: some HTML {
    Text(title)
      .font(.title1)
    Section {
      Image("https://res.cloudinary.com/dxhxohuwc/image/upload/t_512x512/v1738924343/platformer_square_xicjne.jpg",
            description: "The Playdate running a version of the Platformer game")
      .resizable()

      Text(markdown:
      """
      When Swift announced that it was [supporting embedded systems](https://www.swift.org/getting-started/embedded-swift/)
      and [supporting the Playdate](https://www.swift.org/blog/byte-sized-swift-tiny-games-playdate/) 
      I wanted to try it out myself. I already had a Playdate and I had tried [Pulp](https://play.date/pulp) before. 
      <br>First I built some simple games with the [Apple Swift-Playdate examples](https://github.com/apple/swift-playdate-examples)
      , then i discovered [PlaydateKit](https://github.com/finnvoor/PlaydateKit) which is a fantastic
      , easy to use library.
      """)

      Text("Platformer game experiment")
        .font(.title3)

      Image("https://res.cloudinary.com/dxhxohuwc/image/upload/v1739002060/platformer-pig_gif.gif",
            description: "Platformer game in SpriteKit, player picking up a pig and dropping it")
      .resizable()

      Text(markdown:
      """
      Before my first child was born I built a little [platformer game experiment](https://github.com/richy486/Platformer) 
      in Swift with [SpriteKit](https://developer.apple.com/documentation/spritekit/) trying to replicate 
      the Mario games, I was heavily influenced by [Super Mario War](https://github.com/mmatyas/supermariowar) by Florian Hufsky 
      as well as the jumping from the original Super Mario Bros assembly code. It wasn't a "game" 
      with levels and goals etc. more a learning experience project that a game could be built on later.
      <br>
      <br>The game had the following features:
      - Sloped tiles
      - Breakable blocks
      - Item boxes
      - Bouncing items (like turtle shells)
      - Items can be picked up
      - Items can be collected
      - Jump up through platforms
      - Glide over gaps when running
      - Lerping camera
      - In game level editor
      - Javascript reader to extend the game from the Swift code
      - Quake like console for entering commands
      
      And probably some others I have forgotten.
      """)
    }
    Section {
      Text("Five years later...")
        .font(.title3)

      Text(markdown:
      """
      Fast forward five years and I'm looking through some of my old games with my five year old son 
      over the holiday break and I come across the Platformer game, he immediately dives in and
      starts making levels for the game! I think, wouldn't it be great to play those levels on the
      Playdate and show the rest of the family, so while he is building levels I start looking at
      building the game on the Playdate.
      """)

      Text(markdown:
      """
      I find out that I had already separated the code into the Platformer system and the game play 
      / UI, this makes everything much easier because the SpriteKit part is can be replaced with 
      another library for rendering.
      """)

      Text(markdown:
      """
      Currently, to build Embedded Swift you need to build with a recent [nightly Swift toolchain](https://www.swift.org/download/#snapshots).
      Since Core Graphics isn't included in Swift Embedded, I start 
      replacing `CGPoint` with a simple `Point` struct and replace `CGFloat` with `Double`, these
      kind of changes will come up a lot in this project.
      """)

      Text(markdown:
      """
      I soon discoverd the library [PlaydateKit](https://github.com/finnvoor/PlaydateKit) which is 
      really easy to use for different game projects where Apple's example is more of an example of
      what can be done. 
      But the first issue I found was that I couldn’t import the Platformer System into the Play Date
      kit project because it isn't an OSSA module and also the SPM setup of Platdate Kit is for the 
      build system, adding dependencies to the `Package.swift` file doesn't add them to your game project,
      it's adding them to the Platdate build system for Swift.
           
      I tried to just use a symlink but the folder it showed up as a 
      "chain" icon and i couldn’t see the files. The structure of Swift Package Manager projects 
      doesn't allow inclusion of folders ouside the `Source` folder so I couldn't add a local package 
      from higher up the folder hierarchy. I ended up just copying the files into the Playdate project
      to get started.
      """)

      Text(markdown:
      """
      Next I removed all instances of `import Foundation`, luckily PlaydateKit has a lot of 
      functions found inFoundation functions such as `sin`, `cos`, `pow` and `sqrt`. I removed 
      `String(format:)` and uses of `NotificationCenter` and fixed some Swift 6 concurrency issues. 
      I made some of the classes final that had generic functions and kept going through the errors.
      Sometimes errors show up but go away if you fix another error.
      """)

      Text("Cannot do dynamic casting in embedded Swift on...")
        .font(.title3)

      Text(markdown:
      """
      The next issue was that Embedded Swift can't do dynamic casting to protocols so I changed the
      `Actor` which is all things that move in the game from a type alias protocol collection to a 
      regular class that other actors inherit from. This is a bit more like regular object oriented
      game programming. I also moved some functions out of extensions and they became overrides of 
      `Actor` functions.
      """)

      Text(markdown:
      """
      I turned off the actors and hooked up the tile rendering to Playdate Kit. I drew new sprites
      in black and white for the Playdate and named the sprite sheet `blocks-table-16-16.png` so it 
      loads sprites that are 16x16 pixels. This was a problem because I had hard coded the 
      Platformer system to be 32x32 pixels, so on the Playdate side I halved all the sizes and 
      positions, this is something that needs to be fixed by setting the tile size at launch.
      """)

      Text(markdown:
      """
      I had some helper variables that give the position of tiles as integers as well as floats, 
      these were two separate variables, looking back, I'm not sure why I did this, and now it was 
      causing problems with the layout of the tiles. I changed this so that there is a computed 
      value for the integers from the float value.
      """)

      Image("https://res.cloudinary.com/dxhxohuwc/image/upload/t_512_fill/v1739031315/platformer-blocks.png",
            description: "Platformer game running on Playdate with the blocks only.")
      .resizable()

      Text(markdown:
      """
      Some `Actors` conform to `Droppable`, meaning they have function they can call if the object 
      is dropped by another `Actor`, e.g. a `Box` that was picked up by the `Player` then dropped. 
      A problem was when checking if an dropped object is `Droppable` before called `drop()` e.g. 
      `if let dropableAttachable = attachable as? Droppable` gives the **Cannot do dynamic casting 
      in embedded Swift** error. Fixed this by a more object oriented approach by moving the `Drop`
      function to be part of `Actor` and `Actor`s that can’t be picked up have empty drop functions.
      """)

      Text(markdown:
      """
      This was the same with merging two dictionaries of type `[UUID: Actor]`, instead I just
      replaced the merge with a loop to add them together.
      """)

      Text("Replacing Notification Center")
        .font(.title3)

      Text(markdown:
      """
      In the original implementation, when something changes the level a Notification Center 
      notification is sent out from anywhere in the code to trigger the map to update. Notification 
      Center is obviously not available in Embedded Swift so I has to come up with a different 
      solution. 
      """)

      Text(markdown:
      """
      I made an `Observer` class, how it works is the main `Game` class sets up an `update` closure
      via the `setupUpdate` function from the `Observer`, this `update` closure updates the map when
      triggered. The `setupUpdate` function sets a `sendUpdate` closure that can be called from
      anywhere else in the codebase. So somewhere else in the game, e.g. the character hits a block 
      and destroys it, then the `Observer`'s `sendUpdate` is called which triggers the `update` 
      close in the main `Game` class.
      """)

      CodeBlock(.swift) {
      """
      // Pseudocode:
      
      Game.init {
        Observer.setupUpdate {
          // Update closure
          self.updateMap() 
        }
      }
      
      Collision.blockDestroyed { Observer.sendUpdate } 
      """
      }

      Text(markdown:
      """
      To update the tiles the `setupUpdate` closure needs to reference `self`. Normally I would use
      the `[weak self] in` pattern to avoid capturing self but the `weak` attribute isn't available
      on Embedded Swift. I tried to use a combination of `withUnsafePointer` with `unsafeBitCast` 
      when calling the closure and passing the reference to `self`.
      """)

      CodeBlock(.swift) {
      """
      withUnsafePointer(to: from) { unsafeFrom in
        self.update = { package in
          let fromCast = unsafeBitCast(unsafeFrom, to: T.self)
          update(package, fromCast)
        }
      }
      """
      }

      Text(markdown:
      """
      This was not the right combination as updating the map from here would cause a crash, and 
      looking at the addresses to self and what the unsafe pointer is pointing to they are 
      different even when using `unsafeFrom.pointee`.
      <br>
      <br>orig: 105553151664832
      <br>unsafe pointer: 4294967297      
      """)

      Text(markdown:
      """
      I tried just using `unsafeBitCast`
      """)

      CodeBlock(.swift) {
      """
      let unsafeSelf = unsafeBitCast(from, to: Int.self)
      self.update = { package in
        let fromCast = unsafeBitCast(unsafeSelf, to: T.self)
        update(package, fromCast)
      }
      """
      }

      Text(markdown:
      """
      Doesn’t crash, and the pointers are the same too:
      <br>
      <br>orig: 105553147994432
      <br>unsafe pointer: 105553147994432
      """)

      Text(markdown:
      """
      I'm not sure if the lifetime of `unsafeSelf` is guaranteed, it’s created on the init of `Game`
      (with an instance of Game) and cast back to `Game` in the closure when an update arrives. So
      I'm hoping in this case it wont be invalid until the game quits. Now the call to `setupUpdate`
      (inside the main `Game` class) looks something like this:
      """)

      CodeBlock(.swift) {
      """
      Observer.shared.setupUpdate(from: self) { package, aSelf in
        switch package.message {
          case Constants.kNotificationMapChange:
            aSelf.background.mapChange(point: package.point, 
                                       tileType: package.tileType)
          default: 
            break
        }
      }
      """
      }

      Text(markdown:
      """
      With the `observer` hooked up, I added the controls back in and player can now jump around and
      break bricks.
      """)

      Image("https://res.cloudinary.com/dxhxohuwc/image/upload/v1739097137/platformer-tiles-change_ddhj6d.gif",
            description: "Platformer with player jumping and hitting blocks.")
      .resizable()
      .frame(width: 512)

      Text(markdown:
      """
      The game started to crash when I hooked up the camera, this turned out to be a classic divide 
      by zero error that was in the old platformer code.
      """)

      Image("https://res.cloudinary.com/dxhxohuwc/image/upload/v1739098082/platformer-camera_ntkn0i.gif",
            description: "Platformer with the camera moving along with the player.")
      .resizable()

      Text(markdown:
      """
      Now the game is playable on the Playdate! I can build and run it on the Platdate simulator or take 
      the zipped .pdx file and [side load](https://help.play.date/games/sideloading/) it to a physical device.
      """)

    }
    Section {
      Text("Porting back to Sprite Kit")
        .font(.title3)

      Text(markdown:
      """
      After getting it to run on the Playdate I wanted to get it running again with Sprite Kit, this 
      involved hooking up the new `Observer` class on the Sprite Kit side and since I had trouble linking the Platformer 
      system to the Playdate project I just made a script to copy the code form the Platformer 
      system folder to the Playdate project, which is not ideal but works. The `PlaydateKit` imports
      are wrapped in a `#if canImport(PlaydateKit)` macro otherwise it uses `Foundation`.
      """)

      Text(markdown:
      """
      After getting it to run on the Playdate I had to get it to run again with Sprite Kit, this 
      involved hooking up the new `Observer` class and since I had trouble linking the Platformer 
      system to the Playdate project I just made a script to copy the code form the Platformer 
      system folder to the Playdate project, which is not ideal but works. The `PlaydateKit` imports
      are wrapped in a `#if canImport(PlaydateKit)` macro otherwise it uses `Foundation`.
      """)

      Text(markdown:
      """
      While I was getting this running on the Playdate my son was working on levels using the level 
      editor that was built into the older macOS version of the game.
      """)

      Image("https://res.cloudinary.com/dxhxohuwc/image/upload/c_crop,w_1600,h_1000/v1739310866/Screenshot_2025-02-11_at_22.53.36_nc9hom.png",
            description: "Platformer with built in level editor on macOS.")
      .resizable()
      .frame(width: 512)

      Text(markdown:
      """
      I loaded up the new level on 
      and side loaded the game on the play date. We had to remove some of the items because it was 
      slowing the Playdate down, this could probably be fixed with some "chunking" of the levels.
      """)

      Embed(title: "Video", url: URL(string: "https://player.cloudinary.com/embed/?public_id=IMG_7504_jerz52&cloud_name=dxhxohuwc&profile=cld-default")!)
        .aspectRatio(.r4x3)

      Text(markdown:
      """
      So now it's running on the Playdate, it run a bit slow, and there is no "world map" to change 
      levels. Over all it was a great challenge to work within the constraints of Embedded Swift and
      very rewarding to work with my son on a game I started just before he was born, we are both
      excited to add more levels and more things for the player to do!
      """)

      Text(markdown:
      """
      If you want to check out the game on Platdate or the original Sprite kit version it's available
      in the [platformer game repo](https://github.com/richy486/Platformer) on GitHub
      """)
    }
  }
}


