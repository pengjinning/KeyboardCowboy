import Carbon
import KeyCodes
import Foundation

final class TypeEngine {
  enum NaturalTyping: TimeInterval {
    case disabled = 0
    case slow = 0.0275
    case medium = 0.0175
    case fast = 0.01
  }

  private let keyboardEngine: KeyboardEngine
  private let store: KeyCodesStore
  private var naturalTyping: NaturalTyping = .fast

  internal init(keyboardEngine: KeyboardEngine, store: KeyCodesStore) {
    self.keyboardEngine = keyboardEngine
    self.store = store
  }

  func run(_ command: TypeCommand) async throws {
    let input = command.input
    let newLines = CharacterSet.newlines

    for character in input {
      if naturalTyping != .disabled {
        let sleepTime = TimeInterval.random(in: 0...naturalTyping.rawValue)
        Thread.sleep(forTimeInterval: sleepTime)
      }
      let string = String(character)
      let charSet = CharacterSet(charactersIn: string)

      guard let virtualKey = store.virtualKey(for: string) else { continue }

      var modifiers = [ModifierKey]()
      let key: String
      if charSet.isSubset(of: newLines) {
        modifiers = []
        key = String(format: "%C", 0x21A9)
      } else {
        key = virtualKey.rawValue
        modifiers = virtualKey.modifiers.compactMap {
          ModifierKey(rawValue: $0.rawValue)
        }
      }

      let command = KeyboardCommand(keyboardShortcut: KeyShortcut(key: key, lhs: true, modifiers: modifiers))
      try keyboardEngine.run(command, type: .keyDown, with: nil)
    }
  }
}