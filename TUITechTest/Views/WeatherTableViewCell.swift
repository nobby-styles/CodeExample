//
// Created by Robert Redmond on 24/03/2018.
// Copyright (c) 2018 RNR Apps. All rights reserved.
//

import Foundation
import UIKit

class WeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    var weathers: [Weather]? {
        didSet {
            self.collectionView.reloadData()
        }
    }
}

extension WeatherTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.weathers?.count ?? 0
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherForecastCollectionViewCell", for: indexPath as IndexPath) as! WeatherForecastCollectionViewCell
        if let weathers = self.weathers {
            let weather = weathers[indexPath.row]
            cell.tempLabel.text = weather.tempString
            cell.timeLabel.text = weather.time
            cell.weatherImageView.loadImageUsingCache(withUrl: weather.imageUrl)
        }
        return cell
    }

}
