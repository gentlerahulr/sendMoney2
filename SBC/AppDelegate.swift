//
//  AppDelegate.swift
//  SBC
//

import UIKit
import CoreData
import Firebase
import FBSDKCoreKit
import IQKeyboardManagerSwift

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SBC")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        // Override point for customization after application launch.
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        setColorConfig()
        screenShotNotify()
        keyboardManagerInitialization()
        DependencyGraph.standard.inject()
        if #available(iOS 13.0, *) {
            return true
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
            if UserDefaults.standard.isLoggedIn {
                if let appAuthToken = KeyChainServiceWrapper.standard.appAuthToken {
                    KeyChainServiceWrapper.standard.authToken = appAuthToken
                }
                RootViewControllerRouter.setTabbarAsRootVC(animated: true)
            } else {
                KeyChainServiceWrapper.standard.appAuthToken = nil
                KeyChainServiceWrapper.standard.authToken = nil
                RootViewControllerRouter.setHomeNavAsRootVC(animated: false)
            }
            return true
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    @available(iOS 13.0, *)
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func screenShotNotify() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.userDidTakeScreenshotNotification,
            object: nil, queue: nil) { _ in
            AlertViewAdapter.shared.show(localizedStringForKey(key: "screen.shot"), state: .success)
        }
    }
    
    /// This  Method is for Keyboard Manager Initialization
    func keyboardManagerInitialization() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    /// This function is used for tabbar initial setup
    ///Spaces are added here for more readability
    ///This function needs to restructure
    func tabBarSetUp() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.mediumFontWithSize(size: 10), NSAttributedString.Key.foregroundColor: UIColor.themeDarkBlue], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.mediumFontWithSize(size: 10), NSAttributedString.Key.foregroundColor: UIColor.themeLightBlue], for: .normal)
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
    }
}
