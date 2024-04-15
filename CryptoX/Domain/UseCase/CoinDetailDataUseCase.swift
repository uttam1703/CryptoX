//
//  CoinDetailDataUseCase.swift
//  CryptoX
//
//  Created by uttam ahir on 10/04/24.
//

import Foundation

class CoinDetailDataUseCase {
    func fetchCoinDetailData(forCoinId coinId: String) async throws -> CoinDetailModel? {
        guard let url = URL(string: URLConstant.coinDetailULR(with: coinId)) else {
            throw APIError.invalidURL
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let coinDetailData = try JSONDecoder().decode(CoinDetailModel.self, from: data)
            
            return coinDetailData
        } catch {
            throw APIError.networkError(error)
        }
    }
}
