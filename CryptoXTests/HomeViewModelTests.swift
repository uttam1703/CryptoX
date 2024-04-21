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
    
    func testFetchCoinDataSuccess() async throws {
        // Given
        viewModel = HomeViewModel(coinDataUseCase: MockCoinDataUseCase())
        let expectedCoins = [ConstantData.coinModel]
        
        // When
        let result = await viewModel.fetchCoinData()
        
        // Then
        XCTAssertTrue(result, "Fetch coin data should succeed")
        XCTAssertEqual(viewModel.getCoinCount(), expectedCoins.count, "Coin count should match")
    }
    
    func testFetchCoinDataFail() async throws {
        // Given
        let mockUseCase = MockCoinDataUseCase()
        mockUseCase.shouldThrowError = true
        viewModel = HomeViewModel(coinDataUseCase: mockUseCase)
        
        let expectedCoinsCount = 0
        
        // When
        let result = await viewModel.fetchCoinData()
        
        // Then
        XCTAssertFalse(result, "Fetch coin data should fail")
        XCTAssertEqual(viewModel.getCoinCount(), expectedCoinsCount, "Coin count should match")
    }
    
}

    // MockCoinDataUseCase for testing
class MockCoinDataUseCase: CoinDataUseCase {
    var shouldThrowError = false
    override func fetchCoinData() async throws -> [CoinModel] {
        // Simulate successful data fetching
        if shouldThrowError {
            throw APIError.networkError(nil)
        }
        return [
            ConstantData.coinModel
        ]
    }
}
