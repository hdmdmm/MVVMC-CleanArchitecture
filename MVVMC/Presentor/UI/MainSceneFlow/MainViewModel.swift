//
//  MainViewModel.swift
//  MVVMC
//
//  Created by Dmitry Kh on 20.09.22.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {
  @Published private(set) var status: DataReadyStatus = .prepearing
}
