import Cocoa
import DirectoryObserver
import LaunchArguments
import LogicFramework
import SwiftUI
import ViewKit

let sourceRoot = ProcessInfo.processInfo.environment["SOURCE_ROOT"]!
let launchArguments = LaunchArgumentsController<LaunchArgument>()

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate, GroupsFeatureControllerDelegate {
  weak var window: NSWindow? {
    willSet { window?.close() }
  }
  var shouldOpenMainWindow = launchArguments.isEnabled(.openWindowAtLaunch)
  var coreController: CoreControlling?
  let factory = ControllerFactory()
  var groupFeatureController: GroupsFeatureController?
  var viewModelFactory = ViewModelMapperFactory()
  var workflowFeatureController: WorkflowFeatureController?
  var directoryObserver: DirectoryObserver?

  var storageController: StorageControlling {
    let path: String
    let fileName: String

    if launchArguments.isEnabled(.demoMode) {
      path = sourceRoot
      fileName = "keyboard-cowboy.json"
    } else {
      path = "~"
      fileName = ".keyboard-cowboy.json"
    }

    return factory.storageController(path: path, fileName: fileName)
  }

  func applicationDidFinishLaunching(_ notification: Notification) {
    if launchArguments.isEnabled(.runningUnitTests) { return }
    if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != nil { return }
    runApplication()
  }

  func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    if window == nil, let coreController = coreController {
      createAndOpenWindow(coreController)
    }
    return true
  }

  func applicationWillBecomeActive(_ notification: Notification) {
    if shouldOpenMainWindow, window == nil,
       let coreController = coreController {
      createAndOpenWindow(coreController)
    }

    shouldOpenMainWindow = true
  }

  private func createAndOpenWindow(_ coreController: CoreControlling) {
    let window = createMainWindow(coreController)
    window?.makeKeyAndOrderFront(NSApp)
    self.window = window
  }

  private func runApplication() {
    do {
      let launchController = AppDelegateLaunchController()
      let controller = try launchController.initialLoad(storageController: storageController)
      self.coreController = controller

    } catch let error {
      AppDelegateErrorController.handle(error)
    }
  }

  private func createMainWindow(_ coreController: CoreControlling) -> NSWindow? {
    let userSelection  = UserSelection()
    let featureFactory = FeatureFactory(coreController: coreController,
                                        userSelection: userSelection)
    let groupFeatureController = featureFactory.groupFeature()
    groupFeatureController.delegate = self

    let workflowFeatureController = featureFactory.workflowFeature()
    workflowFeatureController.delegate = groupFeatureController

    let commandsController = featureFactory.commandsFeature()

    commandsController.delegate = workflowFeatureController

    let applicationProvider = ApplicationsProvider(applications: coreController.installedApplications,
                                                   mapper: viewModelFactory.applicationMapper())

    let mainView = MainView(
      applicationProvider: applicationProvider.erase(),
      commandController: commandsController.erase(),
      groupController: groupFeatureController.erase(),
      openPanelController: OpenPanelViewController().erase(),
      workflowController: workflowFeatureController.erase())
      .environmentObject(userSelection)

    let window = MainWindow(toolbar: Toolbar())
    window.delegate = self
    let contentView = NSHostingView(rootView: mainView)

    window.title = ProcessInfo.processInfo.processName
    window.contentView = contentView
    window.setFrameAutosaveName("Main Window")

    self.groupFeatureController = groupFeatureController
    self.directoryObserver = DirectoryObserver(at: URL(fileURLWithPath: storageController.path)) { [weak self] in
      guard let self = self,
            let groups = try? self.storageController.load() else { return }
      coreController.groupsController.reloadGroups(groups)
      let groupMapper = ViewModelMapperFactory().groupMapper()
      groupFeatureController.state = groupMapper.map(groups)
    }

    return window
  }

  // MARK: GroupsFeatureControllerDelegate

  func groupsFeatureController(_ controller: GroupsFeatureController,
                               didReloadGroups groups: [LogicFramework.Group]) {
    do {
      try storageController.save(groups)
    } catch let error {
      AppDelegateErrorController.handle(error)
    }
  }

  // MARK: NSWindowDelegate

  func windowDidBecomeKey(_ notification: Notification) {
    coreController?.disableKeyboardShortcuts = true
  }

  func windowDidResignKey(_ notification: Notification) {
    coreController?.disableKeyboardShortcuts = false
  }
}