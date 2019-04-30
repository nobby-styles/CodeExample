//
//  DataProvider.swift
//  TUITechTest
//
//  Created by Robert Redmond on 23/03/2018.
//  Copyright © 2018 RNR Apps. All rights reserved.
//

import Foundation

protocol DataProvider {
    func getData(apiStr: String, parameters: String?, completionHandler: @escaping (Error?, Any?) -> ())
}

class DataProviderImplementation: DataProvider {
    func getData(apiStr: String, parameters: String?, completionHandler: @escaping (Error?, Any?) -> ()) {
        var urlString = apiStr
        if let params = parameters {
            urlString = "\(apiStr)?\(params)"
        }
        guard let url = URL(string: urlString) else {
            completionHandler(Errors.malformedUrlError, nil)
            return
        }
        let dataTask = defaultSession.dataTask(with: url) {
            data, response, error in
            if let error = error {
                completionHandler(error, nil)
            } else if let httpResponse = response as? HTTPURLResponse {
                if let jsonData = data, httpResponse.statusCode == 200 {
                    var json: Any?
                    do {
                        json = try JSONSerialization.jsonObject(with: jsonData)
                        completionHandler(nil, json)
                    } catch {
                        completionHandler(error, nil)
                    }
                } else {

                    completionHandler(Errors.noDataError, nil)
                }
            }
        }
        dataTask.resume()
    }

    fileprivate let defaultSession = URLSession(configuration: URLSessionConfiguration.default)

}

