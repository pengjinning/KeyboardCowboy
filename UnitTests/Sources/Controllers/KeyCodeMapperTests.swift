@testable import LogicFramework
import XCTest
import Carbon

// swiftlint:disable type_body_length
class KeyCodeMapperTests: XCTestCase {
  enum InputSourceIdentifier: String {
    case abc = "com.apple.keylayout.ABC"
    case english = "com.apple.keylayout.US"
    case swedish = "com.apple.keylayout.Swedish-Pro"
    case norwegian = "com.apple.keylayout.Norwegian"
  }

  var currentInput: InputSource?

  override func setUp() {
    super.setUp()
    currentInput = InputSourceController().currentInputSource()
  }

  override func tearDown() {
    super.tearDown()
    guard let currentInput = currentInput else { return }
    InputSourceController().selectInputSource(id: currentInput.id)
  }

  // swiftlint:disable function_body_length
  func testMapperWithABCLayout() throws {
    let inputController = InputSourceController()
    let id = InputSourceIdentifier.abc.rawValue
    let isInstalledABCKeyboard = inputController.isInstalledInputSource(id: id)
    inputController.installInputSource(id: id)
    defer {
      if isInstalledABCKeyboard == false {
        inputController.uninstallInputSource(id: id)
      }
    }

    guard let inputSource = inputController.selectInputSource(id: id) else {
      XCTFail("Failed to select input source")
      return
    }

    let keycodeMapper = KeyCodeMapper(inputSource: inputSource)
    XCTAssertEqual("\\", try keycodeMapper.map(42, modifiers: 0))
    XCTAssertEqual("-", try keycodeMapper.map(27, modifiers: 0))
    XCTAssertEqual(",", try keycodeMapper.map(43, modifiers: 0))
    XCTAssertEqual("/", try keycodeMapper.map(44, modifiers: 0))
    XCTAssertEqual(".", try keycodeMapper.map(47, modifiers: 0))
    XCTAssertEqual("0", try keycodeMapper.map(29, modifiers: 0))
    XCTAssertEqual("1", try keycodeMapper.map(18, modifiers: 0))
    XCTAssertEqual("2", try keycodeMapper.map(19, modifiers: 0))
    XCTAssertEqual("3", try keycodeMapper.map(20, modifiers: 0))
    XCTAssertEqual("4", try keycodeMapper.map(21, modifiers: 0))
    XCTAssertEqual("5", try keycodeMapper.map(23, modifiers: 0))
    XCTAssertEqual("6", try keycodeMapper.map(22, modifiers: 0))
    XCTAssertEqual("7", try keycodeMapper.map(26, modifiers: 0))
    XCTAssertEqual("8", try keycodeMapper.map(28, modifiers: 0))
    XCTAssertEqual("9", try keycodeMapper.map(25, modifiers: 0))
    XCTAssertEqual("`", try keycodeMapper.map(50, modifiers: 0))
    XCTAssertEqual("A", try keycodeMapper.map(0, modifiers: 0))
    XCTAssertEqual("B", try keycodeMapper.map(11, modifiers: 0))
    XCTAssertEqual("C", try keycodeMapper.map(8, modifiers: 0))
    XCTAssertEqual("D", try keycodeMapper.map(2, modifiers: 0))
    XCTAssertEqual("E", try keycodeMapper.map(14, modifiers: 0))
    XCTAssertEqual("F", try keycodeMapper.map(3, modifiers: 0))
    XCTAssertEqual("G", try keycodeMapper.map(5, modifiers: 0))
    XCTAssertEqual("H", try keycodeMapper.map(4, modifiers: 0))
    XCTAssertEqual("I", try keycodeMapper.map(34, modifiers: 0))
    XCTAssertEqual("J", try keycodeMapper.map(38, modifiers: 0))
    XCTAssertEqual("K", try keycodeMapper.map(40, modifiers: 0))
    XCTAssertEqual("L", try keycodeMapper.map(37, modifiers: 0))
    XCTAssertEqual("M", try keycodeMapper.map(46, modifiers: 0))
    XCTAssertEqual("N", try keycodeMapper.map(45, modifiers: 0))
    XCTAssertEqual("O", try keycodeMapper.map(31, modifiers: 0))
    XCTAssertEqual("P", try keycodeMapper.map(35, modifiers: 0))
    XCTAssertEqual("Q", try keycodeMapper.map(12, modifiers: 0))
    XCTAssertEqual("R", try keycodeMapper.map(15, modifiers: 0))
    XCTAssertEqual("S", try keycodeMapper.map(1, modifiers: 0))
    XCTAssertEqual("T", try keycodeMapper.map(17, modifiers: 0))
    XCTAssertEqual("U", try keycodeMapper.map(32, modifiers: 0))
    XCTAssertEqual("V", try keycodeMapper.map(9, modifiers: 0))
    XCTAssertEqual("W", try keycodeMapper.map(13, modifiers: 0))
    XCTAssertEqual("X", try keycodeMapper.map(7, modifiers: 0))
    XCTAssertEqual("Y", try keycodeMapper.map(16, modifiers: 0))
    XCTAssertEqual("Z", try keycodeMapper.map(6, modifiers: 0))
    XCTAssertEqual("§", try keycodeMapper.map(10, modifiers: 0))
    XCTAssertEqual("]", try keycodeMapper.map(30, modifiers: 0))
    XCTAssertEqual("=", try keycodeMapper.map(24, modifiers: 0))
    XCTAssertEqual("'", try keycodeMapper.map(39, modifiers: 0))
    XCTAssertEqual("[", try keycodeMapper.map(33, modifiers: 0))
    XCTAssertEqual(";", try keycodeMapper.map(41, modifiers: 0))
  }

