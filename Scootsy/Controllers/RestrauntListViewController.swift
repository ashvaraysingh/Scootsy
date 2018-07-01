//
//  RestrauntListViewController.swift
//  Scootsy
//
//  Created by Ashvarya Singh on 30/06/18.
//  Copyright © 2018 Ashvaray. All rights reserved.
//

import UIKit
import CoreLocation
import SVProgressHUD
import GooglePlaces

class RestrauntListViewController: UIViewController {
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    let apiKey = "AIzaSyDwlc5LVcWuFNsdbfje-oEUgT8GX1qyTBI"
    var currentLocation : CLLocationCoordinate2D?
    var isLoading = false
    var response : QNearbyPlacesResponse?
    var places: [QPlace] = []
    let radius = 5000
    var addressStr: String?
    var isRefresh = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBar.setBackgroundImage(UIImage(), for: .default)
        self.navBar.shadowImage = UIImage()
        self.navBar.isTranslucent = true
        
       
       
        // sideMenuController?.rootViewController = self
        // Do any additional setup after loading the view.
    }
    
    
    func setLocationTitleButton(title: String) {
        let contentView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 270, height: 30))
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 220, height: 30))
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.lineBreakMode = .byTruncatingTail
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(openLocationSearch), for: .touchUpInside)
        btn.setTitleColor(UIColor.black, for: .normal)
        contentView.addSubview(btn)
        let arrowBtn = UIButton.init(frame: CGRect.init(x: 210, y: 0, width: 50, height: 30))
        arrowBtn.setImage(#imageLiteral(resourceName: "downArrow"), for: .normal)
        arrowBtn.addTarget(self, action: #selector(openLocationSearch), for: .touchUpInside)
        contentView.addSubview(arrowBtn)
        self.navItem.titleView = contentView
    }

    @objc func openLocationSearch() {
        isRefresh = false
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isRefresh {
            self.view.backgroundColor = UIColor.white
            self.tableView.backgroundColor = UIColor.white
            self.segmentControl.isHidden = false
            self.setLocationTitleButton(title: addressStr ?? "")
            self.loadPlaces(true)
        }
    }
    
    @IBAction func leftMenuAction() {
        ((self.presentingViewController as! MainViewController).rootViewController as! HomeViewController).blankView.isHidden = true
        ((self.presentingViewController as! MainViewController).rootViewController as! HomeViewController).gridView.isHidden = true
        self.dismiss(animated: false, completion: nil)
        (self.presentingViewController as! MainViewController).showLeftViewAnimated()
    }

    func canLoadMore() -> Bool {
        if isLoading {
            return false
        }
        if let response = self.response {
            if (!response.canLoadMore()) {
                return false
            }
        }
        return true
    }
    
    func loadPlaces(_ force:Bool) {
        if !force {
            if !canLoadMore() {
                return
            }
        }
        print("load more")
        isLoading = true
        if let cl = currentLocation {
            SVProgressHUD.show()
            DataManager.getNearbyPlaces(by: "Restaurant", coordinates: cl, radius: radius, token: self.response?.nextPageToken, completion: didReceiveResponse)
        }
    }
    
    func didReceiveResponse(response:QNearbyPlacesResponse?) -> Void {
        SVProgressHUD.dismiss()
        self.response = response
        if response?.status == "OK" {
            
            if let p = response?.places {
                places.append(contentsOf: p)
            }
            self.tableView.reloadData()
        } else {
            let alert = UIAlertController.init(title: "Error", message: "Unable to fetch nearby places", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction.init(title: "Retry", style: .default, handler: { (action) in
                self.loadPlaces(true)
            }))
            present(alert, animated: true, completion: nil)
        }
        isLoading = false
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

extension RestrauntListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! PlacesCell
        cell.container.layer.cornerRadius = 6.0
        cell.container.layer.shadowOffset = CGSize(width: -1, height: 1)
        cell.container.layer.masksToBounds = false
        cell.container.layer.shadowColor = UIColor.lightGray.cgColor
        cell.container.layer.shadowRadius = 2.0
        cell.container.layer.shadowOpacity = 0.5
        cell.bannerImageView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        cell.bannerImageView.clipsToBounds = true
        cell.textView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        
        cell.update(place: places[indexPath.row])
        return cell
    }
}

extension RestrauntListViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.addressStr = place.formattedAddress
        self.setLocationTitleButton(title: place.formattedAddress ?? "")
        currentLocation = place.coordinate
        self.response = nil
        self.places.removeAll()
         self.loadPlaces(true)
        dismiss(animated: true, completion: {
           
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
