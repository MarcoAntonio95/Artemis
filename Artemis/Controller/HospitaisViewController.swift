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

class HospitaisViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
//
    
    let locationManager = CLLocationManager()
    
    
    @IBOutlet weak var map: MKMapView!
    
    var locais:[Hospital] = []
    var myLocation:CLLocationCoordinate2D?
    var artemisDAO = ArtemisDAO()
    var cont = 0
    override func viewDidLoad() {
        
        super.viewDidLoad()
  
    artemisDAO.carregarHospitais()
//
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        map.delegate = self
        map.mapType = .standard
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        
        if let coor = map.userLocation.location?.coordinate{
            map.setCenter(coor, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        map.showsUserLocation = true;
 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        map.showsUserLocation = false
    }
    
    func centerMap(_ center:CLLocationCoordinate2D){
        let anotacao = MKPointAnnotation()
        anotacao.coordinate = center
        anotacao.title = "Você está aqui"
        map.addAnnotation(anotacao)
        
        let spanX = 0.007
        let spanY = 0.007
        let newRegion = MKCoordinateRegion(center:center , span: MKCoordinateSpan(latitudeDelta: spanX, longitudeDelta: spanY));
        map.setRegion(newRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let posAtual:CLLocationCoordinate2D = manager.location!.coordinate
          artemisDAO.definirMapAtual(map)
        artemisDAO.definirPosAtual(posAtual)
//        if cont == 0 {
//               artemisDAO.carregarHospitais()
//            cont += 1
//        }
        centerMap(posAtual)
    }
}
