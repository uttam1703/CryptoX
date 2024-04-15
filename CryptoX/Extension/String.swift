//
//  String.swift
//  CryptoX
//
//  Created by uttam ahir on 10/04/24.
//

import Foundation

extension String {
    
    var removingHTMLOccurance: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
