//
//  ViewController.swift
//  CouponGo
//
//  Created by Ava on 3/2/19.
//  Copyright © 2019 CouponGo. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation



struct MyPlace {
    var name: String
    var lat: Double
    var long: Double
}

class ViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate, UITextFieldDelegate {
    
    // let currentLocationMarker = GMSMarker()
    var locationManager = CLLocationManager()
    var chosenPlace: MyPlace?
    var mapView: GMSMapView!
    var businesses = [Business]()
    // user defaults local storage
    let localStorage = UserDefaults.standard
    
    @IBOutlet weak var couponPreviewView: UIView!
    
    @IBOutlet weak var couponPreviewViewImage: UIImageView!
    
    @IBOutlet weak var couponPreviewViewLabel: UILabel!
    
    //search bar
    let txtSearchField: UITextField = {
        let res = UITextField()
        res.borderStyle = .roundedRect
        res.backgroundColor = .white
        res.layer.borderColor = UIColor.darkGray.cgColor
        res.placeholder="Search for a restaurant"
        res.translatesAutoresizingMaskIntoConstraints=false
        return res
    }()
    
    // reference: https://github.com/Akhilendra/Google-Map-Tutorial-iOS/blob/master/googlMapTutuorial2/ViewController.swift
    let btnMyLocation: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = UIColor.white
        btn.setImage(UIImage(named: "myLocation"), for: .normal)
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        btn.tintColor = UIColor.gray
        btn.imageView?.tintColor=UIColor.gray
        btn.addTarget(self, action: #selector(btnMyLocationAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    // when we click my_location button, user should go back to his/her location and nearby restaurants should be rendered
    @objc func btnMyLocationAction() {
        let location: CLLocation? = mapView.myLocation
        if location != nil {
            mapView.animate(toLocation: (location?.coordinate)!)
            mapView.clear()
            // start playing activity indicator
            self.showActivityIndicator()
            self.showNearbyRestaurants(lat: (mapView.myLocation?.coordinate.latitude)!, long: (mapView.myLocation?.coordinate.longitude)!)
        }
    }
    
    
    @IBOutlet weak var networkActivityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var versionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        couponPreviewView.isHidden = true
        // start playing activity indicator
        self.showActivityIndicator()
        
        // initialize map view
        mapView = GMSMapView()
        // set mapView delegate
        mapView.delegate = self
        
        
        // set up user locationManager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        //let camera = GMSCameraPosition.camera(withLatitude: 28.7041, longitude: 77.1025, zoom: 17.0)
        self.mapView!.translatesAutoresizingMaskIntoConstraints=false
        self.mapView!.isMyLocationEnabled = true
        // add mapView to our view
        view.addSubview(mapView!)
        mapView!.topAnchor.constraint(equalTo: view.topAnchor).isActive=true
        mapView!.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
        mapView!.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
        mapView!.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive=true
        // set camera to UChicago initially
        let latitude = 41.7886
        let longitude = -87.5987
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 17.0)
        mapView!.camera = camera
        // add search text view to view
        self.view.addSubview(self.txtSearchField)
        txtSearchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive=true
        txtSearchField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive=true
        txtSearchField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive=true
        txtSearchField.delegate = self
        
