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

class ViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    

    // Map
    @IBOutlet weak var mapView: MKMapView!

    let manager = CLLocationManager()
    var isTyping = false
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        mapView.setRegion(region, animated: true)
        
        self.mapView.showsUserLocation = true
        
    }
    @IBOutlet weak var typeAnywhere: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
    // Address is typed here
    
    @IBAction func getDestiny(_ sender: UITextField) {
        
        let DestinyText = sender.text
        print(DestinyText ?? "")
        
        
        CLGeocoder().geocodeAddressString(DestinyText!) { ( placemarks, error) in
            
            if placemarks != nil {
                let placemark = placemarks![0]
                let annotation = MKPointAnnotation()
                annotation.coordinate = (placemark.location?.coordinate)!
                self.mapView.addAnnotation(annotation)
                
            }
            
        }
        
        // Geofencing goes here
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField.delegate = self
        
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
    
    // Hides keyboard when user touches outside of it
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        weak var typeAnywhere: UILabel!
        if self.isTyping {
            self.view.endEditing(true)
            self.isTyping = false
            typeAnywhere.isHidden = true
        } else {
            textField.becomeFirstResponder()
            self.isTyping = true
            typeAnywhere.isHidden = false
        }
    }
    
}

