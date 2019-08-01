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
    
    
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var seachBar: UISearchBar!
    
    @IBOutlet weak var mapHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var searchBarTop: NSLayoutConstraint!
    
    @IBOutlet weak var backConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var searchLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    
    let db = Firestore.firestore()
    var parkingDetail = [TotalParkingModel]()
    var filterData = [TotalParkingModel]()
     var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.layer.cornerRadius = 10
         mapView.userLocation.title = "You here"
        backButton.isHidden = true
        searchLabel.isHidden = true
       filterData = parkingDetail
        seachBar.delegate = self
         self.navigationController?.setNavigationBarHidden(true, animated: true)
        readData()
         checkLocationServices()
        
//        let myViewController = MapViewController(nibName: "MapMarker", bundle: nil)
//        self.present(myViewController, animated: true, completion: nil)
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
    
    @IBAction func backPressedButton(_ sender: UIButton) {
        seachBar.resignFirstResponder()
        mapHeightConstraint.constant = 141
        topLabel.isHidden = false
        searchBarTop.constant = 20
       topView.backgroundColor = UIColor.init(red: 35/255, green: 246/255, blue: 191/255, alpha: 1)
       seachBar.layer.borderWidth = 0
        tableView.isHidden = false
        backButton.isHidden = true
        searchLabel.isHidden = true
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
                    malldetail.placeNumber = (document.data()["PlaceNumber"] as! String)
                    
                    malldetail.placeLotAlphabet = (document.data()["PlaceAlphabet"] as! String)
                    malldetail.placeLotNumber = (document.data()["PlaceNumber"] as! String)
                 
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
    if inSearchMode
    {
        cell.parkImage.image = filterData[indexPath.row].placeImage
        cell.parkTitle.text = filterData[indexPath.row].placeTitle
        cell.parkName.text = filterData[indexPath.row].placeName
        cell.ParkRating.text = filterData[indexPath.row].placeRating
        cell.parkDistance.text =  filterData[indexPath.row].placeDistance
        cell.parkLot.text = filterData[indexPath.row].placeLot
    }
        else
    {
        cell.parkImage.image = parkingDetail[indexPath.row].placeImage
        cell.parkTitle.text = parkingDetail[indexPath.row].placeTitle
        cell.parkName.text = parkingDetail[indexPath.row].placeName
        cell.ParkRating.text = parkingDetail[indexPath.row].placeRating
        cell.parkDistance.text =  parkingDetail[indexPath.row].placeDistance
        cell.parkLot.text = parkingDetail[indexPath.row].placeLot
    }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if inSearchMode
         {
            return filterData.count
         }
        else
         {
            return parkingDetail.count
          }
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
        ParkingDetailViewController.parkingNumber = parkingDetail[indexPath.row].placeNumber
        ParkingDetailViewController.parkingAlphabetNumber = parkingDetail[indexPath.row].placeLotAlphabet
        ParkingDetailViewController.parkingNumber = parkingDetail[indexPath.row].placeLotNumber
        self.navigationController?.pushViewController(ParkingDetailViewController, animated: true)
    }
    
  }

extension MapViewController : UISearchBarDelegate
{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = true
        mapHeightConstraint.constant = self.view.frame.height - topView.frame.height
        topLabel.isHidden = true
        searchBarTop.constant = -20
        topView.backgroundColor = UIColor.clear
        searchBar.layer.borderColor = UIColor.black.cgColor
        searchBar.layer.borderWidth = 2
        searchBar.layer.cornerRadius = 28
//        searchBar.tintColor = UIColor.white
        searchBar.backgroundImage = UIImage()
        backButton.isHidden = false
         searchLabel.isHidden = false

    }
       
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //ignoring users
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)

        let searchRequest  = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil
            {
                print("ERROR")
            }
            else
            {
                //Removing annotation
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
                
                //Getting Data Of Location
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                //Create Annotation
                
                let annotation = MKPointAnnotation()
               
                annotation.title = searchBar.text
                
                
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
           
                self.mapView.addAnnotation(annotation)
                
                //Zoom into annotation
                
                let coordinate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpan(latitudeDelta: 0.1,longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: coordinate,span: span)
                
                self.mapView.setRegion(region, animated: true)
 
            }
        }

    }
    
    
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       
        tableView.isHidden = false
        mapView.isHidden = false
        topView.isHidden = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            inSearchMode = false
            filterData = parkingDetail
            tableView.reloadData()
            return
        }
        filterData = parkingDetail.filter({ (TotalBookingModel) -> Bool in
            inSearchMode = true
            return TotalBookingModel.placeTitle.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}
    


