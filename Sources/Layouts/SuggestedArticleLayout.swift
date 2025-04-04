//
//  SuggestedArticleLayout.swift
//  IgniteStarter
//
//  Created by Richard Adem on 08/02/2025.
//


import Foundation
import Ignite

struct SuggestedArticleLayout: Layout {
  var body: some HTML {
    Body {
      Grid {
        content
          .width(9)
        IgniteFooter()
      }
    }
  }
}
