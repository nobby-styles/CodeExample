//
// Created by Robert Redmond on 24/03/2018.
// Copyright (c) 2018 RNR Apps. All rights reserved.
//

import Foundation

class WeatherViewModel {
    init(dataManager: WeatherDataManager) {
        self.dataManager = dataManager
    }

    var dayArr: [[String: [Weather]]]?

    var locationDesc: String?

    func fetchWeatherDataForLocation(long: Double, lat: Double, completionHandler: (@escaping (Bool) -> ())) {
        dataManager.getWeatherDataForLocation(long: long, lat: lat) {
            [weak self]error, weathers in
            guard let strongSelf = self else {
                return
            }
            guard let weathers = weathers else {
                completionHandler(false)
                return
            }
            strongSelf.locationDesc = weathers.first?.location
            strongSelf.dataFormatter.dateFormat = "dd MMM  YYYY"
            var arrOfDays = [[String: [Weather]]]()
            let sortedWeather = weathers.sorted(by: { $0.date.compare($1.date) == .orderedAscending })
            let weekdays = Array(NSOrderedSet(array: sortedWeather.map({
                strongSelf.dataFormatter.string(from: $0.date)
            })))
            for case let day as String in weekdays {
                let filteredWeathers = weathers.filter({
                    strongSelf.dataFormatter.string(from: $0.date) == day
                })
                arrOfDays.append([day: filteredWeathers])
            }
            guard arrOfDays.count > 0 else {
                completionHandler(false)
                return
            }
            strongSelf.dayArr = arrOfDays
            completionHandler(true)
        }
    }


    fileprivate let dataManager: WeatherDataManager
    fileprivate lazy var dataFormatter = DateFormatter()
}
