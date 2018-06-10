//
//  ViewController.swift
//  MadarTask
//
//  Created by Champion on 5/25/18.
//  Copyright © 2018 ITI. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import SwiftyJSON
class ViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
    var mylat = Double() ; var myLong = Double()
    var allBanks = Array<Banks>()
    var allMosques = Array<Mosques>()
    let regionRadius: CLLocationDistance = 2500
    @IBOutlet weak var mapView: MKMapView!
    var initialLocation = CLLocation()
    var mgr:CLLocationManager=CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        mgr.requestWhenInUseAuthorization()
        mgr.desiredAccuracy = kCLLocationAccuracyBest
        mgr.distanceFilter = kCLHeadingFilterNone
        mgr.delegate=self
        mgr.startUpdatingLocation()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc:CLLocation = locations.last!
        mylat = loc.coordinate.latitude
        myLong = loc.coordinate.longitude
        initialLocation = loc 
        centerMapOnLocation(location: initialLocation)
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let directionsView = storyBoard.instantiateViewController(withIdentifier: "directionsView") as! DirectionsViewController
        directionsView.destinationName = ((view.annotation?.title)!)!
        directionsView.lat = (view.annotation?.coordinate.latitude)!
        directionsView.lng = (view.annotation?.coordinate.longitude)!
        directionsView.currentLat = initialLocation.coordinate.latitude
        directionsView.currentLng = initialLocation.coordinate.longitude
        self.navigationController?.pushViewController(directionsView, animated: true)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func notifyBanks(){
        mapView.removeAnnotations(self.mapView.annotations);
        for bank in allBanks{

            let annotation = MyAnnotation()
            annotation.title = bank.name
            annotation.coordinate.latitude = bank.lat
            annotation.coordinate.longitude = bank.lng
           mapView.addAnnotation(annotation)
        }
    }

    func notifyMosques(){
        mapView.removeAnnotations(self.mapView.annotations);
        print(allMosques.count)
        for mosque in allMosques{
            
            let annotation = MyAnnotation()
            annotation.title = mosque.name
            annotation.coordinate.latitude = mosque.lat
            annotation.coordinate.longitude = mosque.lng
            mapView.addAnnotation(annotation)
        }
    }
    
    @IBAction func showMosques(_ sender: Any) {
        let mosquesURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(mylat),\(myLong)&radius=5000&types=mosque&key=AIzaSyAzvgH0AI818lOhOpU2KQfLP8XUnjDN3Iw"
        
        Alamofire.request(mosquesURL, method: .get).validate().responseJSON { response in
            
            if let result = response.result.value {
                if let JSON = try? JSON(result){
                    if let Arr = JSON["results"].arrayObject{
                        let mosqueArr = Arr as! [[String : AnyObject]]
                        for object in mosqueArr{
                            let mosque = Mosques()
                            mosque.name = object["name"] as! String
                            let mosqueGeo = object["geometry"]!
                            let mosqueLoc = mosqueGeo["location"]! as! [String : Double]
                            
                            mosque.lat = mosqueLoc["lat"]!
                            mosque.lng = mosqueLoc["lng"]!
                            
                            self.allMosques.append(mosque)
                            
                        }
                        self.notifyMosques()
                    }
                }
                
            }
        }
    }
    
    @IBAction func showBanks(_ sender: Any) {
        let banksURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(mylat),\(myLong)&radius=5000&types=bank&key=AIzaSyAzvgH0AI818lOhOpU2KQfLP8XUnjDN3Iw"
        
                Alamofire.request(banksURL, method: .get).validate().responseJSON { response in
                    
                    if let result = response.result.value {
                        if let JSON = try? JSON(result){
                            if let Arr = JSON["results"].arrayObject{
                                let bankArr = Arr as! [[String : AnyObject]]
                                for object in bankArr{
                                    let bank = Banks()
                                    bank.name = object["name"] as! String
                                    let bankGeo = object["geometry"]!
                                    let bankLoc = bankGeo["location"]! as! [String : Double]
                                    
                                    bank.lat = bankLoc["lat"]!
                                    bank.lng = bankLoc["lng"]!
                                    
                                    self.allBanks.append(bank)
                                    
                                }
                                self.notifyBanks()
                            }
                        }
                        
                    }
        
        
                }
    }
}

