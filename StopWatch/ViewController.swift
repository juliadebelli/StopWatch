//
//  ViewController.swift
//  StopWatch
//
//  Created by Julia de Belli Porto on 18/04/17.
//  Copyright © 2017 julha. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    //map
    @IBOutlet weak var mapView: MKMapView!
    
    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        mapView.setRegion(region, animated: true)
        
        self.mapView.showsUserLocation = true
        
    }
    
    //Aqui o endereço é digitado
    @IBAction func getDestiny(_ sender: UITextField) {
        //print("oi")
        
        let DestinyText = sender.text
        print(DestinyText)
        
        CLGeocoder().geocodeAddressString(DestinyText!) { ( placemarks, error) in
            
            if placemarks != nil {
                let placemark = placemarks![0]
                //print(placemarks)
                let annotation = MKPointAnnotation()
                annotation.coordinate = (placemark.location?.coordinate)!
                self.mapView.addAnnotation(annotation)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

