//
//  ViewController.swift
//  WeatherApp
//
//  Created by Oleksiy Bilyi on 2/15/17.
//  Copyright © 2017 Oleksiy Bilyi. All rights reserved.
//

import UIKit
import MapKit

public extension UIView {
    
    public func snapshotImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImage
    }
    
    public func snapshotView() -> UIView? {
        if let snapshotImage = snapshotImage() {
            return UIImageView(image: snapshotImage)
        } else {
            return nil
        }
    }
}

@IBDesignable class ViewController: UIViewController {
    
    // MARK: - Parameters
    let initialLatitude = 49.2327800
    let initialLongitude = 28.4809700
    let locationManager = CLLocationManager()
    let transition = DetailViewAnimator()
    let menuTransition = MenuViewAnimator()
    var currentOverlay = MKTileOverlay()
    var mapOverlay = MKTileOverlay()
    var tapAnnotation : WeatherCustomAnnotation? = nil
    var tapCoordinates = CLLocationCoordinate2D()
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsSegue" {
            if let detailController = segue.destination as? DetailViewController {
                detailController.transitioningDelegate = self
                detailController.modalPresentationStyle = .overCurrentContext
                detailController.pointCoordinates = tapCoordinates
            }
        } else if segue.identifier == "menuSegue" {
            if let menuController = segue.destination as? MenuTableViewController {
                menuController.transitioningDelegate = menuTransition
                menuController.modalPresentationStyle = .overCurrentContext
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: mapView)
        tapCoordinates = mapView.convert(location, toCoordinateFrom: mapView)
        let centerCordinates = CLLocationCoordinate2D(latitude: tapCoordinates.latitude + 3, longitude: tapCoordinates.longitude)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(centerCordinates, 1000000, 1000000)
        
        if let tapAnnotation  = self.tapAnnotation {
            mapView.removeAnnotation(tapAnnotation)
        }
        
        tapAnnotation = WeatherCustomAnnotation(coordinate: tapCoordinates)
        mapView.addAnnotation(tapAnnotation!)
        
        mapView.setRegion(coordinateRegion, animated: true)
        performSegue(withIdentifier: "detailsSegue", sender: nil)
    }
    
    @IBAction func unwindToMap(segue: UIStoryboardSegue) {
        let sourceController = segue.source as! MenuTableViewController
        setOverlay(option: sourceController.selectedOption)
        sourceController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Extra functions
    func addMapTile(urlTemplate: String?) {
        guard let urlTemplate = urlTemplate else {
            mapView.remove(currentOverlay)
            currentOverlay = MKTileOverlay()
            return
        }
        if currentOverlay.urlTemplate != urlTemplate {
            mapView.remove(currentOverlay)
            currentOverlay = MKTileOverlay(urlTemplate: urlTemplate)
            mapView.add(currentOverlay)
        }
    }
    
    func replaceMap(urlTemplate: String?) {
        guard let urlTemplate = urlTemplate else {
            mapView.remove(mapOverlay)
            mapOverlay = MKTileOverlay()
            return
        }
        if mapOverlay.urlTemplate != urlTemplate {
            mapView.remove(mapOverlay)
            mapOverlay = MKTileOverlay(urlTemplate: urlTemplate)
            mapOverlay.canReplaceMapContent = true
            mapView.insert(mapOverlay, at: 0)
        }
    }
    
    func setOverlay(option : MapsOptions) {
        switch option {
        case .NoneTile:
            addMapTile(urlTemplate: nil)
        case .TemperatureTile:
            addMapTile(urlTemplate: temperatureUrl)
        case .WindSpeedTile:
            addMapTile(urlTemplate: windSpeedUrl)
        case .PrecipitationTile:
            addMapTile(urlTemplate: precipitationUrl)
        case .PressureTile:
            addMapTile(urlTemplate: pressureUrl)
        case .OpenStreetMap:
            replaceMap(urlTemplate: openStreetUrl)
        case .GoogleMap:
            replaceMap(urlTemplate: googleMapUrl)
        case .DefaultMap:
            replaceMap(urlTemplate: nil)
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? WeatherCustomAnnotation {
            let identifier = "touchPin"
            var view : MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                UIGraphicsBeginImageContext(CGSize(width: 20, height: 20))
                #imageLiteral(resourceName: "circle").draw(in: CGRect(x: 0, y: 0, width: 20, height: 20))
                let circleImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                view.image = circleImage
                view.canShowCallout = false
            }
            return view
        }
        return nil
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
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
}
