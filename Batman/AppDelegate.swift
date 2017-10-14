import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var createFlow: CreateFlowCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        BuddyBuildSDK.setup()

        let token = Token(value: keyOrProcessEnv("ASANA_TOKEN"))
        let client = Client(token: token)
        self.createFlow = CreateFlowCoordinator(client: client)

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = createFlow.controller
        self.window = window

        self.createFlow.start()

        return true
    }

}
