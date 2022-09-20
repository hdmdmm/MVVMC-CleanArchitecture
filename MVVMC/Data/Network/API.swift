//
//  API.swift
//  MVVMC
//
//  Created by Dmitry Kh on 19.09.22.
//

import Foundation

struct APIEndpoints {
  static func fetchTickers(searchKey: String, maxResult: Int = 50) -> Endpoint<[TickerDTO]> {
    Endpoint(
      path: "/v3/reference/tickers",
      method: .get,
      queryParameters: [
        "search": searchKey,
        "active": "true",
        "sort": "ticker",
        "order": "asc",
        "limit": "\(maxResult)"
      ]
    )
  }
}
