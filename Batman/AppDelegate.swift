import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var createFlow: CreateFlowCoordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        BuddyBuildSDK.setup()
        
        let token = Token(value: keyOrProcessEnv("ASANA_TOKEN"))
        self.createFlow = CreateFlowCoordinator(client: Client(token: token))
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = createFlow.controller
        self.window = window
        
        self.createFlow.start()

        let colors: [[String: Any]] = Project.Color.all.map { color in
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
        
        return true
    }

}

