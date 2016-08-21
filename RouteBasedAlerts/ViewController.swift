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
    var userChangedRegion: Bool;
    let profile: Profile!;
    let geoCoder: CLGeocoder!
    
    required init?(coder aDecoder: NSCoder) {
        self.clManager = CLLocationManager();
        self.userChangedRegion = false;
        self.profile = Profile();
        self.geoCoder = CLGeocoder();
        
        
        super.init(coder: aDecoder);
    }
    
    // MARK: Private initialization methods
    private func initializeLocationManager() -> Void {
        self.clManager.delegate = self;
        self.clManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.clManager.requestAlwaysAuthorization()
        self.clManager.startUpdatingLocation()
    }
    
    private func initializeMapView() -> Void {
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
    
    @IBAction func userDidRequestCenterMap(sender: UIButton) {
        // This button should center the map on the users current location
        
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
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }
    
    func didDragMap(sender: UIGestureRecognizer) -> Void {
        self.userChangedRegion = true;
        print("Map panned. sender: \(sender.state.rawValue)")
    }
    
    // MARK: UITapGestureRecognizer handler
    func didTapMap(sender: UIPanGestureRecognizer) -> Void {
        if sender.state == UIGestureRecognizerState.Ended {
            self.mapView.removeAnnotations(self.mapView.annotations);
            let point = sender.locationInView(self.mapView);
            let location = self.mapView.convertPoint(point, toCoordinateFromView: self.mapView);
            let placemark = MKPlacemark(coordinate: location, addressDictionary: nil);
            self.mapView.addAnnotation(placemark);
        }
        print("map tapped. State: \(sender.state)")
    }
    
    // MARK: UIGestureRecognizerDelegate
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return true;
    }
    
    // MARK: CLLocationManager
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.profile.addLocation(location.coordinate);
            if self.profile.isStationary {
                
                manager.stopUpdatingLocation()
            }
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
    }
    
    // MARK: MKMapView
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
    }
    
    func mapViewDidFinishLoadingMap(mapView: MKMapView) {
        print("*** did finish loading fired!")
        let location = self.mapView.userLocation.coordinate;
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true);
    }
}

