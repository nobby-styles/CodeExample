//
//  MapViewController.swift
//  TUITechTest
//
//  Created by Robert Redmond on 25/03/2018.
//  Copyright © 2018 RNR Apps. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol MapViewControllerDelegate: class {
    func updated(location: CLLocationCoordinate2D)
}

class MapViewController: UIViewController {
    @IBOutlet fileprivate weak var mapView: MKMapView!

    weak var delegate: MapViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognizer:)))
        gestureRecognizer.delegate = self as? UIGestureRecognizerDelegate
        self.mapView?.addGestureRecognizer(gestureRecognizer)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Get forecast for location", style: .plain, target: self, action: #selector(pressGetForecast))
    }

    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        if !(parent != nil) {
            if let location = self.currentLocation {
                self.delegate?.updated(location: location)
            }
        }


    }

    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        let touchLocation = gestureRecognizer.location(in: self.mapView)
        if let locationCoordinate = mapView?.convert(touchLocation, toCoordinateFrom: self.mapView) {
            self.stopUpdatingLocation = true
            self.currentLocation = locationCoordinate
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationCoordinate
            let allAnnotations = self.mapView!.annotations
            self.mapView?.removeAnnotations(allAnnotations)
            self.mapView?.addAnnotation(annotation)
            self.centreMap(coordinate: locationCoordinate)
        }
    }

    @objc func pressGetForecast() {
        navigationController?.popViewController(animated: true)
    }

    fileprivate func centreMap(coordinate: CLLocationCoordinate2D) {
        let span = MKCoordinateSpanMake(0.050, 0.050)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
    }

    fileprivate var currentLocation: CLLocationCoordinate2D?
    fileprivate var stopUpdatingLocation = true

}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if stopUpdatingLocation == true {
            centreMap(coordinate: userLocation.coordinate)
        }
    }

}


