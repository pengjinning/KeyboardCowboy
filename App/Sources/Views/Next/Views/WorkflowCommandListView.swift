import SwiftUI

struct WorkflowCommandListView: View {
  @State private var model: DetailViewModel
  @State private var selections = Set<String>()
  private let onAction: (SingleDetailView.Action) -> Void

  init(_ model: DetailViewModel, onAction: @escaping (SingleDetailView.Action) -> Void) {
    _model = .init(initialValue: model)
    self.onAction = onAction
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack {
        Label("Commands:", image: "")
        Spacer()
        Group {
          Menu(content: {
            ForEach(DetailViewModel.Flow.allCases) {
              Button($0.rawValue, action: {})
            }
          }, label: {
            Text("Run \(model.flow.rawValue)")
          }, primaryAction: {
          })
          .fixedSize()
          Divider()
            .padding(.horizontal, 4)
        }
        .opacity(model.commands.isEmpty ? 0 : 1)
        Button(action: {}) {
          HStack(spacing: 4) {
            Image(systemName: "plus")
          }
        }
        .padding(4)
        .buttonStyle(.appStyle)
      }
      .padding([.leading, .bottom], 8)
      .padding(.trailing, 16)

      EditableStack(
        $model.commands,
        lazy: true,
        spacing: 10,
        onSelection: { self.selections = $0 },
        onMove: { indexSet, toOffset in
          model.commands.move(fromOffsets: indexSet, toOffset: toOffset)
          onAction(.moveCommand(workflowId: $model.id, indexSet: indexSet, toOffset: toOffset))
        },
        onDelete: { indexSet in
          var ids = Set<Command.ID>()
          indexSet.forEach { ids.insert(model.commands[$0].id) }
          model.commands.remove(atOffsets: indexSet)
          onAction(.removeCommands(workflowId: $model.id, commandIds: ids))
        }) { command in
          CommandView(command, workflowId: model.id) { action in
            onAction(.commandView(workflowId: model.id, action: action))
            switch action {
            case .remove(_, let commandId):
              model.commands.removeAll(where: { $0.id == commandId })
            default:
              break
            }
          }
          .contextMenu {
            Button("Run", action: {})
            Button("Remove", action: {
              if !selections.isEmpty {
                var indexSet = IndexSet()
                selections.forEach { id in
                  if let index = model.commands.firstIndex(where: { $0.id == id }) {
                    indexSet.insert(index)
                  }
                }
                model.commands.remove(atOffsets: indexSet)
                onAction(.removeCommands(workflowId: $model.id, commandIds: selections))
              } else {
                onAction(.commandView(workflowId: model.id, action: .remove(workflowId: model.id, commandId: command.id)))
                model.commands.removeAll(where: { $0.id == command.id })
              }
            })
          }
        }
        .background(
          GeometryReader { proxy in
          Rectangle()
            .fill(Color.gray)
            .frame(width: 3.0)
            .offset(x: (proxy.size.width / 2.0) - 3.0)
            .opacity(model.flow == .concurrent ? 0 : 1)
        }
      )
    }
    .padding()
  }
}

struct WorkflowCommandListView_Previews: PreviewProvider {
  static var previews: some View {
    WorkflowCommandListView(DesignTime.detail) { _ in }
      .frame(height: 900)
  }
}
