//
//  ViewController.swift
//  WeatherApp
//
//  Created by Oleksiy Bilyi on 2/15/17.
//  Copyright © 2017 Oleksiy Bilyi. All rights reserved.
//

import UIKit
import MapKit

@IBDesignable class ViewController: UIViewController {
    
    // MARK: - Parameters
    let initialLatitude = 49.2327800
    let initialLongitude = 28.4809700
    let locationManager = CLLocationManager()
    let temperatureOverlay = MKTileOverlay(urlTemplate: "http://maps.owm.io:8099/5735d67f5836286b007625cd/{z}/{x}/{y}?hash=ba22ef4840c7fcb08a7a7b92bf80d1fc")
    let transition = DetailViewAnimator()
    
    lazy var selectedPointCoordinates : CLLocationCoordinate2D = {
        return CLLocationCoordinate2D(latitude: self.initialLatitude, longitude: self.initialLongitude)
    }()
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var changeMapSegment: UISegmentedControl!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        infoView.layer.backgroundColor = UIColor(white: 0, alpha: 0).cgColor
        
        navigationItem.titleView = changeMapSegment
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        let initialLocation = CLLocation(latitude: initialLatitude, longitude: initialLongitude)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate, 1000000, 1000000)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.delegate = self
        
    }
    
    // MARK: - IBActions
    @IBAction func handleTap(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        let detailController = storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailViewController
        
        detailController?.transitioningDelegate = self
        detailController?.modalPresentationStyle = .overCurrentContext
        detailController?.pointCoordinates = coordinate
        present(detailController!, animated: true, completion: nil)
    }
    
    @IBAction func mapChanges(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            mapView.add(temperatureOverlay)
            infoView.isHidden = false
        } else {
            mapView.remove(temperatureOverlay)
            infoView.isHidden = true
        }
    }
}

// MARK: - MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? MKTileOverlay {
            let render = MKTileOverlayRenderer(tileOverlay: overlay)
            return render
        }
        return MKOverlayRenderer()
    }
    
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentCoordinate = locations[0].coordinate
        let latitude = currentCoordinate.latitude
        let longitude = currentCoordinate.longitude
        self.locationManager.stopUpdatingLocation()
        
        let detailController = storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailViewController
        
        detailController?.transitioningDelegate = self
        detailController?.modalPresentationStyle = .overCurrentContext
        detailController?.pointCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        present(detailController!, animated: true, completion: nil)
        
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.originFrame = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
        return transition
    }
    
}
