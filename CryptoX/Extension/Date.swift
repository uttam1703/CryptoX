//
//  Date.swift
//  CryptoX
//
//  Created by uttam ahir on 13/04/24.
//

import Foundation

extension Date {
    
    init(coinGechoString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: coinGechoString) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    private var shortFormmater: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    func asShortStringDate() -> String {
        return shortFormmater.string(from: self)
    }
}
