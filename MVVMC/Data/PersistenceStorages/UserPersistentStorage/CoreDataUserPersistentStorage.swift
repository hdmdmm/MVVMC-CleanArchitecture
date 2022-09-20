//
//  CoreDataUserPersistentStorage.swift
//  MVVMC
//
//  Created by Dmitry Kh on 18.09.22.
//

import Foundation

struct CoreDataPersistentStorage: UserPersistentStorage {
  private let coreDataStorage: CoreDataStorage
  
  init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
    self.coreDataStorage = coreDataStorage
  }
}
