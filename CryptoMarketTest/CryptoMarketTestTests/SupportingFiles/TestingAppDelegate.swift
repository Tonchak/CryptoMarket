import UIKit
import MagicalRecord

class TestingAppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        MagicalRecord.setupCoreDataStack(withAutoMigratingSqliteStoreNamed: "CryptoMarketTest")
        
        return true
    }
}
