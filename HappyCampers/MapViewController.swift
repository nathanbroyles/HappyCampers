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
            var annotation: MKPointAnnotation
            switch mapable {
            case let camper as Camper:
                annotation = CamperAnnotation(camper: camper)
            case let campsite as Campsite:
                annotation = CampsiteAnnotation(campsite: campsite)
            default:
                annotation = MKPointAnnotation()
            }
            annotation.coordinate = CLLocationCoordinate2D(latitude: mapable.lat, longitude: mapable.long)
            mapView.addAnnotation(annotation)
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView?
        let identifier: String
        let image: UIImage?
        let subtitleText: String?
        let nameText: String?
        let clusteringIdentifier: String?
        
        switch annotation {
        case let campsiteAnnotation as CampsiteAnnotation:
            identifier = String(describing: CampsiteAnnotation.self)
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            image = UIImage(named: "Tent")
            nameText = campsiteAnnotation.campsite.name
            subtitleText = campsiteAnnotation.campsite.subtitle()
            clusteringIdentifier = nil
        case let camperAnnotation as CamperAnnotation:
            identifier = String(describing: CamperAnnotation.self)
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            image = UIImage(named: "Kid")
            nameText = camperAnnotation.camper.name
            subtitleText = camperAnnotation.camper.subtitle()
            clusteringIdentifier = "Camper"
        default:
            return nil
        }
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = image
        annotationView?.clusteringIdentifier = clusteringIdentifier
        annotationView?.detailCalloutAccessoryView = calloutView(withTitle: nameText, subtitleText: subtitleText)

        return annotationView
    }
    
    func calloutView(withTitle titleText: String?, subtitleText: String?) -> UIView {
        let calloutView = UIStackView()
        calloutView.axis = .vertical
        calloutView.spacing = 8
        calloutView.widthAnchor.constraint(equalToConstant: 225).isActive = true
        
        let title = UILabel()
        title.text = titleText
        title.font = UIFont.boldSystemFont(ofSize: 13)
        
        let subtitle = UILabel()
        subtitle.numberOfLines = 0
        subtitle.text = subtitleText
        subtitle.font = UIFont.systemFont(ofSize: 12)
        
        calloutView.addArrangedSubview(title)
        calloutView.addArrangedSubview(subtitle)
        
        return calloutView
    }
}

class CampsiteAnnotation: MKPointAnnotation {
    
    let campsite: Campsite
    
    init(campsite: Campsite) {
        self.campsite = campsite
    }
}

class CamperAnnotation: MKPointAnnotation {
    
    let camper: Camper
    
    init(camper: Camper) {
        self.camper = camper
    }
}
