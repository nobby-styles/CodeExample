//
//  DataManagerTest.swift
//  TUITechTest
//
//  Created by Robert Redmond on 24/03/2018.
//  Copyright © 2018 RNR Apps. All rights reserved.
//

import XCTest
@testable import TUITechTest

class WeatherDataManagerTest: XCTestCase {
    func testWeatherDataManagerGetWeatherDataForLocationWithValidData() {
        if let path = Bundle.main.path(forResource: "correcttest", ofType: "json") {
            let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try! JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [String: Any] {
                let dataProviderMock = DataProviderMock()
                dataProviderMock.data = jsonResult
                let weatherDataManager = WeatherDataManagerImplementation(dataProvider: dataProviderMock)
                weatherDataManager.getWeatherDataForLocation(long: 2, lat: 2) {
                    error, weatherArr in
                    XCTAssertNil(error)
                    XCTAssertNotNil(weatherArr)
                    XCTAssertEqual(weatherArr?.count, 40)
                    if let firstWeather = weatherArr?.first {
                        XCTAssertEqual(firstWeather.location, "London GB")
                        XCTAssertEqual(firstWeather.temp, 11.150000000000034)
                        XCTAssertEqual(firstWeather.weatherDesc, "light rain")
                        XCTAssertEqual(firstWeather.icon, "10d")
                        XCTAssertEqual(firstWeather.date.description, "2018-03-23 15:00:00 +0000")
                        XCTAssertEqual(firstWeather.time, "15:00" )
                    }
                }
            }
        }
    }

    func testWeatherDataManagerGetWeatherDataForLocationWithInvalidData() {
        if let path = Bundle.main.path(forResource: "incorrecttest", ofType: "json") {
            let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try! JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [String: Any] {
                let dataProviderMock = DataProviderMock()
                dataProviderMock.data = jsonResult
                let weatherDataManager = WeatherDataManagerImplementation(dataProvider: dataProviderMock)
                weatherDataManager.getWeatherDataForLocation(long: 2, lat: 2) {
                    error, weatherArr in
                    XCTAssertNotNil(error)
                    XCTAssertNil(weatherArr)
                    if let err = error as NSError? {
                        XCTAssertEqual(err, Errors.badDataError)
                    }
                }
            }
        }
    }

    func testWeatherDataManagerGetWeatherDataForLocationWithErrorFromDataProvider() {
        let dataProviderMock = DataProviderMock()
        dataProviderMock.error = Errors.noDataError
        let weatherDataManager = WeatherDataManagerImplementation(dataProvider: dataProviderMock)
        weatherDataManager.getWeatherDataForLocation(long: 2, lat: 2) {
            error, weatherArr in
            XCTAssertNotNil(error)
            XCTAssertNil(weatherArr)
            if let err = error as NSError? {
                XCTAssertEqual(err, Errors.noDataError)
            }
        }
    }
}

