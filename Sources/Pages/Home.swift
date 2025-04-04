import Foundation
import Ignite

struct Home: StaticPage {
  var title = "Projects by Richy"
  
  var body: some HTML {
    Image("images/filter.jpg", description: "A simple synth filter module.")
      .resizable()

    Text(title)
      .font(.title1)

    Link("Platformer", target: "platformer")
  }
}
