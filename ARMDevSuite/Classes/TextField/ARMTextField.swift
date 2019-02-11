//
//  ARMTextField.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 2/11/19.
//  Heavily adapted from SkyFloatingLabelTextField -- no credit to me for this Pod
//

import Foundation
import Foundation
import UIKit
import SkyFloatingLabelTextField

class LabeledTextField: SkyFloatingLabelTextField {
    
    var additionalDistance: CGFloat = 5
    
    public func setLineDistance(_ distance: CGFloat) {
        additionalDistance = distance
    }
    
    public func getText() -> String? {
        guard let ret = self.text else {
            return nil
        }
        
        if ret == "" {
            return nil
        } else {
            return ret
        }
    }
    
    override func lineViewRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
        let height = editing ? selectedLineHeight : lineHeight
        return CGRect(x: 0, y: bounds.size.height - height + additionalDistance, width: bounds.size.width, height: height)
    }
    
    
}
