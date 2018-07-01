//
//  LeftMenuViewController.swift
//  Scootsy
//
//  Created by Ashvarya Singh on 29/06/18.
//  Copyright © 2018 Ashvaray. All rights reserved.
//

import UIKit

class LeftMenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var dataArray = ["Home","Category","Restaurants","Scootsy Express","Food Stores","Sweets & Bakes","Stores","Kids","Beauty","SOS","Electronics","My Account","Orders","Addresses","Favourites","Profile","Settings","FAQ","Call Us"]
    var selectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension LeftMenuViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == selectedIndex {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            if let titleLabel = cell.viewWithTag(3) as? UILabel {
                titleLabel.text = dataArray[selectedIndex]
                titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
            }
            return cell
        } else if indexPath.row == 1 || indexPath.row == 11 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SmallCell", for: indexPath)
            if let titleLabel = cell.viewWithTag(2) as? UILabel {
                titleLabel.text = dataArray[indexPath.row]
            }
            return cell
        } else {
           let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            if let titleLabel = cell.viewWithTag(3) as? UILabel {
                titleLabel.text = dataArray[indexPath.row]
                 titleLabel.font = UIFont.systemFont(ofSize: 20)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            (sideMenuController?.rootViewController as! HomeViewController).gridView.isHidden = false
            (sideMenuController?.rootViewController as! HomeViewController).blankView.isHidden = false
        } else {
            (sideMenuController?.rootViewController as! HomeViewController).gridView.isHidden = true
            (sideMenuController?.rootViewController as! HomeViewController).blankView.isHidden = true
        }
        if indexPath.row == 2 {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RestrauntListViewController")
            (sideMenuController?.rootViewController as! HomeViewController).present(vc, animated: false, completion: nil)
        }
        if indexPath.row == 1 || indexPath.row == 11 {
            
        } else {
            let cell = tableView.cellForRow(at: indexPath)
            if let titleLabel = cell?.viewWithTag(3) as? UILabel {
                titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
            }
            selectedIndex = indexPath.row
            sideMenuController?.hideLeftViewAnimated()
            tableView.reloadData()
        }
        
    }
}
