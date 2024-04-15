//
//  CoinDescriptionVCBuilder.swift
//  CryptoX
//
//  Created by uttam ahir on 14/04/24.
//

import Foundation

struct CoinDescriptionVCBuilder {
    func make(forModel model: CoinDetailDescriptionModel) -> CoinDescriptionViewController {
        let vc = CoinDescriptionViewController()
        vc.model = model
        return vc
    }
}