  // swiftlint:disable function_body_length
  func testMapperWithSwedishLayout() throws {
    let inputController = InputSourceController()
    let id = InputSourceIdentifier.swedish.rawValue
    let isInstalledABCKeyboard = inputController.isInstalledInputSource(id: id)
    inputController.installInputSource(id: id)
    defer {
      if isInstalledABCKeyboard == false {
        inputController.uninstallInputSource(id: id)
      }
    }

    guard let inputSource = inputController.selectInputSource(id: id) else {
      XCTFail("Failed to select input source")
      return
    }

    let keycodeMapper = KeyCodeMapper(inputSource: inputSource)
    XCTAssertEqual("'", try keycodeMapper.map(42, modifiers: 0))
    XCTAssertEqual("+", try keycodeMapper.map(27, modifiers: 0))
    XCTAssertEqual(",", try keycodeMapper.map(43, modifiers: 0))
    XCTAssertEqual("-", try keycodeMapper.map(44, modifiers: 0))
    XCTAssertEqual(".", try keycodeMapper.map(47, modifiers: 0))
    XCTAssertEqual("0", try keycodeMapper.map(29, modifiers: 0))
    XCTAssertEqual("1", try keycodeMapper.map(18, modifiers: 0))
    XCTAssertEqual("2", try keycodeMapper.map(19, modifiers: 0))
    XCTAssertEqual("3", try keycodeMapper.map(20, modifiers: 0))
    XCTAssertEqual("4", try keycodeMapper.map(21, modifiers: 0))
    XCTAssertEqual("5", try keycodeMapper.map(23, modifiers: 0))
    XCTAssertEqual("6", try keycodeMapper.map(22, modifiers: 0))
    XCTAssertEqual("7", try keycodeMapper.map(26, modifiers: 0))
    XCTAssertEqual("8", try keycodeMapper.map(28, modifiers: 0))
    XCTAssertEqual("9", try keycodeMapper.map(25, modifiers: 0))
    XCTAssertEqual("<", try keycodeMapper.map(50, modifiers: 0))
    XCTAssertEqual("A", try keycodeMapper.map(0, modifiers: 0))
    XCTAssertEqual("B", try keycodeMapper.map(11, modifiers: 0))
    XCTAssertEqual("C", try keycodeMapper.map(8, modifiers: 0))
    XCTAssertEqual("D", try keycodeMapper.map(2, modifiers: 0))
    XCTAssertEqual("E", try keycodeMapper.map(14, modifiers: 0))
    XCTAssertEqual("F", try keycodeMapper.map(3, modifiers: 0))
    XCTAssertEqual("G", try keycodeMapper.map(5, modifiers: 0))
    XCTAssertEqual("H", try keycodeMapper.map(4, modifiers: 0))
    XCTAssertEqual("I", try keycodeMapper.map(34, modifiers: 0))
    XCTAssertEqual("J", try keycodeMapper.map(38, modifiers: 0))
    XCTAssertEqual("K", try keycodeMapper.map(40, modifiers: 0))
    XCTAssertEqual("L", try keycodeMapper.map(37, modifiers: 0))
    XCTAssertEqual("M", try keycodeMapper.map(46, modifiers: 0))
    XCTAssertEqual("N", try keycodeMapper.map(45, modifiers: 0))
    XCTAssertEqual("O", try keycodeMapper.map(31, modifiers: 0))
    XCTAssertEqual("P", try keycodeMapper.map(35, modifiers: 0))
    XCTAssertEqual("Q", try keycodeMapper.map(12, modifiers: 0))
    XCTAssertEqual("R", try keycodeMapper.map(15, modifiers: 0))
    XCTAssertEqual("S", try keycodeMapper.map(1, modifiers: 0))
    XCTAssertEqual("T", try keycodeMapper.map(17, modifiers: 0))
    XCTAssertEqual("U", try keycodeMapper.map(32, modifiers: 0))
    XCTAssertEqual("V", try keycodeMapper.map(9, modifiers: 0))
    XCTAssertEqual("W", try keycodeMapper.map(13, modifiers: 0))
    XCTAssertEqual("X", try keycodeMapper.map(7, modifiers: 0))
    XCTAssertEqual("Y", try keycodeMapper.map(16, modifiers: 0))
    XCTAssertEqual("Z", try keycodeMapper.map(6, modifiers: 0))
    XCTAssertEqual("§", try keycodeMapper.map(10, modifiers: 0))
    XCTAssertEqual("¨", try keycodeMapper.map(30, modifiers: 0))
    XCTAssertEqual("´", try keycodeMapper.map(24, modifiers: 0))
    XCTAssertEqual("Ä", try keycodeMapper.map(39, modifiers: 0))
    XCTAssertEqual("Å", try keycodeMapper.map(33, modifiers: 0))
    XCTAssertEqual("Ö", try keycodeMapper.map(41, modifiers: 0))
  }

