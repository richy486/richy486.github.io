import Foundation
import Ignite

struct Home: StaticLayout {
  var title = "Home"

  var body: some HTML {
    VStack {
      Image("images/filter.jpg")
        .accessibilityLabel("A simple synth filter module.")
      Text("Projects by Richy")
        .font(.title1)

      Link("Platformer", target: "platformer")
    }
  }
}
