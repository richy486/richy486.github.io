import Foundation
import Ignite

@main
struct IgniteWebsite {
  static func main() async {
    let site = ExampleSite()

    do {
      try await site.publish()
    } catch {
      print(error.localizedDescription)
    }
  }
}

struct ExampleSite: Site {
  var name = "Richy"
  var titleSuffix = "Projects and experiments"
  var url = URL(static: "richy486.github.io")
  var builtInIconsEnabled = true

  var author = "John Appleseed"

  var homePage = Home()
  var layout = MainLayout()
}


