//
//  ViewController.swift
//  Mapkit
//
//  Created by Emre ÖZKÖK on 23.12.2022.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var chosenName: UITextField!
    
    @IBOutlet weak var chosenSubtile: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 1.5
        mapView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @objc func chooseLocation(gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began{
           let chosenPoint = gestureRecognizer.location(in: mapView)
           let chosenLocaion = mapView.convert(chosenPoint, toCoordinateFrom: mapView)
            
            chosenLatitude = chosenLocaion.latitude
            chosenLongitude = chosenLocaion.longitude
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = chosenLocaion
            annotation.title = chosenName.text
            annotation.subtitle = chosenSubtile.text
            mapView.addAnnotation(annotation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2DMake(locations[0].coordinate.latitude, locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newLocation = NSEntityDescription.insertNewObject(forEntityName: "Location", into: context)
        
        newLocation.setValue(chosenName.text, forKey: "name")
        newLocation.setValue(chosenSubtile.text, forKey: "subtitle")
        newLocation.setValue(chosenLatitude, forKey: "latitude")
        newLocation.setValue(chosenLongitude, forKey: "longitude")
        newLocation.setValue(UUID(), forKey: "id")
        
        do{
            try context.save()
            print("Kayıt Başarılı")
            
        }catch{
            print("Hata")
        }
        
    }
    
}
