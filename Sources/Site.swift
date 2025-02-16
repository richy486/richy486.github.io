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
#if DEBUG
  var url = URL(static: "http://localhost:8000")
#else
  var url = URL(static: "richy486.github.io")
#endif
  var builtInIconsEnabled = true
  var feedConfiguration = FeedConfiguration(mode: .full, contentCount: 20, image: .init(url: "https://www.yoursite.com/images/icon32.png", width: 32, height: 32))
  var syntaxHighlighters: [HighlighterLanguage] = [.swift]
  var author = "Richy"

  var homePage = Home()
  var layout = MainLayout()

  var staticLayouts: [any StaticLayout] {
    Platformer()
  }
}


