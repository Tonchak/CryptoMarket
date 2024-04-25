import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var currentAppDelegate: AppDelegate?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let sceneWindow = UIWindow(windowScene: windowScene)
        self.window = sceneWindow
        
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: CurrenciesListViewController(style: .plain))
        
        currentAppDelegate = UIApplication.shared.delegate as? AppDelegate
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
}