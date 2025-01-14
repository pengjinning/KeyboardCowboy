import Foundation
import MachPort
import CoreGraphics
import KeyCodes

enum KeyboardCommandRunnerError: Error {
  case failedToResolveMachPortController
  case failedToResolveKey(String)
  case failedToCreateKeyCode(Int)
  case failedToCreateEvent
}

final class KeyboardCommandRunner {
  var machPort: MachPortEventController?
  let store: KeyCodesStore

  internal init(store: KeyCodesStore) {
    self.store = store
  }

  func virtualKey(for string: String, modifiers: [VirtualModifierKey] = [], matchDisplayValue: Bool = true) -> VirtualKey? {
    store.virtualKey(for: string, modifiers: modifiers, matchDisplayValue: matchDisplayValue)
  }

  func run(_ keyboardShortcuts: [KeyShortcut],
           type: CGEventType,
           originalEvent: CGEvent?,
           with eventSource: CGEventSource?) throws {
    guard let machPort else {
      throw KeyboardCommandRunnerError.failedToResolveMachPortController
    }

    for keyboardShortcut in keyboardShortcuts {
      let key = try resolveKey(for: keyboardShortcut.key)
      var flags = CGEventFlags()
      keyboardShortcut.modifiers.forEach { flags.insert($0.cgModifierFlags) }
      do {
        var flags = flags
        // In applications like Xcode, we need to set the numeric pad flag for
        // the application to properly respond to arrow key events as if the
        // user used the actual arrow keys to navigate.
        let arrows = 123...126
        if arrows.contains(key) {
          flags.insert(.maskNumericPad)
        }

        try machPort.post(key, type: type, flags: flags) { newEvent in
          if let originalEvent {
            let originalKeyboardEventAutorepeat = originalEvent.getIntegerValueField(.keyboardEventAutorepeat)
            newEvent.setIntegerValueField(.keyboardEventAutorepeat, value: originalKeyboardEventAutorepeat)
          }
        }
      } catch let error {
        throw error
      }
    }
  }

  // MARK: Private methods

  private func resolveKey(for string: String) throws -> Int {
    let uppercased = string.uppercased()

    if let uppercasedResult = store.keyCode(for: uppercased, matchDisplayValue: true) {
      return uppercasedResult
    }
    if let stringResult = store.keyCode(for: string, matchDisplayValue: true) {
      return stringResult
    }

    throw KeyboardCommandRunnerError.failedToResolveKey(string)
  }
}
