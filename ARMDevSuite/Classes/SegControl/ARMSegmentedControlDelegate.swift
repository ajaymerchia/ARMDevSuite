//
//  ARMSegmentedControlDelegate.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 2/8/19.
//

import Foundation

public protocol ARMSegmentedControlDelegate {
    
    
    /// When the segmentedControl changes segments, this function is called.
    ///
    /// - Parameters:
    ///   - segmentedControl: ARMSegmentedControl for which this event was triggered
    ///   - index: index to which the ARMSegmentedControl changed
    func segmentedControl(_ segmentedControl: ARMSegmentedControl, changedTo index: Int)
}