  // swiftlint:disable function_body_length
  func testMapperWithNorwegianLayout() throws {
    let inputController = InputSourceController()
    let id = InputSourceIdentifier.norwegian.rawValue
    let isInstalledABCKeyboard = inputController.isInstalledInputSource(id: id)
    inputController.installInputSource(id: id)
    defer {
      if isInstalledABCKeyboard == false {
        inputController.uninstallInputSource(id: id)
      }
    }

    guard let inputSource = inputController.selectInputSource(id: id) else {
      XCTFail("Failed to select input source")
      return
    }

    let keycodeMapper = KeyCodeMapper(inputSource: inputSource)
    XCTAssertEqual("@", try keycodeMapper.map(42, modifiers: 0))
    XCTAssertEqual("+", try keycodeMapper.map(27, modifiers: 0))
    XCTAssertEqual(",", try keycodeMapper.map(43, modifiers: 0))
    XCTAssertEqual("-", try keycodeMapper.map(44, modifiers: 0))
    XCTAssertEqual(".", try keycodeMapper.map(47, modifiers: 0))
    XCTAssertEqual("0", try keycodeMapper.map(29, modifiers: 0))
    XCTAssertEqual("1", try keycodeMapper.map(18, modifiers: 0))
    XCTAssertEqual("2", try keycodeMapper.map(19, modifiers: 0))
    XCTAssertEqual("3", try keycodeMapper.map(20, modifiers: 0))
    XCTAssertEqual("4", try keycodeMapper.map(21, modifiers: 0))
    XCTAssertEqual("5", try keycodeMapper.map(23, modifiers: 0))
    XCTAssertEqual("6", try keycodeMapper.map(22, modifiers: 0))
    XCTAssertEqual("7", try keycodeMapper.map(26, modifiers: 0))
    XCTAssertEqual("8", try keycodeMapper.map(28, modifiers: 0))
    XCTAssertEqual("9", try keycodeMapper.map(25, modifiers: 0))
    XCTAssertEqual("<", try keycodeMapper.map(50, modifiers: 0))
    XCTAssertEqual("A", try keycodeMapper.map(0, modifiers: 0))
    XCTAssertEqual("B", try keycodeMapper.map(11, modifiers: 0))
    XCTAssertEqual("C", try keycodeMapper.map(8, modifiers: 0))
    XCTAssertEqual("D", try keycodeMapper.map(2, modifiers: 0))
    XCTAssertEqual("E", try keycodeMapper.map(14, modifiers: 0))
    XCTAssertEqual("F", try keycodeMapper.map(3, modifiers: 0))
    XCTAssertEqual("G", try keycodeMapper.map(5, modifiers: 0))
    XCTAssertEqual("H", try keycodeMapper.map(4, modifiers: 0))
    XCTAssertEqual("I", try keycodeMapper.map(34, modifiers: 0))
    XCTAssertEqual("J", try keycodeMapper.map(38, modifiers: 0))
    XCTAssertEqual("K", try keycodeMapper.map(40, modifiers: 0))
    XCTAssertEqual("L", try keycodeMapper.map(37, modifiers: 0))
    XCTAssertEqual("M", try keycodeMapper.map(46, modifiers: 0))
    XCTAssertEqual("N", try keycodeMapper.map(45, modifiers: 0))
    XCTAssertEqual("O", try keycodeMapper.map(31, modifiers: 0))
    XCTAssertEqual("P", try keycodeMapper.map(35, modifiers: 0))
    XCTAssertEqual("Q", try keycodeMapper.map(12, modifiers: 0))
    XCTAssertEqual("R", try keycodeMapper.map(15, modifiers: 0))
    XCTAssertEqual("S", try keycodeMapper.map(1, modifiers: 0))
    XCTAssertEqual("T", try keycodeMapper.map(17, modifiers: 0))
    XCTAssertEqual("U", try keycodeMapper.map(32, modifiers: 0))
    XCTAssertEqual("V", try keycodeMapper.map(9, modifiers: 0))
    XCTAssertEqual("W", try keycodeMapper.map(13, modifiers: 0))
    XCTAssertEqual("X", try keycodeMapper.map(7, modifiers: 0))
    XCTAssertEqual("Y", try keycodeMapper.map(16, modifiers: 0))
    XCTAssertEqual("Z", try keycodeMapper.map(6, modifiers: 0))
    XCTAssertEqual("'", try keycodeMapper.map(10, modifiers: 0))
    XCTAssertEqual("¨", try keycodeMapper.map(30, modifiers: 0))
    XCTAssertEqual("´", try keycodeMapper.map(24, modifiers: 0))
    XCTAssertEqual("Æ", try keycodeMapper.map(39, modifiers: 0))
    XCTAssertEqual("Å", try keycodeMapper.map(33, modifiers: 0))
    XCTAssertEqual("Ø", try keycodeMapper.map(41, modifiers: 0))
  }

