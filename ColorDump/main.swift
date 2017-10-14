import Foundation

func main(argv: [String]) {
    guard argv.count > 1 else {
        fatalError("Usage ColorDump file.sketch")
    }

    let sketchFile = CommandLine.arguments[1]

    let filename = UUID().uuidString
    let path = (NSTemporaryDirectory() as NSString).appendingPathComponent(filename)
    print("Temoporary dir is \(path)")

    // Open Sketch file
    let t = Process()
    t.arguments = [sketchFile, "-d", path]
    t.launchPath = "/usr/bin/unzip"
    t.launch()
    t.waitUntilExit()

    // Retrieve the `Documents.json`
    let document = (path as NSString).appendingPathComponent("document.json")

    guard FileManager.default.fileExists(atPath: document) else {
        fatalError("Unable to parse Sketch file (no documents.json)")
    }

    // Extract content from document.json
    let content = try! Data(contentsOf: URL(fileURLWithPath: document)) // swiftlint:disable:this force_try
    var payload = try! JSONSerialization.jsonObject(with: content, options: .allowFragments) as! [AnyHashable: Any] // swiftlint:disable:this force_try force_cast

    // Extract colors
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

    // Update "document.json"
    var assets = payload["assets"] as! [AnyHashable: Any] // swiftlint:disable:this force_cast
    assets["colors"] = colors
    payload["assets"] = assets

    // Serialize and store!
    let newContent = try! JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted) // swiftlint:disable:this force_try
    try! newContent.write(to: URL(fileURLWithPath: document)) // swiftlint:disable:this force_try

    // Close Sketch file
    let close = Process()
    close.launchPath = "/usr/bin/zip"
    close.currentDirectoryPath = path
    close.arguments = ["-r", sketchFile, "*"]
    close.launch()
    close.waitUntilExit()
}

//CommandLine.arguments

main(argv: CommandLine.arguments)
