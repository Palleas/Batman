import Foundation
import Unbox
import class UIKit.UIColor
import struct UIKit.CGFloat

struct Project {

    /// Id of the project
    let id: Int

    /// Name of the project
    let name: String

    /// Associated color to the project
    let color: ProjectColor?

}

extension Project: Unboxable {

    init(unboxer: Unboxer) throws {
        id = try unboxer.unbox(key: "id")
        name = try unboxer.unbox(key: "name")
        color = unboxer.unbox(key: "color")
    }

}

extension Project: Boxable {

    var encoded: [AnyHashable: Any] {
        var payload: [String: Any] = ["id": id, "name": name]
        if let rawColor = color?.rawValue {
            payload["color"] = rawColor
        }

        return payload
    }
}

extension Project: AutoEquatable {}
