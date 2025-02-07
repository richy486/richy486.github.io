import Foundation
import Ignite

struct Home: StaticLayout {
  var title = "Home"

  var body: some HTML {
    Text("Hello, how are you?")
      .font(.title1)
  }
}
