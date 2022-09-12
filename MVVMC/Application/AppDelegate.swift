//
//  AppDelegate.swift
//  MVVMC
//
//  Created by Dmitry Kh on 30.08.22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var container: AppDIContainer!
  var coordinator: AppCoordinator?
  var window: UIWindow?
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // initialization flow
    // initialize crashlytics
    // initialize analytics

    // App configurator initialization
    let config: AppConfigurator
    do {
      config = try AppConfigurator()
    }
    catch {
      // send debugging info with error. It's better using crashlytics reports.
      return true
    }
    
    // DI container initialization
    container = AppDIContainer(config: config)

    // root view controller
    let navigationController = container.makeRootViewController()

    // Initialize Window and UI
    createWindow(with: navigationController)

    // Root coordinator initialization
    startRootCoordinator(on: navigationController)

    return true
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    CoreDataStorage.shared.saveContext()
  }
  

  private func createWindow(with rootViewController: UIViewController) {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = rootViewController
    window?.makeKeyAndVisible()
  }
  
  private func startRootCoordinator(on rootController: UINavigationController) {
    coordinator = AppCoordinator(rootController, container: container)
    coordinator?.start()
  }
}


