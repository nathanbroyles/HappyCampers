//
//  ViewController.swift
//  HappyCampers
//
//  Created by Nathan Broyles on 11/29/19.
//  Copyright © 2019 DeadPixel. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var campers: [Camper] = [Camper]() {
        didSet {
            map(campers)
        }
    }
    
    let mapCenter = CLLocationCoordinate2D(latitude: 44.4280, longitude: -110.5885)
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Model.loadCampsites { (campsites) in
            self.map(campsites)
        }
        
        Model.createCampers(around: mapCenter) { (campers) in
            self.campers = campers
        }
        
        mapView.setCenter(mapCenter, animated: true)
        let latLongMeterSpan: CLLocationDistance = 130000
        let region = MKCoordinateRegion(center: mapCenter, latitudinalMeters: latLongMeterSpan, longitudinalMeters: latLongMeterSpan)
        mapView.setRegion(region, animated: true)
    }
    
    func map(_ annotations: [Mapable]?) {
        for mapable in annotations ?? [] {
            let annotation = CampingAnnotation(mapable: mapable)
            annotation.coordinate = CLLocationCoordinate2D(latitude: mapable.lat, longitude: mapable.long)
            mapView.addAnnotation(annotation)
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let campingAnnotation = annotation as? CampingAnnotation else {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: campingAnnotation.dequeueIdentifier)
        
        if annotationView == nil {
            annotationView = campingAnnotation.annotationView(with: campingAnnotation)
        } else {
            annotationView?.annotation = campingAnnotation
        }
        
        return annotationView
    }
}
