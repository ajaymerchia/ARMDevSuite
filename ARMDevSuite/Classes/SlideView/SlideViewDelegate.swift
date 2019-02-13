//
//  SlideViewDelegate.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 2/12/19.
//

import Foundation
public protocol ARMSlideViewDelegate {
    
    /// Receives callback when slideView changes the currently displayed page
    ///
    /// - Parameters:
    ///   - slideView: slideView that changed indices
    ///   - index: newIndex of the slideview
    func slideView(_ slideView: ARMSlideView, changedTo index: Int)
    
    
}
