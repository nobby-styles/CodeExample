//
// Created by Robert Redmond on 23/03/2018.
// Copyright (c) 2018 RNR Apps. All rights reserved.
//

import Foundation

protocol WeatherDataManager {
    func getWeatherDataForLocation(long: Double, lat: Double, completionHandler: (@escaping (Error?, [Weather]?) -> ()))
}


class WeatherDataManagerImplementation: WeatherDataManager {
    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }


    func getWeatherDataForLocation(long: Double, lat: Double, completionHandler: (@escaping (Error?, [Weather]?) -> ())) {
        let parameters = "lat=\(lat)&lon=\(long)&appid=\(Constants.apiKey)"
        self.dataProvider.getData(apiStr: Constants.baseUrlStr, parameters: parameters) {
            [weak self] error, json in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                completionHandler(error, nil)
                return
            }
            guard  let jsonData = json as? [String: Any], let city = jsonData["city"] as? [String: Any], let cityName = city["name"] as? String, let cityCountry = city["country"] as? String,
                   let list = jsonData["list"] as? [[String: Any]], let weathers = strongSelf.weatherListParser(list: list, city: "\(cityName) \(cityCountry)") else {
                completionHandler(Errors.badDataError, nil)
                return
            }
            completionHandler(nil, weathers)
        }
    }

    fileprivate func weatherListParser(list: [[String: Any]], city: String) -> [Weather]? {
        var weathers = [Weather]()

        for weatherData in list {
            self.dataFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let dateTimeText = weatherData["dt_txt"] as? String, let main = weatherData["main"] as? [String: Any], let temp = main["temp"] as? Double, let weatherArr = weatherData["weather"] as? [[String: Any]],
               let weatherDesc = weatherArr.first?["description"] as? String, let icon = weatherArr.first?["icon"] as? String, let weatherDateTime = self.dataFormatter.date(from: dateTimeText) {
                self.dataFormatter.dateFormat = "HH:mm"
                let time = self.dataFormatter.string(from: weatherDateTime)
                let weather = Weather(location: city, date: weatherDateTime, temp: temp - 273.15, weatherDesc: weatherDesc, icon: icon, time: time)
                weathers.append(weather)
            }
        }
        return weathers.count > 0 ? weathers : nil
    }

    fileprivate let dataProvider: DataProvider
    fileprivate lazy var dataFormatter = DateFormatter()

}
