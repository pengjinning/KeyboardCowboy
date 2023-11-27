import Bonzai
import SwiftUI

struct NewCommandMouseView: View {
  @Binding var payload: NewCommandPayload
  @Binding var validation: NewCommandValidation
  @State var selection: MouseCommand.Kind = .click(.focused(.center))

  var body: some View {
    Menu(content: {
      ForEach(MouseCommand.Kind.allCases) { kind in
        Button(action: {
          selection = kind
        }, label: {
          Text(kind.displayValue)
        })
      }
    }, label: {
      Text(selection.displayValue)
    })
    .onChange(of: selection, perform: { value in
      payload = .mouse(kind: selection)
    })
    .onAppear {
      validation = .valid
      payload = .mouse(kind: selection)
    }
    .menuStyle(.regular)
  }
}

struct NewCommandMouseView_Previews: PreviewProvider {
  static var previews: some View {
    NewCommandView(
      workflowId: UUID().uuidString,
      commandId: nil,
      title: "New command",
      selection: .mouse,
      payload: .placeholder,
      onDismiss: {},
      onSave: { _, _ in })
    .designTime()
  }
}