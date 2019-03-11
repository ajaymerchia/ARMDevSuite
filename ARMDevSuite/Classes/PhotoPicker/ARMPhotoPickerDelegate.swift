//
//  ARMPhotoPickerDelegate.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 3/4/19.
//

import Foundation
@available(iOS 9.0, *)
public protocol ARMPhotoPickerDelegate {
    
    
    /// Receives images when selected through the button
    ///
    /// - Parameters:
    ///   - segmentedControl: ARMSegmentedControl for which this event was triggered
    ///   - index: index to which the ARMSegmentedControl changed
    func photoPicker(_ photoPicker: ARMPhotoPickerButton, received images: [UIImage])
}
