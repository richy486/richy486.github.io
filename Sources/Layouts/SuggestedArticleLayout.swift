//
//  SuggestedArticleLayout.swift
//  IgniteStarter
//
//  Created by Richard Adem on 08/02/2025.
//


import Foundation
import Ignite

struct SuggestedArticleLayout: Layout {
  @Environment(\.content) private var content
  
  var body: some HTML {
    HTMLDocument {
      HTMLHead(for: page)
      
      HTMLBody {
        Grid {
          Section(page.body)
            .width(9)
        }
      }
    }
  }
}
