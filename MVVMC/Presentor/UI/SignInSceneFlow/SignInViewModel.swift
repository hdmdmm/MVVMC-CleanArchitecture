//
//  SignInViewModel.swift
//  MVVMC
//
//  Created by Dmitry Kh on 21.09.22.
//

import Foundation
import Combine

class SignInViewModel: ObservableObject {
  @Published private(set) var status: DataReadyStatus = .prepearing
}
