import Foundation

#if os(iOS) || os(tvOS)
    import UIKit
    public typealias Color = UIColor
#else
    import Cocoa
    public typealias Color = NSColor
#endif


extension Color {
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

enum ProjectColor: String, AutoList  {
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

extension ProjectColor {
    var raw: Color {
        switch self {
        case .darkPink:
            return Color(hexColor: "ea4e9d")
        case .darkGreen:
            return Color(hexColor: "62d26f")
        case .darkBlue:
            return Color(hexColor: "4186e0")
        case .darkRed:
            return Color(hexColor: "e8384f")
        case .darkTeal:
            return Color(hexColor: "20aaea")
        case .darkBrown:
            return Color(hexColor: "eec300")
        case .darkOrange:
            return Color(hexColor: "fd612c")
        case .darkPurple:
            return Color(hexColor: "7a6ff0")
        case .darkWarmGray:
            return Color(hexColor: "8da3a6")
        case .lightPink:
            return Color(hexColor: "e362e3")
        case .lightGreen:
            return Color(hexColor: "a4cf30")
        case .lightBlue:
            return Color(hexColor: "4186e0")
        case .lightRed:
            return Color(hexColor: "fc91ad")
        case .lightTeal:
            return Color(hexColor: "37c5ab")
        case .lightYellow:
            return Color(hexColor: "eec300")
        case .lightOrange:
            return Color(hexColor: "fd9a00")
        case .lightPurple:
            return Color(hexColor: "aa62e3")
        case .lightWarmGray:
            return Color(hexColor: "8da3a6")
            
        }
    }
}
