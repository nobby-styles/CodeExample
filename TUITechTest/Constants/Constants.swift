//
//  Constants.swift
//  TUITechTest
//
//  Created by Robert Redmond on 23/03/2018.
//  Copyright © 2018 RNR Apps. All rights reserved.
//

import Foundation

struct Constants {
    static let apiKey: String = "e1a41b6469621828cae98efbb452c34b"
    static let baseUrlStr: String = "http://api.openweathermap.org/data/2.5/forecast"
    static let baseImageUrlStr = "http://openweathermap.org/img/w/%@.png"
}

struct Errors {
    static let noDataError = NSError(domain: "no data", code: 124)
    static let badDataError = NSError(domain: "bad data", code: 125)
    static let malformedUrlError = NSError(domain: "malformed url", code: 123)
}

