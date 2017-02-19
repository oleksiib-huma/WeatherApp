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
    let transition = DetailViewAnimator()
    var currentOverlay = MKTileOverlay()
    var mapOverlay = MKTileOverlay()
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let initialLocation = CLLocation(latitude: initialLatitude, longitude: initialLongitude)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate, 1000000, 1000000)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.delegate = self
        
        let detailController = storyboard?.instantiateViewController(withIdentifier: "detail") as! DetailViewController
        detailController.transitioningDelegate = self
        detailController.modalPresentationStyle = .overCurrentContext
        detailController.pointCoordinates = CLLocationCoordinate2D(latitude: initialLatitude, longitude: initialLongitude)
        present(detailController, animated: true, completion: nil)
    }
    
    // MARK: - IBActions
    @IBAction func handleTap(_ sender: UILongPressGestureRecognizer) {
        
        let location = sender.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, 1000000, 1000000)
        mapView.setRegion(coordinateRegion, animated: true)
        let detailController = storyboard?.instantiateViewController(withIdentifier: "detail") as! DetailViewController
        detailController.transitioningDelegate = self
        detailController.modalPresentationStyle = .overCurrentContext
        detailController.pointCoordinates = coordinate
        present(detailController, animated: true, completion: nil)
    }
    
    @IBAction func unwindToMap(segue: UIStoryboardSegue) {
        let sourceController = segue.source as! MenuTableViewController
        setOverlay(option: sourceController.selectedOption)
    }
    
    // MARK: - Extra functions
    func setOverlay(option : String) {
        switch option {
        case "Temperature":
            if currentOverlay.urlTemplate != temperatureUrl {
                mapView.remove(currentOverlay)
                currentOverlay = MKTileOverlay(urlTemplate: temperatureUrl)
                mapView.add(currentOverlay)
            }
        case "Wind speed":
            if currentOverlay.urlTemplate != windSpeedUrl {
                mapView.remove(currentOverlay)
                currentOverlay = MKTileOverlay(urlTemplate: windSpeedUrl)
                mapView.add(currentOverlay)
            }
        case "Precipitation":
            if currentOverlay.urlTemplate != precipitationUrl {
                mapView.remove(currentOverlay)
                currentOverlay = MKTileOverlay(urlTemplate: precipitationUrl)
                mapView.add(currentOverlay)
            }
        case "Pressure":
            if currentOverlay.urlTemplate != pressureUrl {
                mapView.remove(currentOverlay)
                currentOverlay = MKTileOverlay(urlTemplate: pressureUrl)
                mapView.add(currentOverlay)
            }
        case "Open street map":
            if mapOverlay.urlTemplate != openStreetUrl {
                mapView.remove(mapOverlay)
                mapOverlay = MKTileOverlay(urlTemplate: openStreetUrl)
                mapOverlay.canReplaceMapContent = true
                mapView.add(mapOverlay)
            }
        case "Google map":
            if mapOverlay.urlTemplate != googleMapUrl {
                mapView.remove(mapOverlay)
                mapOverlay = MKTileOverlay(urlTemplate: googleMapUrl)
                mapOverlay.canReplaceMapContent = true
                mapView.add(mapOverlay)
            }
        case "Test polygon":
            let unsafePoints = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: 3)
            unsafePoints[0] = CLLocationCoordinate2D(latitude: 33.2, longitude: 28.5)
            unsafePoints[1] = CLLocationCoordinate2D(latitude: 51.3, longitude: 40.4)
            unsafePoints[2] = CLLocationCoordinate2D(latitude: 55.3, longitude: 30.1)
            let polygon = MKPolygon(coordinates: unsafePoints, count: 3)
            unsafePoints.deallocate(capacity: 3)
            polygon.title = "Test polygon"
            
            mapView.add(polygon)
        case "Default":
            mapView.remove(mapOverlay)        
        default:
            break
        }
    }
}

// MARK: - MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? MKTileOverlay {
            let render = MKTileOverlayRenderer(tileOverlay: overlay)
            return render
        } else if let overlay = overlay as? MKPolygon {
            let render = MKPolygonRenderer(polygon: overlay)
            render.strokeColor = UIColor.red
            render.lineWidth = 5
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
