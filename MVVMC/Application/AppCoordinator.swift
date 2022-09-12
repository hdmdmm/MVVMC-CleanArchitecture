//
//  AppCoordinator.swift
//  MVVMC
//
//  Created by Dmitry Kh on 30.08.22.
//

import Foundation
import UIKit


final class AppCoordinator {
  weak var rootViewController: UINavigationController?
  private let container: AppDIContainer

  init (_ rootViewController: UINavigationController,
        container: AppDIContainer) {
    self.rootViewController = rootViewController
    self.container = container
  }

  func start() {
    
    // put here check for authorization
    // start onboarding flow if no active user
    // or start main flow
  }
}
