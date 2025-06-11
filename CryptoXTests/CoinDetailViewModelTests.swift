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
        let viewModel: CoinDetailViewModelProtocol = CoinDetailViewModel(coinModel: mockCoinModel, coinDetailUC: MockCoinDetailDataUseCase())
        
        // When
        let response = await viewModel.fetchCoinDetail()
        // Then
        XCTAssertTrue(response)
        XCTAssertNotNil(viewModel.getCoinDetailResponse())
        XCTAssertEqual(viewModel.getStatisticModelCount(), 10)
    }
    
    func testFetchCoinDetailFailure() async {
        // Given
        let mockUseCase = MockCoinDetailDataUseCase()
        let viewModel = CoinDetailViewModel(coinModel: mockCoinModel, coinDetailUC: mockUseCase)
    
        
        // When
        let response = await viewModel.fetchCoinDetail()
        
        // Then
        XCTAssertFalse(response)
        XCTAssertNil(viewModel.getCoinDetailResponse())
        XCTAssertEqual(viewModel.getStatisticModelCount(), 0)    }
        
       
}

//// Mock CoinDetailDataUseCase for testing
class MockCoinDetailDataUseCase: CoinDetailDataUseCaseProtocol {
    var shouldThrowError = false
    func fetchCoinDetailData(forCoinId coinId: String) async throws -> CoinDetailModel? {
        if shouldThrowError {
            throw APIError.networkError(nil)
        }
        return ConstantData.coinDetailModel
    }
}