  func testMapperMappingFKeys() throws {
    let keycodeMapper = KeyCodeMapper()
    XCTAssertEqual("F1", try keycodeMapper.map(kVK_F1, modifiers: 0))
    XCTAssertEqual("F2", try keycodeMapper.map(kVK_F2, modifiers: 0))
    XCTAssertEqual("F3", try keycodeMapper.map(kVK_F3, modifiers: 0))
    XCTAssertEqual("F4", try keycodeMapper.map(kVK_F4, modifiers: 0))
    XCTAssertEqual("F5", try keycodeMapper.map(kVK_F5, modifiers: 0))
    XCTAssertEqual("F6", try keycodeMapper.map(kVK_F6, modifiers: 0))
    XCTAssertEqual("F7", try keycodeMapper.map(kVK_F7, modifiers: 0))
    XCTAssertEqual("F8", try keycodeMapper.map(kVK_F8, modifiers: 0))
    XCTAssertEqual("F9", try keycodeMapper.map(kVK_F9, modifiers: 0))
    XCTAssertEqual("F10", try keycodeMapper.map(kVK_F10, modifiers: 0))
    XCTAssertEqual("F11", try keycodeMapper.map(kVK_F11, modifiers: 0))
    XCTAssertEqual("F12", try keycodeMapper.map(kVK_F12, modifiers: 0))
    XCTAssertEqual("F13", try keycodeMapper.map(kVK_F13, modifiers: 0))
    XCTAssertEqual("F14", try keycodeMapper.map(kVK_F14, modifiers: 0))
    XCTAssertEqual("F15", try keycodeMapper.map(kVK_F15, modifiers: 0))
    XCTAssertEqual("F16", try keycodeMapper.map(kVK_F16, modifiers: 0))
    XCTAssertEqual("F17", try keycodeMapper.map(kVK_F17, modifiers: 0))
    XCTAssertEqual("F18", try keycodeMapper.map(kVK_F18, modifiers: 0))
    XCTAssertEqual("F19", try keycodeMapper.map(kVK_F19, modifiers: 0))
    XCTAssertEqual("F20", try keycodeMapper.map(kVK_F20, modifiers: 0))
  }

