@testable import LogicFramework
import Combine
import Cocoa

class KeyboardShortcutControllerMock: KeyboardCommandControlling {
  let result: Result<Void, Error>

  init(_ result: Result<Void, Error>) {
    self.result = result
  }

  func run(_ command: KeyboardCommand) -> CommandPublisher {
    result.publisher.eraseToAnyPublisher()
  }
}