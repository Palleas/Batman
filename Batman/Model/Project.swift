import Foundation
import Unbox
import class UIKit.UIColor
import struct UIKit.CGFloat

struct Project: Unboxable {

    let id: Int
    let name: String
    let color: ProjectColor?

    init(unboxer: Unboxer) throws {
        id = try unboxer.unbox(key: "id")
        name = try unboxer.unbox(key: "name")
        color = unboxer.unbox(key: "color")
    }
}

extension ProjectColor: UnboxableEnum {}
