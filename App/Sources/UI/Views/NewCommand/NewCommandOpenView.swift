import Apps
import SwiftUI
import Bonzai

struct NewCommandOpenView: View {
  enum Focus {
    case path
  }
  private let wikiUrl = URL(string: "https://github.com/zenangst/KeyboardCowboy/wiki/Commands#open-commands")!

  @EnvironmentObject var applicationStore: ApplicationStore
  @EnvironmentObject var openPanel: OpenPanelController

  @FocusState var focus: Focus?

  @Binding var payload: NewCommandPayload
  @Binding var validation: NewCommandValidation
  @State private var application: Application?
  @State private var path: String = "~/"

  init(_ payload: Binding<NewCommandPayload>, validation: Binding<NewCommandValidation>) {
    _payload = payload
    _validation = validation
  }

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Label(title: { Text("Open file or folder:") }, icon: { EmptyView() })
          .labelStyle(HeaderLabelStyle())
        Spacer()
        Button(action: { NSWorkspace.shared.open(wikiUrl) },
               label: { Image(systemName: "questionmark.circle.fill") })
        .buttonStyle(.calm(color: .systemYellow, padding: .small))
      }

      HStack {
        ZStack(alignment: .bottomTrailing) {
          Image(nsImage: NSWorkspace().icon(forFile: (path as NSString).expandingTildeInPath))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 32)

          if let application {
            Image(nsImage: NSWorkspace().icon(forFile: application.path))
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 16)
              .shadow(radius: 3)
          }
        }

        TextField("Path", text: $path)
          .textFieldStyle(FileSystemTextFieldStyle())
          .focused($focus, equals: .path)
        Button("Browse", action: {
          openPanel.perform(.selectFile(type: nil, handler: { path in
            self.path = path
          }))
        })
        .buttonStyle(.zen(.init(color: .systemTeal, grayscaleEffect: .constant(false))))
      }
      .padding(4)
      .background {
        RoundedRectangle(cornerRadius: 4)
          .stroke(Color(.white).opacity(0.2), lineWidth: 1)
      }
      .padding(.bottom, 8)

      HStack(spacing: 32) {
        Text("With application: ")
        Menu(content: {
          ForEach(applicationStore.applications) { app in
            Button(action: {
              application = app
              updatePayload()
            }, label: {
              Text(app.displayName)
            })
          }
        }, label: {
          if let application {
            Text(application.displayName)
          } else {
            Text("Default application")
          }
        })
      }
    }
    .menuStyle(.zen(.init(color: .systemGray)))
    .onAppear {
      validation = .valid
      updatePayload()
      focus = .path
    }
    .onChange(of: self.path, perform: { newValue in
      updatePayload()
    })
  }

  private func updatePayload() {
    payload = .open(path: path, application: application)
  }
}

struct NewCommandOpenView_Previews: PreviewProvider {
  static var previews: some View {
    NewCommandView(
      workflowId: UUID().uuidString,
      commandId: nil,
      title: "New command",
      selection: .open,
      payload: .placeholder,
      onDismiss: {},
      onSave: { _, _ in })
    .designTime()
  }
}
