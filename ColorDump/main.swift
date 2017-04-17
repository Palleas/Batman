import Foundation

func main() {
    let colors: [[String: Any]] = ProjectColor.all.map { color in
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        color.raw.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return ["_class": "color",
                "alpha": alpha,
                "blue": blue,
                "green": green,
                "red": red]
    }
    
    let json = try! JSONSerialization.data(withJSONObject: colors, options: .prettyPrinted)
    let jsonString = String(data: json, encoding: .utf8)!
    print(jsonString)
}

main()
