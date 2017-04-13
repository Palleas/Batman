import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var createFlow: CreateFlowCoordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let token = ProcessInfo.processInfo.environment["ASANA_TOKEN"].flatMap(Token.init)!
        
        self.createFlow = CreateFlowCoordinator(client: Client(token: token))
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = createFlow.controller
        self.window = window
        
        self.createFlow.start()
        
        return true
    }

}

