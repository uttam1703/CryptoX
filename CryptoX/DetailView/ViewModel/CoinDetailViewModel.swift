//
//  CoinDetailViewModel.swift
//  CryptoX
//
//  Created by uttam ahir on 12/04/24.
//

import Foundation


final class CoinDetailViewModel {
    
    private var coinModel: CoinModel
    private let coinDetailUC: CoinDetailDataUseCase
    private var coinDetailModel: CoinDetailModel? = nil
    private var statisticModels = [StatisticModel]()
    
    init(coinModel: CoinModel,
         coinDetailUC: CoinDetailDataUseCase = CoinDetailDataUseCase()) {
        self.coinModel = coinModel
        self.coinDetailUC = coinDetailUC
//        createCoinDetailStatistics()
    }
    
    func fetchCoinDetail() async -> Bool {
        do {
            let model = try await coinDetailUC.fetchCoinDetailData(forCoinId: coinModel.id)
            coinDetailModel = model
            createCoinDetailStatistics()
            return true
        } catch {
            print("Error: \(error.localizedDescription)")
            return false
        }
    }
    
    func getCoinDetailResponse() -> CoinDetailDescriptionModel? {
        guard let model = coinDetailModel else { return nil }
        print(model.links?.subredditURL ?? "")
        return .init(coinDescription: model.readableDescription,
                     websiteURL: model.links?.homepage?.first,
                     redditURL: model.links?.subredditURL)
    }
    
    func getStatisticModelCount() -> Int {
        statisticModels.count
    }
    
    func getStatisticModel(forRow row: Int) -> StatisticModel {
        guard statisticModels.count > row else {
            return .init(title: "N/A", value: "N/A")
        }
        return statisticModels[row]
    }
    
    func getCoinModel() -> CoinModel {
        coinModel
    }
    
    func getCoinImage() -> String {
        coinModel.image 
    }
    
}

fileprivate extension CoinDetailViewModel {
    func createCoinDetailStatistics() {
        guard let coinDetailModel = coinDetailModel else { return  }
        let price = coinModel.currentPrice.asCurrencyWith6Decimal()
        let pricePercentageChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentageChange)
        
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentageChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentageChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        let high = coinModel.high24H?.asCurrencyWith6Decimal() ?? "n/a"
        let highStat = StatisticModel(title: "24h High", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith6Decimal() ?? "n/a"
        let lowStat = StatisticModel(title: "24h Low", value: low)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimal() ?? "n/a"
//        let pricePercentageChange = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentageChange)
        
        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
//        let marketCapPercentageChange = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat24H = StatisticModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentageChange)
        
        let blockTime = coinDetailModel.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockTimeStat = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailModel.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        statisticModels = [priceStat, marketCapStat, rankStat, volumeStat, highStat, lowStat, priceChangeStat, marketCapChangeStat24H, blockTimeStat, hashingStat]
    }

}
