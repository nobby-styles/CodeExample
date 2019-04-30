//
// Created by Robert Redmond on 23/03/2018.
// Copyright (c) 2018 RNR Apps. All rights reserved.
//

import Foundation

struct Weather {
    let location: String
    let date: Date
    let temp: Double
    let weatherDesc: String
    let icon: String
    let time: String

    var tempString: String {
        return "\(Int(temp)) C"
    }

    var imageUrl: String {
        return String(format:Constants.baseImageUrlStr, icon)
    }
}
