//
//  CampingAnnotation.swift
//  HappyCampers
//
//  Created by Nathan Broyles on 11/30/19.
//  Copyright © 2019 DeadPixel. All rights reserved.
//

import Foundation
import MapKit

class CampingAnnotation: MKPointAnnotation {
    
    let mapable: Mapable
    
    var dequeueIdentifier: String {
        get {
            switch mapable {
            case is Camper:
                return String(describing: Camper.self)
            case is Campsite:
                return String(describing: Campsite.self)
            default:
                return ""
            }
        }
    }
    
    var clusteringIdentifier: String? {
        get {
            switch mapable {
            case is Camper:
                return String(describing: Camper.self)
            default:
                return nil
            }
        }
    }
    
    var image: UIImage? {
        get {
            switch mapable {
            case is Camper:
                return UIImage(named: "Kid")
            case is Campsite:
                return UIImage(named: "Tent")
            default:
                return nil
            }
        }
    }
    
    init(mapable: Mapable) {
        self.mapable = mapable
        super.init()
        self.coordinate = CLLocationCoordinate2D(latitude: mapable.lat, longitude: mapable.long)
    }
    
    func annotationView(with annotation: CampingAnnotation) -> MKPinAnnotationView {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: dequeueIdentifier)
        annotationView.image = image
        annotationView.clusteringIdentifier = clusteringIdentifier
        annotationView.detailCalloutAccessoryView = calloutView()
        annotationView.canShowCallout = true
        return annotationView
    }
    
    func calloutView() -> UIView {
        let calloutView = UIStackView()
        calloutView.axis = .vertical
        calloutView.spacing = 8
        calloutView.widthAnchor.constraint(equalToConstant: 225).isActive = true
        
        let title = UILabel()
        title.text = mapable.name
        title.font = UIFont.boldSystemFont(ofSize: 13)
        
        let subtitle = UILabel()
        subtitle.numberOfLines = 0
        subtitle.text = mapable.subtitle()
        subtitle.font = UIFont.systemFont(ofSize: 12)
        
        calloutView.addArrangedSubview(title)
        calloutView.addArrangedSubview(subtitle)
        
        return calloutView
    }
}
