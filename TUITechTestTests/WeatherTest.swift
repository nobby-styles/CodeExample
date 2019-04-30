//
//  WeatherTest.swift
//  TUITechTestTests
//
//  Created by Robert Redmond on 25/03/2018.
//  Copyright © 2018 RNR Apps. All rights reserved.
//

import XCTest
@testable import TUITechTest

class WeatherTest: XCTestCase {
    
    
    
    func testTempString() {
        let weather = Weather(location: "London,GB", date: Date(), temp: 20.7, weatherDesc: "Sunny", icon: "17d", time: "13:55")
        XCTAssertEqual(weather.tempString, "20 C")
    }

    func testImageUrl(){
        let weather = Weather(location: "London,GB", date: Date(), temp: 20.7, weatherDesc: "Sunny", icon: "17d", time: "13:55")
        XCTAssertEqual(weather.imageUrl, "http://openweathermap.org/img/w/17d.png")
    }
    
    
}
