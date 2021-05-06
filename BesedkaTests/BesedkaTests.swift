//
//  BesedkaTests.swift
//  BesedkaTests
//
//  Created by Ivan Kopiev on 06.05.2021.
//

import XCTest
@testable import Besedka
class BesedkaTests: XCTestCase {
    var sut: AvatatarCollectionViewController!
    var coreNetwork: NetworkProtocol!
    var serviceNetwork: NetworkServiceProtocol!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        coreNetwork = MockCoreNetwork()
        serviceNetwork = MockServiceNetwork()
        sut = AvatatarCollectionViewController(network: serviceNetwork)
    }

    override func tearDownWithError() throws {
        
        try super.tearDownWithError()
    }

    func testCalledCoreLayer() throws {

    }
}

extension BesedkaTests {
    
    class MockCoreNetwork: Network {
        
    }
    
    class MockServiceNetwork: NetworkService {
        
    }
    
}
