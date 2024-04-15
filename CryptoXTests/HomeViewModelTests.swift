//
//  HomeViewModelTests.swift
//  CryptoXTests
//
//  Created by uttam ahir on 14/04/24.
//

import XCTest
@testable import CryptoX

final class HomeViewModelTests: XCTestCase {
    
    var viewModel: HomeViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = HomeViewModel(coinDataUseCase: MockCoinDataUseCase())
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }
    
    func testFetchCoinData_Success() async throws {
        // Given
        let expectedCoins = [ConstantData.coinModel]
        
        // When
        let result = await viewModel.fetchCoinData()
        
        // Then
        XCTAssertTrue(result, "Fetch coin data should succeed")
        XCTAssertEqual(viewModel.getCoinCount(), expectedCoins.count, "Coin count should match")
    }
    
    
}

    // MockCoinDataUseCase for testing
class MockCoinDataUseCase: CoinDataUseCase {
    override func fetchCoinData() async throws -> [CoinModel] {
        // Simulate successful data fetching
        return [
            ConstantData.coinModel
        ]
    }
}
