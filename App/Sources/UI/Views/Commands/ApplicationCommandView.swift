import Apps
import Bonzai
import Inject
import SwiftUI

struct IconMenuStyle: MenuStyle {
  func makeBody(configuration: Configuration) -> some View {
    Menu(configuration)
      .menuStyle(.borderlessButton)
      .menuIndicator(.hidden)
  }
}

struct ApplicationCommandView: View {
  @ObserveInjection var inject
  enum Action {
    case changeApplication(Application)
    case updateName(newName: String)
    case changeApplicationModifier(modifier: ApplicationCommand.Modifier, newValue: Bool)
    case changeApplicationAction(ApplicationCommand.Action)
    case commandAction(CommandContainerAction)
  }

  @State private var metaData: CommandViewModel.MetaData
  @State private var model: CommandViewModel.Kind.ApplicationModel

  private let debounce: DebounceManager<String>

  @EnvironmentObject var applicationStore: ApplicationStore

  private let onAction: (Action) -> Void

  init(_ metaData: CommandViewModel.MetaData,
       model: CommandViewModel.Kind.ApplicationModel,
       onAction: @escaping (Action) -> Void) {
    _metaData = .init(initialValue: metaData)
    _model = .init(initialValue: model)
    self.onAction = onAction
    self.debounce = DebounceManager(for: .milliseconds(500)) { newName in
      onAction(.updateName(newName: newName))
    }
  }

  var body: some View {
    CommandContainerView(
      $metaData,
      icon: { metaData in
        ApplicationCommandImageView(metaData.wrappedValue, onAction: onAction)
      },
      content: { command in
        HStack(spacing: 8) {
          Menu(content: {
            Button(action: {
              model.action = "Open"
              onAction(.changeApplicationAction(.open))
            }, label: {
              Image(systemName: "power")
              Text("Open")
                .font(.subheadline)
            })

            Button(action: {
              model.action = "Close"
              onAction(.changeApplicationAction(.close))
            }, label: {
              Image(systemName: "poweroff")
              Text("Close")
                .font(.subheadline)
            })
          }, label: {
            Text(model.action)
              .font(.subheadline)
              .fixedSize(horizontal: false, vertical: true)
              .truncationMode(.middle)
              .allowsTightening(true)
          })
          .menuStyle(.zen(.init(color: .systemGray)))
          .fixedSize()
          .compositingGroup()

          TextField(metaData.namePlaceholder, text: $metaData.name)
            .textFieldStyle(.regular(Color(.windowBackgroundColor)))
            .onChange(of: metaData.name, perform: { debounce.send($0) })
        }
      }, subContent: { _ in
        ZenCheckbox("In background", style: .small, isOn: $model.inBackground) { newValue in
          onAction(.changeApplicationModifier(modifier: .background, newValue: newValue))
        }
        ZenCheckbox("Hide when opening", style: .small, isOn: $model.hideWhenRunning) { newValue in
          onAction(.changeApplicationModifier(modifier: .hidden, newValue: newValue))
        }
        ZenCheckbox("If not running", style: .small, isOn: $model.ifNotRunning) { newValue in
          onAction(.changeApplicationModifier(modifier: .onlyIfNotRunning, newValue: newValue))
        }
      },
      onAction: { onAction(.commandAction($0)) })
    .id(metaData.id)
    .enableInjection()
  }
}

struct ApplicationCommandImageView: View {
  @EnvironmentObject var applicationStore: ApplicationStore
  @State private var isHovered: Bool = false
  @State private var metaData: CommandViewModel.MetaData
  private let onAction: (ApplicationCommandView.Action) -> Void

  init(_ metaData: CommandViewModel.MetaData,
       onAction: @escaping (ApplicationCommandView.Action) -> Void) {
    _metaData = .init(initialValue: metaData)
    self.onAction = onAction
  }

  var body: some View {
    Menu(content: {
      ForEach(applicationStore.applications.lazy, id: \.path) { app in
        Button(action: {
          onAction(.changeApplication(app))
          metaData.icon = .init(bundleIdentifier: app.bundleIdentifier, path: app.path)
        }, label: {
          Text(app.displayName)
        })
      }
    }, label: { })
    .contentShape(Rectangle())
    .menuStyle(IconMenuStyle())
    .overlay(
      Color.accentColor.opacity(0.375)
        .cornerRadius(8, antialiased: false)
        .frame(width: 32, height: 32)
        .overlay(content: {
          if let icon = metaData.icon {
            IconView(icon: icon, size: .init(width: 24, height: 24))
              .fixedSize()
          }
        })
        .allowsHitTesting(false)
    )
  }
}

struct ApplicationCommandView_Previews: PreviewProvider {
  static let command = DesignTime.applicationCommand
  static var previews: some View {
    ApplicationCommandView(command.model.meta, model: command.kind) { _ in }
      .designTime()
      .frame(maxHeight: 80)
  }
}
