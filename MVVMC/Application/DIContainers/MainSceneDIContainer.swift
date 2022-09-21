//
//  MainSceneDIContainer.swift
//  MVVMC
//
//  Created by Dmitry Kh on 18.09.22.
//

import Foundation
import UIKit

protocol MainSceneDependencies: DIDepenciesProtocol {
}

final class MainSceneDIContainer: MainSceneDependencies {
  
  private func makeViewModel() -> MainViewModel {
    MainViewModel()
  }
  
  private func makeCoordinator() -> MainSceneCoordinator {
    MainSceneCoordinator(container: self)
  }
  
  private func makeViewController() -> MainViewController {
    MainViewController( makeViewModel(), makeCoordinator() )
  }

  func rootViewController() -> UINavigationController {
    UINavigationController(rootViewController: makeViewController() )
  }
}
