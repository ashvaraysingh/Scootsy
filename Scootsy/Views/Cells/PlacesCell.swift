//
//  PlacesCell.swift
//  Scootsy
//
//  Created by Ashvarya Singh on 30/06/18.
//  Copyright © 2018 Ashvaray. All rights reserved.
//

import UIKit
import AlamofireImage

class PlacesCell: UITableViewCell {
    var place: QPlace?
    let maxWidht = 600
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
     func update(place:QPlace) {
        bannerImageView.image = nil
        if let url = place.photos?.first?.getPhotoURL(maxWidth: maxWidht) {
            bannerImageView.af_setImage(withURL: url)
        }
        if let sts = place.isOpen, sts {
            statusLabel.text = "Open"
        } else {
            statusLabel.text = "Closed"
        }
        titleLabel.text = place.name
        subtitleLabel.text = place.vicinity
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
