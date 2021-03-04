import SwiftUI
import ModelKit

struct EditBuiltInCommand: View {
  @State private var selection: String = ""
  @Binding var command: BuiltInCommand

  init(command: Binding<BuiltInCommand>) {
    _command = command
  }

  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Text("Open application commands").font(.title)
        Spacer()
      }.padding()
      Divider()
      VStack {
        Picker("Command: ", selection: Binding(get: {
          selection
        }, set: {
          selection = $0
        })) {
          ForEach(BuiltInCommand.Kind.allCases) { command in
            Text(command.displayValue)
              .id(command.id)
          }
        }
      }.padding()
    }.onAppear {
      selection = command.kind.rawValue
    }
  }
}

struct EditBuiltInCommand_Previews: PreviewProvider, TestPreviewProvider {
  static var previews: some View {
    testPreview.previewAllColorSchemes()
  }

  static var testPreview: some View {
    EditBuiltInCommand(command: .constant(BuiltInCommand.init(kind: .quickRun)))
  }
}