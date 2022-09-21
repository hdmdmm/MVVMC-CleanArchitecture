//
//  SignUpViewController.swift
//  MVVMC
//
//  Created by Dmitry Kh on 21.09.22.
//

import Combine
import SwiftUI

class SignUpViewController: UIViewController {
  @ObservedObject private(set) var viewModel: SignUpViewModel
  private(set) var navigationCoordinator: NavigationCoordinator

  private var cancellables: Set<AnyCancellable> = []
  
  init(
    _ viewModel: SignUpViewModel,
    _ coordinator: NavigationCoordinator
  ) {
    self.viewModel = viewModel
    self.navigationCoordinator = coordinator
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
