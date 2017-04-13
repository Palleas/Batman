import Foundation
import Unbox
import class UIKit.UIColor
import struct UIKit.CGFloat

struct Project: Unboxable {

    enum Color: String, UnboxableEnum {
        case darkPink = "dark-pink"
        case darkGreen = "dark-green"
        case darkBlue = "dark-blue"
        case darkRed = "dark-red"
        case darkTeal = "dark-teal"
        case darkBrown = "dark-brown"
        case darkOrange = "dark-orange"
        case darkPurple = "dark-purple"
        case darkWarmGray = "dark-warm-gray"
        case lightPink = "light-pink"
        case lightGreen = "light-green"
        case lightBlue = "light-blue"
        case lightRed = "light-red"
        case lightTeal = "light-teal"
        case lightYellow = "light-yellow"
        case lightOrange = "light-orange"
        case lightPurple = "light-purple"
        case lightWarmGray = "light-warm-gray"
    }

    let name: String
    let color: Color?

    init(unboxer: Unboxer) throws {
        name = try unboxer.unbox(key: "name")
        color = unboxer.unbox(key: "color")
    }
}

extension Project.Color {
    var raw: UIColor {
        switch self {
        case .darkPink:
            return UIColor(hexColor: "ea4e9d")
        case .darkGreen:
            return UIColor(hexColor: "62d26f")
        case .darkBlue:
            return UIColor(hexColor: "4186e0")
        case .darkRed:
            return UIColor(hexColor: "e8384f")
        case .darkTeal:
            return UIColor(hexColor: "20aaea")
        case .darkBrown:
            return UIColor(hexColor: "eec300")
        case .darkOrange:
            return UIColor(hexColor: "fd612c")
        case .darkPurple:
            return UIColor(hexColor: "7a6ff0")
        case .darkWarmGray:
            return UIColor(hexColor: "8da3a6")
        case .lightPink:
            return UIColor(hexColor: "e362e3")
        case .lightGreen:
            return UIColor(hexColor: "a4cf30")
        case .lightBlue:
            return UIColor(hexColor: "4186e0")
        case .lightRed:
            return UIColor(hexColor: "fc91ad")
        case .lightTeal:
            return UIColor(hexColor: "37c5ab")
        case .lightYellow:
            return UIColor(hexColor: "eec300")
        case .lightOrange:
            return UIColor(hexColor: "fd9a00")
        case .lightPurple:
            return UIColor(hexColor: "aa62e3")
        case .lightWarmGray:
            return UIColor(hexColor: "8da3a6")

        }
    }
}

extension UIColor {
    internal convenience init(hexColor: String) {
        precondition(hexColor.characters.count == 6)

        let scanner = Scanner(string: hexColor)
        var rgb: UInt32 = 0
        scanner.scanHexInt32(&rgb)

        let r = CGFloat((rgb & 0xff0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00ff00) >>  8) / 255.0
        let b = CGFloat((rgb & 0x0000ff) >>  0) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}
