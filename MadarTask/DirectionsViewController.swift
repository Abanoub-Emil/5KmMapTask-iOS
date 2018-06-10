//
//  DirectionsViewController.swift
//  MadarTask
//
//  Created by Champion on 5/25/18.
//  Copyright © 2018 ITI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DirectionsViewController: UIViewController {
    
    @IBOutlet weak var placeName: UILabel!
    
    @IBOutlet weak var placeDistance: UILabel!
    
    @IBOutlet weak var staticMap: UIImageView!
    var lat = Double()
    var lng = Double()
    var currentLat = Double()
    var currentLng = Double()
    var destinationName = String()
    var walkingPoly = String()
    var drivingPoly = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(currentLat)
        print(currentLng)
        print(lat)
        print(lng)
        
        placeName.text = destinationName
        
        let dirURLDriv = "https://maps.googleapis.com/maps/api/directions/json?origin=\(currentLat),\(currentLng)&destination=\(lat),\(lng)&key=AIzaSyAzvgH0AI818lOhOpU2KQfLP8XUnjDN3Iw"
        
        
       
        Alamofire.request(dirURLDriv, method: .get).validate().responseJSON { response in
            
            if let result = response.result.value {
                if let JSON = try? JSON(result){
                   if let Arr = JSON["routes"].arrayObject{
                        let drivArr = Arr as! [[String : AnyObject]]
                        for object in drivArr{
                            let overview =  object["overview_polyline"] as! NSDictionary
                            self.drivingPoly = overview["points"] as! String
                            let legs = object["legs"] as! [[String : AnyObject]]
                            for leg in legs{
                            let distance = leg["distance"] as! NSDictionary
                                self.placeDistance.text = distance["text"] as? String
                            }
                    }
                    }
                }
                
            }
        }
        
        
        
        let dirURLWalk = "https://maps.googleapis.com/maps/api/directions/json?origin=\(currentLat),\(currentLng)&destination=\(lat),\(lng)&mode=walking&key=AIzaSyAzvgH0AI818lOhOpU2KQfLP8XUnjDN3Iw"
        
        Alamofire.request(dirURLWalk, method: .get).validate().responseJSON { response in
            
            if let result = response.result.value {
                if let JSON = try? JSON(result){
                    if let Arr = JSON["routes"].arrayObject{
                    let drivArr = Arr as! [[String : AnyObject]]
                    for object in drivArr{
                        let overview =  object["overview_polyline"] as! NSDictionary
                        self.walkingPoly = overview["points"] as! String
                        self.drawLines()
                    }
                }
                }
                
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
//        "https://maps.googleapis.com/maps/api/staticmap?center=" + avgLat + "," + avgLong + "&" +
//            "zoom=9&size=800x380&maptype=roadmap&path=weight:7%10Ccolor:orange%7Cenc:" + code + "&key=AIzaSyCeYHDhDctqGmb5APIdyWrd-imDO2DkQHc"
        
        
        
//        https://maps.googleapis.com/maps/api/staticmap?center=\(currentLat),\(currentLng)&zoom=13&size=400x500&path=color:red|weight:7|enc:\(walkingPoly)&path=color:green|weight:7|enc:\(drivingPoly)&key=AIzaSyAzvgH0AI818lOhOpU2KQfLP8XUnjDN3Iw
        
        //        https://maps.googleapis.com/maps/api/staticmap?path=color:red|weight:7|enc:uul}DsmruDLYDF@VLT|FxEh@…gBbBcAx@[z@k@d@W`@q@VkA&center=31.200092,29.918739&zoom=13&size=400x500&key=AIzaSyAzvgH0AI818lOhOpU2KQfLP8XUnjDN3Iw
        
        
//        uul}DsmruDLYDF@VLT|FxEh@b@z@^f@PtBf@rAX\\Tr@Nb@BD?@C?C?ADIFEFANHBD@Bj@[tC_Bx@c@|Aw@rBkAdBaAfDgBbBcAx@[z@k@d@W`@q@VkA
        
        
        
        
        
//        var staticMapUrl: String = "http://maps.google.com/maps/api/staticmap?markers=color:blue|\(self.staticData.latitude),\(self.staticData.longitude)&\("zoom=13&size=\(2 * Int(mapFrame.size.width))*\(2 * Int(mapFrame.size.height))")&sensor=true"
//        let mapStr = str.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
//        var mapUrl: NSURL = NSURL(string: str.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
//        let mapUrl = NSURL(string: mapStr!)
//        print(mapUrl!)
//        var image: UIImage = UIImage.imageWithData(NSData.dataWithContentsOfURL(mapUrl))
//        var mapImage: UIImageView = UIImageView(frame: mapFrame)
    }
    
    func drawLines(){
        let str:String = "https://maps.googleapis.com/maps/api/staticmap?center=\(currentLat),\(currentLng)&zoom=13.5&size=400x500&path=color:green|weight:7|enc:\(walkingPoly)&path=color:red|weight:7|enc:\(drivingPoly)&key=AIzaSyAzvgH0AI818lOhOpU2KQfLP8XUnjDN3Iw"
        
        let url = URL(string: str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        
        do {
            let data = try NSData(contentsOf: url!, options: NSData.ReadingOptions())
            staticMap.image = UIImage(data: data as Data)
        } catch {
            staticMap.image = UIImage()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
