//
//  QPhoto.swift
//  Scootsy
//
//  Created by Ashvarya Singh on 30/06/18.
//  Copyright © 2018 Ashvaray. All rights reserved.
//

import UIKit

private let widthKey = "width"
private let heightKey = "height"
private let photoReferenceKey = "photo_reference"

class QPhoto {
    
    var width: Int?
    var height: Int?
    var photoRef: String?
    
    init(photoInfo: [String:Any]) {
        height = photoInfo[heightKey] as? Int
        width = photoInfo[widthKey] as? Int
        photoRef = photoInfo[photoReferenceKey] as? String
    }
    
    func getPhotoURL(maxWidth:Int) -> URL? {
        if let ref = self.photoRef {
            return DataManager.googlePhotoURL(photoReference: ref, maxWidth: maxWidth)
        }
        return nil
    }
}
