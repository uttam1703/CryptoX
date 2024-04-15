//
//  MarketDataUseCase.swift
//  CryptoX
//
//  Created by uttam ahir on 10/04/24.
//

import Foundation

final class MarketDataUseCase {
    func fetchMarketData() async throws -> MarketDataModel? {
        guard let url = URL(string: URLConstant.marketDataURL) else {
            throw APIError.invalidURL
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let globalData = try JSONDecoder().decode(GlobalData.self, from: data)
            
            guard globalData.data != nil else {
                throw APIError.noData
            }
            
            return globalData.data
        } catch {
            throw APIError.networkError(error)
        }
    }
}
