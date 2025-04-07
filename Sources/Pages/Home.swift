import Foundation
import Ignite

struct Home: StaticPage {
  let staticPages: [any BlogPost]
  
  var title = "Projects by Richy"
  
  var body: some HTML {
    Image("images/filter.jpg", description: "A simple synth filter module.")
      .resizable()

    Text(title)
      .font(.title1)
    
    ForEach(staticPages) { post in
        Text {
          Link(post.linkName + " " + post.dateString, target: post.target)
        }
    }
  }
}
