//
//  ViewController.swift
//  GoogleMapLatitudeLognitudeAndDirection
//
//  Created by Appinventiv Technologies on 12/09/17.
//  Copyright © 2017 Appinventiv Technologies. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //------------ Outlet's ---------------
    @IBOutlet weak var mapTableView: UITableView!
    //------------ Variable's ------------
    var startLocationLatitude = [Any]()
    var startLocationLognitude = [Any]()
    var stopLocationLatitude = [Any]()
    var stopLocationLognitude = [Any]()
    var dirction = [String]()
    //    ---------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        callApi()   //---------- Call method for get data from api -----------
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {    //-------- Deley for 5 second ----------
            //-------- Register nib ---------
            let cellNib = UINib(nibName: "CellForMapData", bundle: nil)
            self.mapTableView.register(cellNib, forCellReuseIdentifier: "CellForMapDataId")
            //    -----    table dataSource, table delegate ---------
            self.mapTableView.dataSource = self
            self.mapTableView.delegate = self
        })
        
        
    }
    //--------------- Function for call data from API -----------
    func callApi() {
        let headers = [
            "content-type": "application/x-www-form-urlencoded",
            "cache-control": "no-cache",
            "postman-token": "e2a87a33-1378-5d10-ef01-e93e1171bb37"
        ]
        
        let postData = NSMutableData(data: "key=AIzaSyAOKe6Z0NxRZNdBUx-en3aQVBJdcpFvgKI".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=75%209th%20Ave%20New%20York%2C%20NY&destination=MetLife%20Stadium%201%20MetLife%20Stadium%20Dr%20East%20Rutherford%2C%20NJ%2007073")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let err = error {
                print(err)
            } else {
                //                let httpResponse = response as? HTTPURLResponse
                //                print(httpResponse!)
                //
            }
            let json = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.init(rawValue: 0)) //-- Parsing data.......
            
            guard let dataDict = json as? [String:Any] else {fatalError(" json is empty")}  // ------- Assigning to dictionary........
            guard let routesData = dataDict["routes"] as? [[String:Any]] else{fatalError("Route data not found")} //-- Get Routes data....
            guard let legsData = routesData[0]["legs"] as? [[String:Any]] else{fatalError("Route data not found")}  //--- get leg's data.....
            guard let startLocation = legsData[0]["start_location"] as? [String:Any] else{fatalError("Route data not found")} //-- start location..
            guard let stopLocation = legsData[0]["end_location"] as? [String:Any] else{fatalError("Route data not found")} //-- end location..
            guard let startAdd = legsData[0]["start_address"] as? String else{fatalError("Route data not found")} //--
            self.dirction.append(startAdd)
//---------------- get StartLocation and EndLocation lat or  long  and append in array --------------
            guard let startLocLat = startLocation["lat"] else{fatalError("Route data not found")}
            guard let startLocLong = startLocation["lng"] else{fatalError("Route data not found")}
            guard let stopLocLat = stopLocation["lat"] else{fatalError("Route data not found")}
            self.stopLocationLatitude.append(stopLocLat)
            guard let stopLocLong = stopLocation["lng"] else{fatalError("Route data not found")}
            self.stopLocationLognitude.append(stopLocLong)
            
            //--------------------- At leg's start location latitude and lognitude ............
            self.startLocationLatitude.append(startLocLat)
            self.startLocationLognitude.append(startLocLong)
            //-------------------------------------------------
            //            self.stopLocationLognitude.append(stopLocLong)
            ////--------------------- For step's Latitude and lognitude .................
            guard let stepData = legsData[0]["steps"] as? [[String:Any]] else{fatalError("Route data not found")}
            //  ------------ Repeating step's Value -----------------
            for tempIndex in 0..<stepData.count{
                guard let stepLatiLon = stepData[tempIndex]["start_location"] as? [String:Any] else{fatalError("Route data not found")}
                guard let startLocLat = stepLatiLon["lat"] else{fatalError("Route data not found")}
                self.startLocationLatitude.append(startLocLat)
                guard let startLocLong = stepLatiLon["lat"] else{fatalError("Route data not found")}
                self.startLocationLognitude.append(startLocLong)
                //---------------------- For endLocation ----------------
                guard let stepEndLatiLonEndLoc = stepData[tempIndex]["end_location"] as? [String:Any] else{fatalError("Route data not found")}
                guard let endLocLat = stepEndLatiLonEndLoc["lat"] else{fatalError("Route data not found")}
                self.stopLocationLatitude.append(endLocLat)
                guard let endLocLong = stepEndLatiLonEndLoc["lat"] else{fatalError("Route data not found")}
                self.stopLocationLognitude.append(endLocLong)
                }
//            print(self.startLocationLatitude)
//            print(self.startLocationLognitude)
//            print(self.stopLocationLatitude)
//            print(self.stopLocationLognitude)
        })
        
        dataTask.resume()
        
    }
}
//    ===================== ViewController extension =============================

extension ViewController: UITableViewDataSource,UITableViewDelegate{
    //--------------- TableView Method's ------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return startLocationLatitude.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 400
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "CellForMapDataId", for: indexPath) as? CellForMapData else{fatalError("In side cell")}
        cell.startLatitude.text = String(describing: self.startLocationLatitude[indexPath.row])
        cell.startLognitude.text = String(describing: self.startLocationLognitude[indexPath.row])
        cell.stopLatitude.text = String(describing: self.stopLocationLatitude[indexPath.row])
        cell.stopLongnitude.text = String(describing: self.stopLocationLognitude[indexPath.row])
        return cell
    }
    
    
}





