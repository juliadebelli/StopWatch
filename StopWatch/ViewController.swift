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
import AVFoundation
import UserNotifications
import AudioToolbox

class ViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    var audioPlayer = AVAudioPlayer()

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
        
        let placemarks = [MKAnnotation]()
        
        CLGeocoder().geocodeAddressString(DestinyText!) { ( placemarks, error) in
            
            if placemarks != nil {
                let placemark = placemarks![0]
                let annotation = MKPointAnnotation()
                annotation.coordinate = (placemark.location?.coordinate)!
                self.mapView.addAnnotation(annotation)
            }
            
            /*if placemarks!.count > 1 {
                let center = placemarks![0]
                self.mapView.removeAnnotations([placemarks! as! MKAnnotation])
            }*/
            
            let circularRegion = CLCircularRegion(center: (placemarks![0].location?.coordinate)!, radius: 500, identifier: "destino")
            self.manager.startMonitoring(for: circularRegion)
            circularRegion.notifyOnEntry = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField.delegate = self
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [ .alert, .sound, .badge]) { (bool, error) in
            func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
                print("entrou na regiao")
                let notification = UNMutableNotificationContent()
                notification.title = "Destiny nearby"
                notification.body = "You're 500 meters away from your destiny"
                AudioServicesPlayAlertSound(SystemSoundID(1304))
                
                let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
                let request = UNNotificationRequest(identifier: "Region reached", content: notification, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    // Hides keyboard when user touches outside of it
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        weak var typeAnywhere: UILabel!
        if self.isTyping {
            self.view.endEditing(true)
            self.isTyping = false
        } else {
            textField.becomeFirstResponder()
            self.isTyping = true
        }

    }
    
}

