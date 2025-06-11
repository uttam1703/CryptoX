//
//  HomeViewModel.swift
//  CryptoX
//
//  Created by uttam ahir on 10/04/24.
//

import Foundation

protocol HomeViewModelProtocol {
    func fetchCoinData() async throws -> Bool
    func getCoinCount() -> Int
    func getHomeCellConfig(forRow row: Int) -> HomeCellConfigModel
    func getCoin(forRow row: Int) -> CoinModel
    func updateSearchText(text: String)
}

final class HomeViewModel: HomeViewModelProtocol {
    private let coinDataUseCase: CoinDataUseCaseProtocol
    private var allCoins = [CoinModel]()
    private var filterCoinData = [CoinModel]()
    private var searchText = ""
    private var isSearching: Bool {
        get {
            !searchText.isEmpty
        }
    }
    

    init(coinDataUseCase: CoinDataUseCaseProtocol = CoinDataUseCase()) {
        self.coinDataUseCase = coinDataUseCase
    }

    // MARK: - Public Methods

    func fetchCoinData() async -> Bool {
        do {
            let fetchedCoins = try await coinDataUseCase.fetchCoinData()
            allCoins = fetchedCoins
            return true
        } catch {
            print("Error: \(error.localizedDescription)")
            return false
        }
    }

    func getCoinCount() -> Int {
        return isSearching ? filterCoinData.count : allCoins.count
    }

    func getHomeCellConfig(forRow row: Int) -> HomeCellConfigModel {
        let coin = getCoin(forRow: row)
        return HomeCellConfigModel(rank: "\(coin.rank)",
                                   imageURL: coin.image,
                                   symbol: coin.symbol,
                                   currentPrice: coin.currentPrice.asCurrencyWith6Decimal(),
                                   priceChangePercentage24H: coin.priceChangePercentage24H?.asPencentageString() ?? "0.0%",
                                   priceChangePositive: (coin.priceChangePercentage24H ?? 0) >= 0)
    }

    func getCoin(forRow row: Int) -> CoinModel {
        return isSearching ? filterCoinData[row] : allCoins[row]
    }
    
    func updateSearchText(text: String) {
        self.searchText = text
        self.filterCoinData = filterCoins(text: text, coins: allCoins)
    }
}

fileprivate extension HomeViewModel {
    func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        let lowercaseText = text.lowercased()
        
        return coins.filter { (coins) -> Bool  in
            return coins.name.lowercased().contains(lowercaseText) ||
                   coins.id.lowercased().contains(lowercaseText) ||
                   coins.symbol.lowercased().contains(lowercaseText)
        }
    }

}
