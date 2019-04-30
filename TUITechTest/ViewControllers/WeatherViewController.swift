//
// Created by Robert Redmond on 24/03/2018.
// Copyright (c) 2018 RNR Apps. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet var mapBarButton: UIBarButtonItem!
    
    var viewModel: WeatherViewModel?

    var userLocation: CLLocationCoordinate2D? {
        didSet {
            self.updateWeatherWithNewLocation()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // fix for bug in IOS 11.2 returning to parent controller, tint goes to greyed
        self.navigationController?.navigationBar.tintAdjustmentMode = .normal
        self.navigationController?.navigationBar.tintAdjustmentMode = .automatic
    }

    @IBAction func refreshLocationButton(_ sender: Any) {
        self.locationManager.startUpdatingLocation()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapViewController", let controller = segue.destination as? MapViewController {
            controller.delegate = self
        }
    }

    fileprivate func updateWeatherWithNewLocation() {
        guard let viewModel = self.viewModel, let userLocation = self.userLocation else {
            return
        }
        viewModel.fetchWeatherDataForLocation(long: userLocation.longitude, lat: userLocation.latitude) {
            [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.locationManager.stopUpdatingLocation()
                    self?.title = self?.viewModel?.locationDesc
                    self?.tableView.reloadData()
                }

            }

        }
    }


    fileprivate let locationManager = CLLocationManager()

}

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.dayArr?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        if let dict = self.viewModel?.dayArr?[indexPath.row], let date = dict.keys.first, let arr = dict[date] {
            cell.dateLabel.text = date
            cell.weathers = arr
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}

extension WeatherViewController: MapViewControllerDelegate {
    func updated(location: CLLocationCoordinate2D) {
        self.userLocation = location
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        self.userLocation = locValue

    }
}
