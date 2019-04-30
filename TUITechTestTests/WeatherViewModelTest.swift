//
//  WeatherViewModelTest.swift
//  TUITechTestTests
//
//  Created by Robert Redmond on 24/03/2018.
//  Copyright © 2018 RNR Apps. All rights reserved.
//

import XCTest
@testable import TUITechTest

class WeatherViewModelTest: XCTestCase {

    var weatherViewModel: WeatherViewModel?

    func testFetchWeatherDataForLocationWithCorrectData() {
        if let path = Bundle.main.path(forResource: "correcttest", ofType: "json") {
            let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try! JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [String: Any] {
                let dataProviderMock = DataProviderMock()
                dataProviderMock.data = jsonResult
                let weatherDataManager = WeatherDataManagerImplementation(dataProvider: dataProviderMock)
                self.weatherViewModel = WeatherViewModel(dataManager: weatherDataManager)
                self.weatherViewModel?.fetchWeatherDataForLocation(long: 2, lat: 2) {
                    [weak self] success in
                    XCTAssertTrue(success)
                    if let strongSelf = self {
                        XCTAssertEqual(strongSelf.weatherViewModel?.locationDesc ?? "", "London GB")
                        XCTAssertEqual(strongSelf.weatherViewModel?.dayArr?.count ?? 0, 6)
                    }
                }
            }
        }
    }

    func testFetchWeatherDataForLocationWithNilData() {
        let dataProviderMock = DataProviderMock()
        dataProviderMock.data = nil
        let weatherDataManager = WeatherDataManagerImplementation(dataProvider: dataProviderMock)
        self.weatherViewModel = WeatherViewModel(dataManager: weatherDataManager)
        self.weatherViewModel?.fetchWeatherDataForLocation(long: 2, lat: 2) {
            [weak self] success in
            XCTAssertFalse(success)
            if let strongSelf = self, let weatherViewModel = strongSelf.weatherViewModel {
                XCTAssertNil(weatherViewModel.dayArr)
                XCTAssertNil(weatherViewModel.locationDesc)
            }
        }
    }


}
