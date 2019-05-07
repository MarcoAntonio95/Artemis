//
//  HospitaisViewController.swift
//  Artemis
//
//  Created by PUCPR on 22/04/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class HospitaisViewController: UIViewController {
    @IBOutlet weak var map: MKMapView!
    var name:String?
    var local:String?
    let lm = CLLocationManager()
    let artemisDAO = ArtemisDAO()
    var emergencias:[Hospital] = []
    
    override func viewDidLoad() {
    artemisDAO.carregarHospitais()
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
        
//
//        lm.desiredAccuracy = kCLLocationAccuracyHundredMeters
//        lm.requestWhenInUseAuthorization()
//        UIApplication.shared.beginIgnoringInteractionEvents()
//        let activityIndicator = UIActivityIndicatorView(style: .gray)
//        activityIndicator.center = self.view.center
//        activityIndicator.hidesWhenStopped = true
//        activityIndicator.startAnimating()
//
//        self.view.addSubview(activityIndicator)
//
//        let searchRequest = MKLocalSearch.Request()
//        searchRequest.naturalLanguageQuery = local!
//
//        let activeSearch = MKLocalSearch(request: searchRequest)
//
//        activeSearch.start { (response, error) in
//            activityIndicator.stopAnimating()
//            UIApplication.shared.endIgnoringInteractionEvents()
//
//            if response == nil {
//
//                print("Error")
//
//            }else {
//
//                let latitude = response?.boundingRegion.center.latitude
//
//                let longitude = response?.boundingRegion.center.longitude
//
//                let anotation = MKPointAnnotation()
//
//                anotation.title = self.name!
//
//                anotation.subtitle = self.local
//
//                anotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
//
//                self.map.addAnnotation(anotation)
//
//                let coordenada: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
//
//                let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
//
//                let region = MKCoordinateRegion(center: coordenada, span: span)
//
//                self.map.setRegion(region, animated: true)
//
//            }
//
//        }
//
//

   
}
