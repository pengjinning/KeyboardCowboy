import SwiftUI
import Apps

struct SingleDetailView: View {
  enum Action {
    case applicationTrigger(workflowId: Workflow.ID, action: WorkflowApplicationTriggerView.Action)
    case commandView(workflowId: Workflow.ID, action: CommandView.Action)
    case dropUrls(workflowId: Workflow.ID, urls: [URL])
    case moveCommand(workflowId: Workflow.ID, indexSet: IndexSet, toOffset: Int)
    case removeCommands(workflowId: Workflow.ID, commandIds: Set<Command.ID>)
    case removeTrigger(workflowId: Workflow.ID)
    case runWorkflow(workflowId: Workflow.ID)
    case setIsEnabled(workflowId: Workflow.ID, isEnabled: Bool)
    case trigger(workflowId: Workflow.ID, action: WorkflowTriggerView.Action)
    case updateExecution(workflowId: Workflow.ID, execution: DetailViewModel.Execution)
    case updateKeyboardShortcuts(workflowId: Workflow.ID, keyboardShortcuts: [KeyShortcut])
    case updateName(workflowId: Workflow.ID, name: String)
  }

  @ObserveInjection var inject
  @Environment(\.openWindow) var openWindow
  private var detailPublisher: DetailPublisher
  @State var overlayOpacity: CGFloat = 0
  private let onAction: (Action) -> Void

  init(_ detailPublisher: DetailPublisher, onAction: @escaping (Action) -> Void) {
    self.detailPublisher = detailPublisher
    self.onAction = onAction
  }

  var body: some View {
    let shouldShowCommandList = detailPublisher.data.trigger != nil ||
                               !detailPublisher.data.commands.isEmpty

    ScrollViewReader { proxy in
        VStack(alignment: .leading) {
          WorkflowInfoView(detailPublisher, onAction: { action in
            switch action {
            case .updateName(let name):
              onAction(.updateName(workflowId: detailPublisher.data.id, name: name))
            case .setIsEnabled(let isEnabled):
              onAction(.setIsEnabled(workflowId: detailPublisher.data.id, isEnabled: isEnabled))
            }
          })
          .padding(.horizontal, 4)
          .padding(.vertical, 12)
          .id(detailPublisher.data.id)
          WorkflowTriggerListView(detailPublisher.data, onAction: onAction)
            .id(detailPublisher.data.id)
        }
        .padding([.top, .leading, .trailing])
        .padding(.bottom, 32)
        .background(alignment: .bottom, content: {
          Rectangle()
            .fill(Color(nsColor: .windowBackgroundColor))
            .mask(
              Canvas(rendersAsynchronously: true) { context, size in
                context.fill(
                  Path(CGRect(origin: .zero, size: CGSize(width: size.width,
                                                          height: size.height - 12))),
                  with: .color(Color(.black)))

                if shouldShowCommandList {
                  context.fill(Path { path in
                    path.move(to: CGPoint(x: size.width / 2, y: size.height - 12))
                    path.addLine(to: CGPoint(x: size.width / 2 - 24, y: size.height - 12))
                    path.addLine(to: CGPoint(x: size.width / 2, y: size.height - 2))
                    path.addLine(to: CGPoint(x: size.width / 2 + 24, y: size.height - 12))
                    path.addLine(to: CGPoint(x: size.width / 2, y: size.height - 12))
                  }, with: .color(Color(.black)))
                }
              }
            )
            .shadow(color: Color.white.opacity(0.2), radius: 0, y: 1)

          .shadow(radius: 2, y: 2)
        })

      VStack(spacing: 0) {
        HStack {
          Label("Commands", image: "")
          Spacer()
          Group {
            Menu(content: {
              ForEach(DetailViewModel.Execution.allCases) { execution in
                Button(execution.rawValue, action: {
                  onAction(.updateExecution(workflowId: detailPublisher.data.id,
                                            execution: execution))
                })
              }
            }, label: {
              Image(systemName: "play.fill")
              Text("Run \(detailPublisher.data.execution.rawValue)")
            }, primaryAction: {
              onAction(.runWorkflow(workflowId: detailPublisher.data.id))
            })
            .fixedSize()
          }
          .opacity(detailPublisher.data.commands.isEmpty ? 0 : 1)
          Button(action: {
            openWindow(value: NewCommandWindow.Context.newCommand(workflowId: detailPublisher.data.id))
          }) {
            HStack(spacing: 4) {
              Image(systemName: "plus.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 12, maxHeight: 12)
                .layoutPriority(-1)
              Text("Add Command")
                .lineLimit(1)
                .allowsTightening(true)
            }
          }
          .padding(.horizontal, 4)
          .buttonStyle(.gradientStyle(config: .init(nsColor: .systemGreen, grayscaleEffect: true)))
          .opacity(!detailPublisher.data.commands.isEmpty ? 1 : 0)
        }
        .padding(.horizontal)

        ScrollView {
          WorkflowCommandListView(
            detailPublisher,
            scrollViewProxy: proxy,
            onAction: { action in
              onAction(action)
            })
          .onFrameChange(space: .named("WorkflowCommandListView"), perform: { rect in
            if rect.origin.y < 0 {
              overlayOpacity <- 1
            } else {
              overlayOpacity <- 0
            }
          })
        }
        .overlay(alignment: .top, content: { overlayView() })
        .coordinateSpace(name: "WorkflowCommandListView")
        .zIndex(2)
      }
      .opacity(shouldShowCommandList ? 1 : 0)
    }
    .labelStyle(HeaderLabelStyle())
    .debugEdit()
  }

  private func overlayView() -> some View {
    VStack(spacing: 0) {
      LinearGradient(stops: [
        Gradient.Stop.init(color: .clear, location: 0),
        Gradient.Stop.init(color: .black.opacity(0.5), location: 0.1),
        Gradient.Stop.init(color: .black, location: 0.5),
        Gradient.Stop.init(color: .black.opacity(0.5), location: 0.9),
        Gradient.Stop.init(color: .clear, location: 1),
      ],
                     startPoint: .leading,
                     endPoint: .trailing)
      .frame(height: 1)
    }
      .opacity(overlayOpacity)
      .allowsHitTesting(false)
      .shadow(color: Color(.black).opacity(0.75), radius: 2, x: 0, y: 2)
      .animation(.default, value: overlayOpacity)
      .edgesIgnoringSafeArea(.top)
  }
}

struct SingleDetailView_Previews: PreviewProvider {
  static var previews: some View {
    SingleDetailView(.init(DesignTime.detail)) { _ in }
      .designTime()
      .frame(height: 900)
  }
}