        self.view.addSubview(btnMyLocation)
        btnMyLocation.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -75).isActive=true
        btnMyLocation.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive=true
        btnMyLocation.widthAnchor.constraint(equalToConstant: 40).isActive=true
        btnMyLocation.heightAnchor.constraint(equalTo: btnMyLocation.widthAnchor).isActive=true
        
    
        versionLabel.layer.zPosition = 1
        //First get the nsObject by defining as an optional anyObject
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject
        
        //Then just cast the object as a String, but be careful, you may want to double check for nil
        let version = nsObject as! String
        
        versionLabel.text = "Version: " + version
        
    }
    
    
    // search bar delegate function
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // initialize autoCompleteController and set its delegate
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        // initialize a default filter
        let filter = GMSAutocompleteFilter()
        autoCompleteController.autocompleteFilter = filter
        // start updating location based on user entered input
        //self.locationManager.startUpdatingLocation()
        // present autoCompleteController
        self.present(autoCompleteController, animated: true, completion: nil)
        return false
    }
    
    

    // Google autocomplete delegate functions
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // get lat/long info of user entered place
        let latitude = place.coordinate.latitude
        let longitude = place.coordinate.longitude

        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 17.0)
        // zoom in camera
        mapView!.camera = camera
        // set a marker for user searched place
        // display the place's information
        txtSearchField.text=place.formattedAddress
        chosenPlace = MyPlace(name: place.formattedAddress!, lat: latitude, long: longitude)
        // create marker
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = "\(place.name ?? "unknown place")"
        marker.snippet = "\(place.formattedAddress!)"
        
        // add marker to map
        marker.map = mapView
        mapView.clear()
        
        // start playing activity indicator
        self.showActivityIndicator()
        
        self.showNearbyRestaurants(lat: latitude, long: longitude)
        // dismiss autoCompleteController
        self.dismiss(animated: true, completion: nil)
    }
    
    // Google autocomplete delegate functions
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error occurs for autocomplete \(error)")
    }

    // Google autocomplete delegate functions
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // if cancelled, dismiss autoCompleteController
        self.dismiss(animated: true, completion: nil)
    }
    
    // Google Map Delegate
    // change border color to green (for restaurant marker) while tapping
    // change border color to orange (for coupon marker) while tapping
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let customMarker = marker.iconView as? CustomMarker else {
            guard let couponMarker = marker.iconView as? CouponMarker else {
                return false
            }
            couponMarker.updateBorderColor(color: UIColor.orange)
            return false
        }
        // update the tapped customMarker's border color
        customMarker.updateBorderColor(color: UIColor.green)
        return false
    }
    
    // Google Map Delegate
    // Called when mapView(GMSMapView, markerInfoWindow) returns nil
    // mapView(GMSMapView, markerInfoWindow) is called when a marker is about to become selected
    // we didn't explicitly override it so the default return value will be nil
    // we will be redirected to mapView(GMSMapView, markerInfoContents) instead
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        guard let customMarker = marker.iconView as? CustomMarker else {
            guard let couponMarker = marker.iconView as? CouponMarker else {
                return nil
            }
            marker.title = couponMarker.couponName
            marker.snippet = couponMarker.functionality + "\nClick for more info"
            return nil
        }
        marker.title = customMarker.restaurantName
        if customMarker.url == "" {
            marker.snippet = "Rating: \(customMarker.rating!)"
        } else {
            marker.snippet = "Rating: \(customMarker.rating!) \nClick for more info"
        }
        return nil
    }
    
    // Google Map Delegate
    // Called when info window is clicked
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        guard let customMarker = marker.iconView as? CustomMarker else {
            // if its not a restaurant marker, check to see if it's a coupon marker
            guard let couponMarker = marker.iconView as? CouponMarker else {
                return
            }
            if self.mapView!.myLocation!.distance(from: CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)) > 300 {
                self.couponPreviewView.isHidden = false
                self.couponPreviewView.layer.zPosition = 1
            } else {
                if !userOwned(coupon: couponMarker.coupon) { // if user doesn't have this coupon
                    print("camera view should start here")
                    // start camera view
                    let cameraViewController = self.storyboard?.instantiateViewController(withIdentifier: "cameraView") as! CameraViewController
                    
                    localStorage.set(couponMarker.coupon.hashToString(), forKey: "couponSelected")
                    
                    self.navigationController?.pushViewController(cameraViewController, animated: true)
                    
                    
                } else {
                    self.showCouponOwnedAlert()
                }
                
            }
            return
        }
        if customMarker.url == "" { return }
        // initialize detailed web view
        let detailedViewController = self.storyboard?.instantiateViewController(withIdentifier: "detailedView") as! BusinessDetailViewController
        // set correct URL
        detailedViewController.url = customMarker.url
        // present detailed view
        self.navigationController?.pushViewController(detailedViewController, animated: true)
    }
    
    // Called when info window is closed
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        guard let customMarker = marker.iconView as? CustomMarker else {
            // if its not a restaurant marker, check to see if it's a coupon marker
            guard let couponMarker = marker.iconView as? CouponMarker else {
                return
            }
            couponMarker.updateBorderColor(color: UIColor.darkGray)
            return
        }
        // update the tapped customMarker's border color
        customMarker.updateBorderColor(color: UIColor.darkGray)
    }
    
    // when we tap the map, Gift box preview view should be hidden if it's present
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if !self.couponPreviewView.isHidden {
            self.couponPreviewView.isHidden = true
        }
    }
    
    // show nearby restaurants with markers
    func showNearbyRestaurants(lat: Double, long: Double) {
        YelpService.search(latitude: String(lat), longitude: String(long), completion: { businesses, error in
            guard let businesses = businesses, error == nil else {
                print(error ?? "unknown error")
                return
            }
            self.businesses = businesses
            
            for business in self.businesses {
                let ratingNum = business.rating ?? -1.0
                var rating = "NA"
                if ratingNum != -1.0 {
                    rating = String(ratingNum)
                }
                
                let marker = GMSMarker()
                if business.image_url == nil {
                    let image: UIImage = UIImage(named: "restaurant_default")!
                    
                    let customMarker = CustomMarker(frame: CGRect(x: 0, y: 0, width: 50, height: 50), image: image, borderColor: UIColor.darkGray, restaurantName: business.name, rating: rating, url: business.url ?? "")
                    marker.iconView = customMarker
                    marker.position = CLLocationCoordinate2D(latitude: business.coordinates.latitude, longitude: business.coordinates.longitude)
                    marker.map = self.mapView
                    continue
                }
                let url = URL(string: business.image_url!)
                if url == nil {
                    continue
                }
                if let data = try? Data(contentsOf: url!) {
                    let image: UIImage = UIImage(data: data) ?? UIImage(named: "restaurant_default")!
                    let customMarker = CustomMarker(frame: CGRect(x: 0, y: 0, width: 50, height: 50), image: image, borderColor: UIColor.darkGray, restaurantName: business.name, rating: rating, url: business.url ?? "")
                    marker.iconView = customMarker
                    marker.position = CLLocationCoordinate2D(latitude: business.coordinates.latitude, longitude: business.coordinates.longitude)
                    marker.map = self.mapView
                    // generate coupons and render them on the map for this restaurant
                    self.generateCoupons(lat: business.coordinates.latitude, long: business.coordinates.longitude, restaurantName: business.name, restaurantId: business.id)
                    
                }
            }
            // hide activity indicator
            self.hideActivityIndicator()
        })
    }
    
    // generate coupons at random position around a restaurant specified by latitude and longitude
    func generateCoupons(lat: Double, long: Double, restaurantName: String, restaurantId: String) {
        for _ in 0..<1 { // generate 1 coupon for each restaurant
            let randNum=Double(Int.random(in: 0..<11))/10000
            let marker=GMSMarker()
            let imageId = Int.random(in: 1..<4)
            let imageName = "c\(imageId)"
            // coupon functionality index number
            let functionalityId = Int.random(in: 0..<3)
            let couponMarkerView = CouponMarker(frame: CGRect(x: 0, y: 0, width: 30, height: 30), image: UIImage(named: imageName)!, borderColor: UIColor.darkGray, couponName: "Offered by " + restaurantName, functionality: Coupon.functionality[functionalityId], coupon: Coupon(name: restaurantName, id: restaurantId, type: Int.random(in: 0..<3), description: "Offered by " + restaurantName))
            marker.iconView = couponMarkerView
            let direction = Int.random(in: 0..<4)
            if direction == 0 {
                marker.position = CLLocationCoordinate2D(latitude: lat + randNum, longitude: long + randNum)
            } else if direction == 1 {
                marker.position = CLLocationCoordinate2D(latitude: lat - randNum, longitude: long - randNum)
            } else if direction == 2 {
                marker.position = CLLocationCoordinate2D(latitude: lat + randNum, longitude: long - randNum)
            } else {
                marker.position = CLLocationCoordinate2D(latitude: lat - randNum, longitude: long + randNum)
            }
            // attach this newly created coupon marker to our map
            marker.map = self.mapView
            marker.zIndex = 1
        }
    }
    
    
    // CLLocation Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
        let location = locations.last
        let lat = (location?.coordinate.latitude)!
        let long = (location?.coordinate.longitude)!
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
        
        self.mapView!.animate(to: camera)
        // start playing activity indicator
        self.showActivityIndicator()
        showNearbyRestaurants(lat: lat, long: long)
    }
    
    func userOwned(coupon: Coupon) -> Bool {
        let userCollection = localStorage.object(forKey: "myCouponList") as! [String]
        let newCouponHashed = coupon.hashToString()
        for userCouponHash in userCollection {
            if newCouponHashed == userCouponHash {
                return true
            }
        }
        return false
    }
    
    func showCouponOwnedAlert() {
        let alertController = UIAlertController(title: "Coupon owned",
                                                message: "You've already grabbed this coupon. Please check your wallet.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        // show the alert controller
        present(alertController, animated: true, completion: nil)
    }
    

    func showActivityIndicator() {
        networkActivityIndicator.layer.zPosition = 1
        networkActivityIndicator.startAnimating()
        networkActivityIndicator.isHidden = false
    }
 
    func hideActivityIndicator() {
        networkActivityIndicator.stopAnimating()
        networkActivityIndicator.isHidden = true
    }
}