  func testMapperMappingSpecialKeys() throws {
    let keycodeMapper = KeyCodeMapper()
    XCTAssertEqual("Space", try keycodeMapper.map(kVK_Space, modifiers: 0))
    XCTAssertEqual("⌫", try keycodeMapper.map(kVK_Delete, modifiers: 0))
    XCTAssertEqual("⌦", try keycodeMapper.map(kVK_ForwardDelete, modifiers: 0))
    XCTAssertEqual("⌧", try keycodeMapper.map(kVK_ANSI_Keypad0, modifiers: 0))
    XCTAssertEqual("←", try keycodeMapper.map(kVK_LeftArrow, modifiers: 0))
    XCTAssertEqual("→", try keycodeMapper.map(kVK_RightArrow, modifiers: 0))
    XCTAssertEqual("↑", try keycodeMapper.map(kVK_UpArrow, modifiers: 0))
    XCTAssertEqual("↓", try keycodeMapper.map(kVK_DownArrow, modifiers: 0))
    XCTAssertEqual("↘", try keycodeMapper.map(kVK_End, modifiers: 0))
    XCTAssertEqual("↖", try keycodeMapper.map(kVK_Home, modifiers: 0))
    XCTAssertEqual("⎋", try keycodeMapper.map(kVK_Escape, modifiers: 0))
    XCTAssertEqual("⇟", try keycodeMapper.map(kVK_PageDown, modifiers: 0))
    XCTAssertEqual("⇞", try keycodeMapper.map(kVK_PageUp, modifiers: 0))
    XCTAssertEqual("↩", try keycodeMapper.map(kVK_Return, modifiers: 0))
    XCTAssertEqual("⌅", try keycodeMapper.map(kVK_ANSI_KeypadEnter, modifiers: 0))
    XCTAssertEqual("⇥", try keycodeMapper.map(kVK_Tab, modifiers: 0))
    XCTAssertEqual("?⃝", try keycodeMapper.map(kVK_Help, modifiers: 0))
  }
}