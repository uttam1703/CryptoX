//
//  APIConstant.swift
//  CryptoX
//
//  Created by uttam ahir on 10/04/24.
//

import Foundation

struct URLConstant {
    static let allCoinURL = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
    static let marketDataURL = "https://api.coingecko.com/api/v3/global"
    static func coinDetailULR(with coidId: String) -> String {
        return "https://api.coingecko.com/api/v3/coins/\(coidId)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
    }
}
