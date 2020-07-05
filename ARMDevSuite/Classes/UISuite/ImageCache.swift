//
//  ImageCache.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 2/7/19.
//

import Foundation
import UIKit

public class ImageCache {
    
    /// Fetches an image from the URL and provides defaultImg if not available
    public static func getImageFrom(url: String, callback: Response<UIImage>?) {
        if let imageUrl:URL = URL(string: url) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageUrl)
                DispatchQueue.main.async {
                    if let retrievedImage = data {
                        callback?(UIImage(data: retrievedImage), nil)
                    }
                    else {
                        callback?(nil, "Unable to fetch Image Data")
                    }
                }
                
            }
        } else {
            callback?(nil, "Unable to parse Image URL")
        }
    }
    
}



