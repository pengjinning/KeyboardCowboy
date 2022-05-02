import Cocoa

final class MenubarController {
  private static var applicationName = ProcessInfo.processInfo.processName
  private let applicationStore: ApplicationStore

  enum ApplicationState {
    case active, inactive

    var iconName: String {
      switch self {
      case .active: return "Menubar_active"
      case .inactive: return "Menubar_inactive"
      }
    }
  }

  var menu: NSMenu
  var statusItem: NSStatusItem

  init(_ applicationStore: ApplicationStore) {
    let statusBar = NSStatusBar.system
    let statusItem = statusBar.statusItem(withLength: NSStatusItem.squareLength)
    statusItem.button?.image = NSImage(named: ApplicationState.inactive.iconName)
    statusItem.button?.toolTip = Self.applicationName
    statusItem.button?.isEnabled = true

    self.applicationStore = applicationStore
    self.statusItem = statusItem
    self.menu = NSMenu()

    statusItem.menu = menu

    menu.addItem(createMenuItem("Open \(Self.applicationName)", action: #selector(openApplication(_:))))
    menu.addItem(NSMenuItem.separator())
    menu.addItem(createMenuItem("Check for Updates…", action: #selector(checkForUpdates(_:))))
    menu.addItem(createMenuItem("Provide feedback…", action: #selector(feedback(_:))))
    menu.addItem(NSMenuItem.separator())
    menu.addItem(NSMenuItem(title: "About \(Self.applicationName)",
                            action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)),
                            keyEquivalent: ""))
    menu.addItem(NSMenuItem(title: "Quit",
                            action: #selector(NSApplication.shared.terminate(_:)),
                            keyEquivalent: "q"))
  }

  // MARK: Public methods

  func setState(_ newState: ApplicationState) {
    statusItem.button?.image = NSImage(named: newState.iconName)
  }

  // MARK: Actions

  @objc func openApplication(_ menuItem: NSMenuItem) {
    guard let application = applicationStore.application(for: Bundle.main.bundleIdentifier!) else {
      return
    }
    Task {
      try? await ApplicationCommandEngine(windowListStore: WindowListStore(),
                                          workspace: NSWorkspace.shared)
      .run(.init(application: application))
    }
  }

  @objc func feedback(_ menuItem: NSMenuItem) {
    NSWorkspace.shared.open(URL(string: "https://github.com/zenangst/KeyboardCowboy/issues/new")!)
  }

  @objc func checkForUpdates(_ menuItem: NSMenuItem) {
//    SUUpdater.shared()?.checkForUpdates(menuItem)
  }

  // MARK: - Private methods

  fileprivate func createMenuItem(_ title: String, action: Selector, keyEquivalent: String = "") -> NSMenuItem {
    let menuItem = NSMenuItem(title: title, action: action, keyEquivalent: keyEquivalent)
    menuItem.target = self
    return menuItem
  }
}