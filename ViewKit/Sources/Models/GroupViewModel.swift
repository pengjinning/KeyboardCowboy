import Foundation

/// A `Group` is a collection of `Workflow`s.
/// They are used to group collections but also to scope
/// the validity of the `Workflow`'s. This should work with
/// a set of rules determining if a workflow is enabled or not.
///
/// - Example: A group can be scoped to only be active when a
///            certain application is active, such as:
///            The group `Finder workflows` will only apply
///            and be bound to keyboard shortcuts when the Finder
///            is the front-most application.
public struct GroupViewModel: Identifiable, Hashable, Equatable {
  public let id: String
  public var name: String
  public var color: String
  public var workflows: [WorkflowViewModel]

  public init(id: String = UUID().uuidString,
              name: String,
              color: String,
              workflows: [WorkflowViewModel]) {
    self.id = id
    self.color = color
    self.name = name
    self.workflows = workflows
  }
}

extension GroupViewModel {
  public static func empty(id: String = UUID().uuidString) -> GroupViewModel {
    GroupViewModel(id: id,
                   name: "Untitled group",
                   color: "#000",
                   workflows: [])
  }
}