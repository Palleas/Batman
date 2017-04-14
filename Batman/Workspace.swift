import Foundation
import Unbox

struct Workspace: Unboxable {
    
    let id: Int
    let name: String
    let isOrganization: Bool

    init(unboxer: Unboxer) throws {
        self.id = try unboxer.unbox(key: "id")
        self.name = try unboxer.unbox(key: "name")
        self.isOrganization = try unboxer.unbox(key: "is_organization")
    }
}
