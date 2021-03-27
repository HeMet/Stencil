import PathKit
import Spectre
import Stencil
import XCTest

final class InheritanceTests: XCTestCase {
  let path = Path(#file as String) + ".." + "fixtures"
  lazy var loader = FileSystemLoader(paths: [path])
  lazy var environment = Environment(loader: loader)

  func testInheritance() {
    it("can inherit from another template") {
      let template = try self.environment.loadTemplate(name: "child.html")
      try expect(try template.render()) == """
        Super_Header Child_Header
        Child_Body
        """
        .withPlatformNewLine
    }

    it("can inherit from another template inheriting from another template") {
      let template = try self.environment.loadTemplate(name: "child-child.html")
      try expect(try template.render()) == """
        Super_Header Child_Header Child_Child_Header
        Child_Body
        """
        .withPlatformNewLine
    }

    it("can inherit from a template that calls a super block") {
      let template = try self.environment.loadTemplate(name: "child-super.html")
      try expect(try template.render()) == """
        Header
        Child_Body
        """
        .withPlatformNewLine
    }
  }
}

private extension String {
  /*
  Multi-line literals use \n new lines on all Platforms.
  However, by default Git converts new lines of all text files
  in working copy to the platform default which is \r\n for Windows.
  Since the test templates are affected we need to address that
  by making string literals use platform-specific new lines.
  */
  var withPlatformNewLine: String {
    #if os(Windows)
      return replacingOccurrences(of: "\n", with: "\r\n")
    #else
      return self
    #endif
  }
}