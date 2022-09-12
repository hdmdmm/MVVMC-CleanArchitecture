//
//  AppDIContainer.swift
//  MVVMC
//
//  Created by Dmitry Kh on 30.08.22.
//

import Foundation
import UIKit

final class AppDIContainer {
  let config: AppConfigurator

  init(config: AppConfigurator) {
    self.config = config
  }

  func makeRootViewController() -> UINavigationController {
    UINavigationController(rootViewController: makeMainViewController())
  }

  private func makeMainViewController() -> UIViewController {
    ViewController(makeMainViewModel())
  }
  
  private func makeMainViewModel() -> MainViewModel {
    let dependencies = MainViewModelDependencies()
    return MainViewModel(dependencies)
  }
}
