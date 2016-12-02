//
//  ViewController.swift
//  RouteBasedAlerts
//
//  Created by Daniel Ferguson on 7/18/16.
//  Copyright © 2016 Daniel Ferguson. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var centerMeButton: UIButton!
    
    let clManager: CLLocationManager;
    var followUser: Bool;
    let profile: Profile!;
    let geoCoder: CLGeocoder!
    
    required init?(coder aDecoder: NSCoder) {
        self.clManager = CLLocationManager();
        self.followUser = true;
        self.profile = Profile();
        self.geoCoder = CLGeocoder();
        
        
        super.init(coder: aDecoder);
    }
    
    // MARK: Private initialization methods
    fileprivate func initializeLocationManager() -> Void {
        self.clManager.delegate = self;
        self.clManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.clManager.requestAlwaysAuthorization()
        self.clManager.startUpdatingLocation()
    }
    
    fileprivate func initializeMapView() -> Void {
        // TODO: I would like to assign multiple delegates to this mapView.
        // Is that possible? My idea is that if I want something to only fire once for 
        // a location update, I can add and remove delegates. Still researching...
        self.mapView.delegate = self;
        
        
        self.mapView.showsUserLocation = true;
        
        let mapDragGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ViewController.didDragMap(_:)));
        mapDragGestureRecognizer.delegate = self;
        self.mapView.addGestureRecognizer(mapDragGestureRecognizer);
        
        let mapTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTapMap(_:)));
        mapTapGestureRecognizer.delegate = self;
        self.mapView.addGestureRecognizer(mapTapGestureRecognizer);
    }
    
    @IBAction func userDidRequestCenterMap(_ sender: UIButton) {
        // This button should center the map on the users current location
        self.followUser = true;
    }
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // initialize core location manager
        self.initializeLocationManager()
        
        // initialize map
        self.initializeMapView();
    }
    
    // MARK: UIPanGestureRecognizer handler
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }
    
    func didDragMap(_ sender: UIGestureRecognizer) -> Void {

        print("Map panned. sender: \(sender.state.rawValue)")
    }
    
    // MARK: UITapGestureRecognizer handler
    func didTapMap(_ sender: UIPanGestureRecognizer) -> Void {
        if sender.state == UIGestureRecognizerState.ended {
            self.mapView.removeAnnotations(self.mapView.annotations);
            let point = sender.location(in: self.mapView);
            let location = self.mapView.convert(point, toCoordinateFrom: self.mapView);
            let placemark = MKPlacemark(coordinate: location, addressDictionary: nil);
            self.mapView.addAnnotation(placemark);
        }
        print("map tapped. State: \(sender.state)")
    }
    
    // MARK: UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true;
    }
    
    // MARK: CLLocationManager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.profile.addLocation(location.coordinate);
            if self.profile.isStationary {
                
                manager.stopUpdatingLocation()
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    // MARK: MKMapView
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        print("*** did finish loading fired!")
        let location = self.mapView.userLocation.coordinate;
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true);
    }
}

