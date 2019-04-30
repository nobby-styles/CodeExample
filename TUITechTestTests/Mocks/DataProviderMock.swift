//
// Created by Robert Redmond on 24/03/2018.
// Copyright (c) 2018 RNR Apps. All rights reserved.
//

import Foundation

class DataProviderMock: DataProvider {
    var error: NSError?
    var data: Any?

    func getData(apiStr: String, parameters: String?, completionHandler: @escaping (Error?, Any?) -> ()) {
        if let error = self.error {
            completionHandler(error, nil)
        }
        if let data = self.data {
            completionHandler(nil, data)
        }
    }
}
