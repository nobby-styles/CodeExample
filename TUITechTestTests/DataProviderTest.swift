//
//  TUITechTestTests.swift
//  TUITechTestTests
//
//  Created by Robert Redmond on 23/03/2018.
//  Copyright © 2018 RNR Apps. All rights reserved.
//

import XCTest
@testable import TUITechTest

class Tests: XCTestCase {

    func testDataProviderGetWithValidUrlAndApiKey() {
        let expectation = XCTestExpectation(description: "getWeatherData")
        let dataProvider = DataProviderImplementation()
        dataProvider.getData(apiStr: Constants.baseUrlStr, parameters: "lat=51.7527&lon=-0.3394&appid=\(Constants.apiKey)") {
            error, json in
            XCTAssertNil(error)
            XCTAssertNotNil(json)
            if let jsonData = json as? [String: Any], let cod = jsonData["cod"] as? Int {
                XCTAssertEqual(cod, 200)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 20.0)
    }

    func testDataProviderGetWithValidUrlNoApiKey() {
        let expectation = XCTestExpectation(description: "getWeatherData")
        let dataProvider = DataProviderImplementation()
        dataProvider.getData(apiStr: Constants.baseUrlStr, parameters: "lat=51.7527&long=-0.339") {
            error, json in
            XCTAssertNotNil(error)
            XCTAssertNil(json)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 20.0)
    }

    func testDataProviderGetWithValidUrlNoParams() {
        let expectation = XCTestExpectation(description: "getWeatherData")
        let dataProvider = DataProviderImplementation()
        dataProvider.getData(apiStr: Constants.baseUrlStr, parameters: nil) {
            error, json in
            XCTAssertNotNil(error)
            XCTAssertNil(json)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 20.0)
    }

    func testDataProviderGetWithBadUrl() {
        let expectation = XCTestExpectation(description: "getWeatherData")
        let dataProvider = DataProviderImplementation()
        dataProvider.getData(apiStr: "bbbc.com", parameters: nil) {
            error, json in
            XCTAssertNotNil(error)
            XCTAssertNil(json)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 20.0)
    }


}
