import Ignite

protocol BlogPost: StaticPage {
  var linkName: String { get }
  var target: String { get }
  var dateString: String { get }
}
