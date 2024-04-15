//
//  CoinDetailViewModelTests.swift
//  CryptoXTests
//
//  Created by uttam ahir on 14/04/24.
//

import XCTest
@testable import CryptoX

final class CoinDetailViewModelTests: XCTestCase {

    // Mock CoinModel for testing
    let mockCoinModel: CoinModel = ConstantData.coinModel
        // Mock CoinDetailModel for testing
    let mockCoinDetailModel: CoinDetailModel = ConstantData.coinDetailModel
    
    
    
    func testFetchCoinDetailSuccess() async {
        // Given
        let viewModel = CoinDetailViewModel(coinModel: mockCoinModel, coinDetailUC: MockCoinDetailDataUseCase())
        
        // When
        let responce = await viewModel.fetchCoinDetail()
        // Then
        XCTAssertTrue(responce)
        XCTAssertNotNil(viewModel.getCoinDetailResponse())
        XCTAssertEqual(viewModel.getStatisticModelCount(), 10) // Assuming all statistics are added
    }
    
    func testFetchCoinDetailFailure() async {
        // Given
        let mockUseCase = MockCoinDetailDataUseCase()
        mockUseCase.shouldThrowError = true
        let viewModel = CoinDetailViewModel(coinModel: mockCoinModel, coinDetailUC: mockUseCase)
    
        
        // When
        let responce = await viewModel.fetchCoinDetail()
        
        // Then
        XCTAssertFalse(responce)
        XCTAssertNil(viewModel.getCoinDetailResponse())
        XCTAssertEqual(viewModel.getStatisticModelCount(), 0) // Assuming no statistics are added due to failure
    }
        
       
}

// Mock CoinDetailDataUseCase for testing
class MockCoinDetailDataUseCase: CoinDetailDataUseCase {
    var shouldThrowError = false
    let mockCoinDetailModel: CoinDetailModel = ConstantData.coinDetailModel
    override func fetchCoinDetailData(forCoinId coinId: String) async throws -> CoinDetailModel? {
        if shouldThrowError {
            throw APIError.networkError(nil)
        }
        return mockCoinDetailModel
    }
}

