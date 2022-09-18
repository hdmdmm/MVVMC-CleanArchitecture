//
//  SecurityQueriesForKey.swift
//  MVVMC
//
//  Created by Dmitry Kh on 18.09.22.
//

import Foundation

protocol SecuritySaltQueriesProtocol {
  func getSaltQuery(tag: String) -> EncryptedStorageProtocol
  func setSaltQuery(_ salt: Data, tag: String) -> EncryptedStorageProtocol
}

struct DefaultSecurityQueriesForSalt: SecuritySaltQueriesProtocol  {
  func getSaltQuery(tag: String) -> EncryptedStorageProtocol {
    DefaultEncryptedStorage ( query: [
      kSecClass.asString: kSecClassKey,
      kSecAttrLabel.asString: tag
    ] as CFDictionary)
  }
  
  func setSaltQuery(_ salt: Data, tag: String) -> EncryptedStorageProtocol {
    DefaultEncryptedStorage ( query: [
      kSecClass.asString: kSecClassKey,
      kSecAttrLabel.asString: tag,
      kSecValueData.asString: salt
    ] as CFDictionary)
  }
}
