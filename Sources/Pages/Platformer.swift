//
//  Platformer.swift
//  IgniteStarter
//
//  Created by Richard Adem on 07/02/2025.
//

import Foundation
import Ignite

struct Platformer: StaticLayout {
  var title = "Platformer game on Embedded Swift with Play Date Kit"

  var parentLayout = SuggestedArticleLayout()

  var body: some HTML {
    Text(title)
      .font(.title1)
    Section {
      
      Image("https://res.cloudinary.com/dxhxohuwc/image/upload/t_512x512/v1738924343/platformer_square_xicjne.jpg",
//        "https://res.cloudinary.com/dxhxohuwc/image/upload/v1738924343/platformer_square_xicjne.jpg",
        description: "The Playdate running a version of the platformer game")
      .resizable()

      Text(markdown:
      """
      When Swift announced that it was [supporting embedded systems](https://www.swift.org/getting-started/embedded-swift/)
      and [supporting the Playdate](https://www.swift.org/blog/byte-sized-swift-tiny-games-playdate/) 
      I wanted to try it out myself. I already had a Playdate and I had tried [Pulp](https://play.date/pulp) before. 
      <br>First I build some simple games with the [Apple Swift-Playdate examples](https://github.com/apple/swift-playdate-examples)
      , then i discovered [PlaydateKit](https://github.com/finnvoor/PlaydateKit) which is a fantastic
      , easy to use library.
      """)
      Image("https://res.cloudinary.com/dxhxohuwc/image/upload/v1739002060/platformer-pig_gif.gif",
        description: "Platformer game in SpriteKit, player picking up a pig and dropping it")
      .resizable()

      Text(markdown:
      """
      Before my first child was born I built a little platformer game experiment in Swift with [SpriteKit](https://developer.apple.com/documentation/spritekit/)...
      """)

      //       <br>![]()
    }
  }
}
