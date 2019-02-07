//
//  LayoutManager.swift
//
//  Created by Ajay Raj Merchia on 10/10/18.
//  Copyright © 2018 Ajay Raj Merchia. All rights reserved.
//

import Foundation
import UIKit

public class LayoutManager {
    // Below
    public static func belowLeft(elementAbove: UIView, padding: CGFloat, width:CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: elementAbove.frame.minX, y: elementAbove.frame.maxY + padding, width: width, height: height)
    }
    public static func belowCentered(elementAbove: UIView, padding: CGFloat, width:CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: elementAbove.frame.midX - width/2, y: elementAbove.frame.maxY + padding, width: width, height: height)
    }
    public static func belowRight(elementAbove: UIView, padding: CGFloat, width:CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: elementAbove.frame.maxX - width, y: elementAbove.frame.maxY + padding, width: width, height: height)
    }
    
    // Above
    public static func aboveLeft(elementBelow: UIView, padding: CGFloat, width:CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: elementBelow.frame.minX, y: elementBelow.frame.minY - (padding+height), width: width, height: height)
    }
    public static func aboveCentered(elementBelow: UIView, padding: CGFloat, width:CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: elementBelow.frame.midX - width/2, y: elementBelow.frame.minY - (padding+height), width: width, height: height)
    }
    public static func aboveRight(elementBelow: UIView, padding: CGFloat, width:CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: elementBelow.frame.maxX - width, y: elementBelow.frame.minY - (padding+height), width: width, height: height)
    }
    
    // Right
    public static func toRightTop(elementLeft: UIView, padding: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: elementLeft.frame.maxX + padding, y: elementLeft.frame.minY, width: width, height: height)
    }
    public static func toRightMiddle(elementLeft: UIView, padding: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: elementLeft.frame.maxX + padding, y: elementLeft.frame.midY - height/2, width: width, height: height)
    }
    public static func toRightBottom(elementLeft: UIView, padding: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: elementLeft.frame.maxX + padding, y: elementLeft.frame.maxY - height, width: width, height: height)
    }
    
    // Left
    public static func toLeftTop(elementRight: UIView, padding: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: elementRight.frame.minX - (padding + width), y: elementRight.frame.minY, width: width, height: height)
    }
    public static func toLeftMiddle(elementRight: UIView, padding: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: elementRight.frame.minX - (padding + width), y: elementRight.frame.midY - height/2, width: width, height: height)
    }
    public static func toLeftBottom(elementRight: UIView, padding: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: elementRight.frame.minX - (padding + width), y: elementRight.frame.maxY - height, width: width, height: height)
    }
    
    
    public static func between(elementAbove: UIView, elementBelow: UIView, width:CGFloat, topPadding: CGFloat, bottomPadding: CGFloat) -> CGRect {
        
        debugPrint(elementAbove.frame.maxY + topPadding)
        
        return CGRect(x: elementAbove.frame.midX - width/2, y: elementAbove.frame.maxY + topPadding, width: width, height: elementBelow.frame.minY - (elementAbove.frame.maxY + topPadding + bottomPadding))
    }
    
    
    
    
}
