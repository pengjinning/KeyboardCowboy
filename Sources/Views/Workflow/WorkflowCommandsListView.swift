import Apps
import SwiftUI

struct WorkflowCommandsListView: View, Equatable {
  @Binding var workflow: Workflow

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Label("Commands:", image: "")
          .labelStyle(HeaderLabelStyle())
        Spacer()
      }
      ForEach($workflow.commands, content: {
        CommandView(command: $0)
      })
    }
  }

  static func == (lhs: WorkflowCommandsListView, rhs: WorkflowCommandsListView) -> Bool {
    lhs.workflow.commands == rhs.workflow.commands
  }
}

struct WorkflowCommandsView_Previews: PreviewProvider {
  static var previews: some View {
    WorkflowCommandsListView(workflow: .constant(Workflow.designTime(.application([
      ApplicationTrigger.init(application: Application.finder())
    ]))))
  }
}