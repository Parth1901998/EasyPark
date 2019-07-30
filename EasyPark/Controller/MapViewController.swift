//
//  MapViewController.swift
//  EasyPark
//
//  Created by Parth Bhojak on 26/07/19.
//  Copyright © 2019 Parth Bhojak. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Firebase

class MapViewController: UIViewController{
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    
    let db = Firestore.firestore()
    var parkingDetail = [TotalParkingModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.layer.cornerRadius = 10
         mapView.userLocation.title = "You here"
       
         self.navigationController?.setNavigationBarHidden(true, animated: true)
        readData()
         checkLocationServices()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
    }
    
    
    //MARK:- readData
    
    func readData()
    {
        db.collection("NearestParking").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                
            } else {
                for document in querySnapshot!.documents {
                    // most Important
                    let malldetail = TotalParkingModel()
                    malldetail.placeTitle = (document.data()["PlaceTitle"] as! String)
                    malldetail.placeName = (document.data()["PlaceName"] as! String)
                    malldetail.placeRating = (document.data()["PlaceRating"] as! String)
                    malldetail.placeLot = (document.data()["PlaceLot"] as! String)
                    malldetail.placeDistance = (document.data()["PlaceDistance"] as! String)
                    malldetail.placeAddress = (document.data()["PlaceAddress"] as! String)
                    malldetail.placeMoney = (document.data()["PlaceMoney"] as! String)
                 
                    // feching data
                    
                    let storeRef = Storage.storage().reference(withPath: "ParkingImages/\(malldetail.placeTitle).jpg")//document.documentID
                    
                    storeRef.getData(maxSize: 4 * 1024 * 1024, completion: {(data, error) in
                        if let error = error {
                            print("error-------- \(error.localizedDescription)")
                            return
                        }
                        if let data = data {
                            print("Main data\(data)")
                            malldetail.placeImage  = UIImage(data: data)!
                              self.tableView.reloadData()
                           
                        }
                    })
                    //self.nows.append(nownewitem.image!)
                    self.parkingDetail.append(malldetail)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        
                    }
                     self.tableView.reloadData()
                }
            }
        }
    }
 
}
extension MapViewController : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension MapViewController : UITableViewDelegate,UITableViewDataSource
{
    //MARK:- TablewView Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parkingDetail.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        
        cell.parkImage.image = parkingDetail[indexPath.row].placeImage
        cell.parkTitle.text = parkingDetail[indexPath.row].placeTitle
        cell.parkName.text = parkingDetail[indexPath.row].placeName
        cell.ParkRating.text = parkingDetail[indexPath.row].placeRating
        cell.parkDistance.text =  parkingDetail[indexPath.row].placeDistance
        cell.parkLot.text = parkingDetail[indexPath.row].placeLot
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
          let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        cell.parkImage.image = parkingDetail[indexPath.row].placeImage
        cell.parkTitle.text = parkingDetail[indexPath.row].placeTitle
        cell.parkName.text = parkingDetail[indexPath.row].placeName
        cell.ParkRating.text = parkingDetail[indexPath.row].placeRating
        cell.parkDistance.text =  parkingDetail[indexPath.row].placeDistance
        cell.parkLot.text = parkingDetail[indexPath.row].placeLot
        
        let ParkingDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "ParkingDetailViewController") as! ParkingDetailViewController
        
        ParkingDetailViewController.parkingName = parkingDetail[indexPath.row].placeName
        ParkingDetailViewController.parkingTitle = parkingDetail[indexPath.row].placeTitle
        ParkingDetailViewController.parkingDistance = parkingDetail[indexPath.row].placeDistance
        ParkingDetailViewController.parkingMoney = parkingDetail[indexPath.row].placeMoney
        ParkingDetailViewController.parkingAddress = parkingDetail[indexPath.row].placeAddress
        ParkingDetailViewController.mallimage = parkingDetail[indexPath.row].placeImage
        ParkingDetailViewController.userRating = parkingDetail[indexPath.row].placeRating
        
        self.navigationController?.pushViewController(ParkingDetailViewController, animated: true)
    }
    
}
