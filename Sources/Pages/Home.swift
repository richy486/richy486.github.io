import Foundation
import Ignite

struct Home: StaticLayout {
  var title = "Home"

  var body: some HTML {
    VStack {
      Text("Projects by Richy")
        .font(.title1)
    }
  }
}
