//
//  HomeViewController.swift
//  Scootsy
//
//  Created by Ashvarya Singh on 29/06/18.
//  Copyright © 2018 Ashvaray. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces

class HomeViewController: UIViewController {

    var locationManager:CLLocationManager?
    var menuButton: UIButton?
    @IBOutlet weak var blankView: UIView!
    @IBOutlet weak var gridView: UIView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    let transition = CircularTransition()
    var addressStr: String?
    var currentLocation : CLLocationCoordinate2D?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navBar.setBackgroundImage(UIImage(), for: .default)
        self.navBar.shadowImage = UIImage()
        self.navBar.isTranslucent = true
        
        self.determineMyCurrentLocation()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let btn = sender as? UIButton {
            self.menuButton = btn
        }
        let vc = segue.destination as! RestrauntListViewController
        vc.view.backgroundColor = menuButton?.backgroundColor
        vc.tableView.backgroundColor = menuButton?.backgroundColor
        vc.segmentControl.isHidden = true
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        vc.currentLocation = self.currentLocation
        vc.addressStr = self.addressStr ?? ""
        (self.sideMenuController?.leftViewController as! LeftMenuViewController).selectedIndex = (self.menuButton?.tag)!
         (self.sideMenuController?.leftViewController as! LeftMenuViewController).tableView.reloadData()
    }
    
    func setLocationTitleButton(title: String) {
        let contentView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 270, height: 30))
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 220, height: 30))
        btn.setTitle(title, for: .normal)
        btn.addTarget(self, action: #selector(openLocationSearch), for: .touchUpInside)
        btn.titleLabel?.lineBreakMode = .byTruncatingTail
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.black, for: .normal)
        contentView.addSubview(btn)
        let arrowBtn = UIButton.init(frame: CGRect.init(x: 210, y: 0, width: 50, height: 30))
        arrowBtn.addTarget(self, action: #selector(openLocationSearch), for: .touchUpInside)
        arrowBtn.setImage(#imageLiteral(resourceName: "downArrow"), for: .normal)
        contentView.addSubview(arrowBtn)
        self.navItem.titleView = contentView
    }

    @objc func openLocationSearch() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = CGPoint.init(x: (menuButton?.center)!.x, y: self.gridView.frame.origin.y + (menuButton?.center)!.y)
        transition.circleColor = (menuButton?.backgroundColor)!
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = CGPoint.init(x: (menuButton?.center)!.x, y: self.gridView.frame.origin.y + (menuButton?.center)!.y)
        transition.circleColor = (menuButton?.backgroundColor)!
        
        return transition
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    
    func getAddressFromLocation() {
        if let lat = currentLocation?.latitude, let lng = currentLocation?.longitude {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(CLLocation.init(latitude: lat, longitude: lng)) { (placeMarks, error) in
                if let pmArray = placeMarks, pmArray.count > 0 {
                    let pm = pmArray[0]
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    print(addressString)
                    self.addressStr = addressString
                    self.setLocationTitleButton(title: addressString)

                }
            }
        }
    }
    
    func determineMyCurrentLocation() {
        guard currentLocation == nil else {
            return
        }
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        currentLocation = userLocation.coordinate
        self.getAddressFromLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
        errorGettingCurrentLocation(error.localizedDescription)
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager?.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        } else if status == .denied || status == .restricted {
            errorGettingCurrentLocation("Location access denied")
        }
    }
    
    func errorGettingCurrentLocation(_ errorMessage:String) {
        let alert = UIAlertController.init(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension HomeViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
       // self.address = place.formattedAddress
      //  self.locationCoordinate = place.coordinate
        self.addressStr = place.formattedAddress
        self.setLocationTitleButton(title: place.formattedAddress ?? "")
        currentLocation = place.coordinate
        dismiss(animated: true, completion: {
          //  self.changeLocationAction()
            
        })
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
       // self.showAlert(with: error.localizedDescription,theme: .error)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
