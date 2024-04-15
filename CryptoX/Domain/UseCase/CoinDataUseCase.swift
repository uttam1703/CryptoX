//
//  CoinDataUseCase.swift
//  CryptoX
//
//  Created by uttam ahir on 10/04/24.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case noData
    case networkError(Error?)
}

class CoinDataUseCase {
    
    func fetchCoinData() async throws -> [CoinModel] {
        guard let url = URL(string: URLConstant.allCoinURL) else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let coinModels = try JSONDecoder().decode([CoinModel].self, from: data)
            
            guard !coinModels.isEmpty else {
                throw APIError.noData
            }
            
            return coinModels
        } catch {
            throw APIError.networkError(error)
        }
    }
}
