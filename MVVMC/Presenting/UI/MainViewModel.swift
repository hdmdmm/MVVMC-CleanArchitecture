//
//  BaseViewModel.swift
//  MVVMC
//
//  Created by Dmitry Kh on 31.08.22.
//

import Foundation
import Combine

struct MainViewModelDependencies {}

enum DataReadyStatus {
  case prepearing
  case loading
  case finished
  case cancelled
}

final class MainViewModel: ObservableObject {
  @Published private(set) var status: DataReadyStatus

  init(_ dependencies: MainViewModelDependencies) {
    status = .prepearing
  }
  
  func update() {
    status = .loading
    
  }
  
  // MARK: - Private API Helper
  
}
