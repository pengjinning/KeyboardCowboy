import SwiftUI

struct MainView: View {
  let groups: [Group]
  @State private var selection: Group?

  var body: some View {
    NavigationView {
      List {
        ForEach(groups) { group in
          NavigationLink(
            destination: WorkflowList(workflows: group.workflows),
            tag: group,
            selection: $selection
          ) {
            row(for: group)
          }
        }
        .onAppear(perform: {
          selection = groups.first
        })
      }
      .listStyle(SidebarListStyle())
      .frame(minWidth: 200, idealWidth: 200, maxWidth: 200, maxHeight: .infinity)
    }
  }

  private func row(for group: ViewKit.Group) -> some View {
    HStack {
      Text(group.name)
        .foregroundColor(.primary)
      Spacer()
      Text("\(group.workflows.count)")
        .foregroundColor(.white)
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(Circle().fill(Color(.systemBlue)))
    }.padding(.top, 8)
  }
}

// MARK: - Previews

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView(groups: [
      ModelFactory().group()
    ])
  }
}