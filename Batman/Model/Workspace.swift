import Foundation
import Unbox

struct Workspace: Unboxable {

    /// Id of the workspace
    let id: Int

    /// Name of the workspace
    let name: String

    /// Workspace belongs to an organization 
    let isOrganization: Bool

    init(unboxer: Unboxer) throws {
        self.id = try unboxer.unbox(key: "id")
        self.name = try unboxer.unbox(key: "name")
        self.isOrganization = try unboxer.unbox(key: "is_organization")
    }
}
