//
//  CoinDetailVCBuilder.swift
//  CryptoX
//
//  Created by uttam ahir on 14/04/24.
//

import Foundation

struct CoinDetailVCBuilder {
    func make(coin: CoinModel) -> CoinDetailViewController {
        let vc = CoinDetailViewController()
        vc.vm = CoinDetailViewModel(coinModel: coin)
        return vc
    }
}
