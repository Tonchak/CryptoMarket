import UIKit

let appDelegateClass: AnyClass = NSClassFromString("CryptoMarketTestTests.TestingAppDelegate") ?? AppDelegate.self

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(appDelegateClass))
