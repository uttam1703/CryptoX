//
//  HomeVCBuilder.swift
//  CryptoX
//
//  Created by uttam ahir on 14/04/24.
//

import Foundation

struct HomeVCBuilder {
    func make() -> HomeViewController {
        let vc = HomeViewController()
        vc.vm = HomeViewModel()
        return vc
    }
}
