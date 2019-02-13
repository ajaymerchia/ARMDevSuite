//
//  SlideData.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 12/24/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit

public struct SlideData {
    public var header: String
    public var detail: String
    public var image: UIImage?
    
    public init(header: String, detail: String, image: UIImage) {
        self.header = header
        self.detail = detail
        self.image = image
    }
}
