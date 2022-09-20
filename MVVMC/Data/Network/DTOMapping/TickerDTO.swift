//
//  TickerDTO.swift
//  MVVMC
//
//  Created by Dmitry Kh on 19.09.22.
//

import Foundation

struct AddressDTO: Decodable {

  private enum CodingKeys: String, CodingKey {
    case address, city, state
    case postalCode = "postal_code"
  }

  let address: String
  let city: String
  let postalCode: String
  let state: String
}

struct BrandingDTO: Decodable {
  private enum CodingKeys: String, CodingKey {
    case iconUrl = "icon_url"
    case logoUrl = "logo_url"
  }

  let iconUrl: String?
  let logoUrl: String?
}

struct TickerDTO: Decodable {

  private enum CodingKeys: String, CodingKey {
    case ticker, name, market, locale, type, active, cik, address, branding, description
    case primaryExchange = "primary_exchange"
    case currencyName = "currency_name"
    case compositeFigi = "composite_figi"
    case shareClassFigi = "share_class_figi"
    case homepageUrl = "homepage_url"
    case listDate = "list_date"
    case marketCap = "market_cap"
    case phoneNumber = "phone_number"
    case shareClassSharesOutstanding = "share_class_shares_outstanding"
    case sicCode = "sic_code"
    case sicDescription = "sic_description"
    case tickerRoot = "ticker_root"
    case totalEmployees = "total_employees"
    case wheitedSharedOutstanding = "wheited_shared_outstanding"
  }

  let active: Bool
  let address: AddressDTO
  let branding: BrandingDTO

  let cik: String?
  let compositeFigi: String?
  let currencyName: String
  let description: String
  let homepageUrl: String?
  let listDate: String
  let locale: String
  let market: String
  let marketCap: Int
  let name: String
  let phoneNumber: String
  let primaryExchange: String?
  let shareClassFigi: String?
  let shareClassSharesOutstanding: Int
  let sicCode: String
  let sicDescription: String

  let ticker: String
  let tickerRoot: String
  let totalEmployees: Int

  let type: String?
  
  let wheitedSharedOutstanding: Int
}

struct SearchTickerDTO: Decodable {
  
  private enum CodingKeys: String, CodingKey {
    case ticker, name, market, locale, type, active, cik
    case primaryExchange = "primary_exchange"
    case currencyName = "currency_name"
    case lastUpdatedUTC = "last_updated_utc"
  }
  let ticker: String
  let name: String
  let market: String
  let locale: String
  let primaryExchange: String
  let type: String
  let active: Bool
  let currencyName: String
  let cik: String
  let lastUpdatedUTC: String
}
