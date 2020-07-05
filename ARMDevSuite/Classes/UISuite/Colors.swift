//
//  Colors.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 5/26/20.
//

import Foundation

import UIKit

// MARK: Good Looking Colors
public extension UIColor {
	
}

// MARK: Color Initializers
public extension UIColor {
	/// Gets a random color
	///
	/// - Returns: random color
	static func random() -> UIColor {
		let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
		let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
		let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
		
		return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
	}
	
	
	/// Creates a new UIColor using rgba values on a scale of 0 to 255
	///
	/// - Parameters:
	///   - r: red on a scale from 0 to 255
	///   - g: green on a scale from 0 to 255
	///   - b: blue on a scale from 0 to 255
	///   - a: alpha coeffiecient from 0 to 1
	/// - Returns: UIColor with the given rgba attributes
	convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) {
		self.init(red: r/255.00, green: g/255.00, blue: b/255.00, alpha: a)
	}
	
	/// Create a new UIColor using hex values on a scale of 0 to 255
	/// - Parameters:
	///   - hex: hexcode as a UINT (0xffffff)
	///   - alpha: alpha coefficient from 0 to 1
	convenience init(hex: UInt, alpha: CGFloat = 1.0) {
		let red = CGFloat((hex & 0xFF0000) >> 16) / 255
		let green = CGFloat((hex & 0xFF00) >> 8) / 255
		let blue = CGFloat(hex & 0xFF) / 255
		
		self.init(red: red, green: green, blue: blue, alpha: alpha)
	}
	
	/// Initialize a color from an array of rgba
	///
	/// - Parameter rgba: rgba values on scale of 0 to 1
	convenience init(rgba: [CGFloat]) {
		self.init(red: rgba[0], green: rgba[1], blue: rgba[2], alpha: rgba[3])
	}
	
	/// Optionally initializes a UIColor using the values in the `hexString`
	/// - Parameters:
	///   - hexString: String containing a Hex code (e.g. `#FF0383`)
	///   - alpha: alpha coefficient from 0 to 1.
	convenience init?(hexString: String, alpha: CGFloat = 1.0) {
		var values: [CGFloat] = [0,0,0,alpha]
		guard var hexValue = Int(hexString.suffix(6), radix: 16) else {
				return nil
		}
		
		for i in 0...2 {
				values[2-i] = CGFloat(hexValue % 256)/255
				hexValue = Int(floor(Double(hexValue) / 256.0))
		}
		
		self.init(rgba: values)
	}
	
	/// Access the rgba values of this color
	var rgba: [CGFloat] {
		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0
		var alpha: CGFloat = 0
		getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		
		return [red, green, blue, alpha]
	}
	
}


// MARK: Gradients
public class Gradient {
	public static var layerName = "kGradientLayer"
	
	var color1: UIColor!
	var color2: UIColor!
	
	public init(_ c1: UIColor, _ c2: UIColor) {
		self.color1 = c1
		self.color2 = c2
	}
	
	var colors: [UIColor] {
		return [color1, color2]
	}
	
}

typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)
public enum GradientOrientation {
	case topRightBottomLeft
	case topLeftBottomRight
	case horizontal
	case vertical
	
	var startPoint : CGPoint {
		return points.startPoint
	}
	
	var endPoint : CGPoint {
		return points.endPoint
	}
	
	var points : GradientPoints {
		switch self {
		case .topRightBottomLeft:
			return (CGPoint(x: 0.0,y: 1.0), CGPoint(x: 1.0,y: 0.0))
		case .topLeftBottomRight:
			return (CGPoint(x: 0.0,y: 0.0), CGPoint(x: 1,y: 1))
		case .horizontal:
			return (CGPoint(x: 0.0,y: 0.5), CGPoint(x: 1.0,y: 0.5))
		case .vertical:
			return (CGPoint(x: 0.0,y: 0.0), CGPoint(x: 0.0,y: 1.0))
		}
	}
}
