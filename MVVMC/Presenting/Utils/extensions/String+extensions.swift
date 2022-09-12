//
//  String+extensions.swift
//  MVVMC
//
//  Created by Dmitry Kh on 31.08.22.
//

import Foundation

extension String {
  var localized: String {
    return NSLocalizedString(self, comment: "")
  }
}
