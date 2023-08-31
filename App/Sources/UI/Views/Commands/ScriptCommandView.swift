import SwiftUI

struct ScriptCommandView: View {
  enum Action {
    case updateName(newName: String)
    case updateSource(CommandViewModel.Kind.ScriptModel)
    case open(path: String)
    case reveal(path: String)
    case edit
    case commandAction(CommandContainerAction)
  }
  @EnvironmentObject var openPanel: OpenPanelController
  @State private var text: String
  @State private var metaData: CommandViewModel.MetaData
  @State private var model: CommandViewModel.Kind.ScriptModel
  private let onAction: (Action) -> Void

  init(_ metaData: CommandViewModel.MetaData,
       model: CommandViewModel.Kind.ScriptModel,
       onAction: @escaping (Action) -> Void) {
    _metaData = .init(initialValue: metaData)
    _model = .init(initialValue: model)

    switch model.source {
    case .inline(let source):
      _text = .init(initialValue: source)
    case .path(let source):
      _text = .init(initialValue: source)
    }

    self.onAction = onAction
  }

  var body: some View {
    CommandContainerView($metaData, icon: { command in
      ZStack {
        Rectangle()
          .fill(Color(.controlAccentColor).opacity(0.375))
          .cornerRadius(8, antialiased: false)
        Image(nsImage: NSWorkspace.shared.icon(forFile: "/System/Applications/Utilities/Script Editor.app"))
          .resizable()
          .aspectRatio(1, contentMode: .fill)
          .frame(width: 32)
      }
    }, content: { metaData in
      VStack {
        HStack(spacing: 8) {
          TextField("", text: $metaData.name)
            .textFieldStyle(AppTextFieldStyle())
            .onChange(of: metaData.wrappedValue.name, perform: {
              onAction(.updateName(newName: $0))
            })
          Spacer()
        }

        switch model.source {
        case .inline:
          ScriptEditorView(text: $text, syntax: .constant(AppleScriptHighlighting()))
            .onChange(of: text) { newSource in
              onAction(.updateSource(.init(id: model.id, source: .inline(newSource), scriptExtension: model.scriptExtension)))
            }
        case .path:
          HStack {
            TextField("Path", text: $text)
              .textFieldStyle(FileSystemTextFieldStyle())
              .onChange(of: text) { newPath in
                self.text = newPath
                onAction(.updateSource(.init(id: model.id, source: .path(newPath), scriptExtension: model.scriptExtension)))
              }
            Button("Browse", action: {
              openPanel.perform(.selectFile(type: model.scriptExtension.rawValue, handler: { newPath in
                self.text = newPath
                onAction(.updateSource(.init(id: model.id, source: .path(newPath), scriptExtension: model.scriptExtension)))
              }))
            })
            .buttonStyle(.gradientStyle(config: .init(nsColor: .systemBlue, grayscaleEffect: true)))
            .font(.caption)
          }
        }
      }
    }, subContent: { _ in
      HStack {
        switch model.source {
        case .path(let source):
          Button("Open", action: { onAction(.open(path: source)) })
            .buttonStyle(.gradientStyle(config: .init(nsColor: .systemCyan, grayscaleEffect: true)))
          Button("Reveal", action: { onAction(.reveal(path: source)) })
            .buttonStyle(.gradientStyle(config: .init(nsColor: .systemBlue, grayscaleEffect: true)))
        case .inline:
            EmptyView()
        }
      }
      .font(.caption)
    }, onAction: { onAction(.commandAction($0)) })
  }
}

struct ScriptCommandView_Previews: PreviewProvider {
  static let inlineCommand = DesignTime.scriptCommandInline
  static let pathCommand = DesignTime.scriptCommandWithPath

  static var previews: some View {
    Group {
      ScriptCommandView(inlineCommand.model.meta, model: inlineCommand.kind) { _ in }
        .frame(maxHeight: 120)
        .previewDisplayName("Inline")
      ScriptCommandView(pathCommand.model.meta, model: pathCommand.kind) { _ in }
        .frame(maxHeight: 120)
        .previewDisplayName("Path")
    }
    .designTime()
  }
}
