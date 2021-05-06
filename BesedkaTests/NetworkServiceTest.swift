//
//  NetworkServiceTest.swift
//  BesedkaTests
//
//  Created by Ivan Kopiev on 06.05.2021.
//

import XCTest
@testable import Besedka

class NetworkServiceTest: XCTestCase {
    
    var coreNetwork: MockCoreNetwork!
    var serviceNetwork: NetworkService!
    var cache: ImageCacheProtocol!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        coreNetwork = MockCoreNetwork()
        cache = ImageCache()
        serviceNetwork = NetworkService(network: coreNetwork, cache: cache)
    }
    
    override func tearDownWithError() throws {
        coreNetwork = nil
        cache = nil
        serviceNetwork = nil
        try super.tearDownWithError()
    }
    
    func testValidURLString() {
        // Arrange
        let testUrlString = "https://pixabay.com/api/?key=21189137-e91aebb15d83ce97f04ecb4d6&q=yellow&image_type=photo&pretty=true&per_page=200"
        // Act
        let result = serviceNetwork.createUrlWithCode("yellow")
        // Assert
        XCTAssertEqual(result, testUrlString)
    }
    
    func testCalledCoreFunction() {
        XCTAssertFalse(coreNetwork.isCalled)
        serviceNetwork.getImagesUrls(withCode: "yellow") { _ in}
        XCTAssert(coreNetwork.isCalled, "Must be true")
    }
    
    func testCountCalledCoreFunction() {
        serviceNetwork.getImagesUrls(withCode: "yellow") { _ in}
        XCTAssertEqual(coreNetwork.countCalled, 1)
    }
    
    func testForFindingAnImageInTheCache() throws {
        // Arrange
        let testUrlString = "https://pixabay.com/api/?key=21189137-e91aebb15d83ce97f04ecb4d6&q=yellow&image_type=photo&pretty=true&per_page=200"
        guard let testImage = UIImage(named: "emblem") else {
            XCTFail("Error init Image")
            return
        }
        cache.save(image: testImage, forKey: testUrlString)
        var imageResult: UIImage?
        let imageExpectation = expectation(description: "Image expectation")
        // Act
        serviceNetwork.getImage(fromUrlString: testUrlString) { image in
            imageResult = image
            imageExpectation.fulfill()
        }
        // Assert
        waitForExpectations(timeout: 2) { _ in
            XCTAssertEqual(imageResult, testImage)
        }
    }
}

extension NetworkServiceTest {
    
    class MockCoreNetwork: Network {
        var isCalled: Bool = false
        var countCalled = 0
        
        override func getDataFrom(fromUrlString url: String, _ completion: @escaping (Data) -> Void) {
            isCalled = true
            countCalled += 1
        }
    }
}
