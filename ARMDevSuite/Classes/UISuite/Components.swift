//
//  Components.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 5/27/20.
//

import Foundation
import UIKit



// MARK: Backgrounds & Borders
public extension UIButton {
	
	/// Sets the background color of the button for a UIControl.State
	///
	/// - Parameters:
	///   - color: background color
	///   - forState: state for which the color should show
	func setBackgroundColor(color: UIColor, forState: UIControl.State) {
		UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
		UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
		UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
		let colorImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		self.setBackgroundImage(colorImage, for: forState)
	}
	
	/// Sets the background gradient of the button for a UIControl.State, can not be used with backgroundColor or backgroundImagee
	///
	/// - Parameters:
	///   - gradient: Colors that compose this gradient
	///   - direction: direction in which the gradient should flow
	///   - forState: state for which this gradient should show
	///   - reverseDirection: Reverse the direction of the gradient
	func setBackgroundGradient(gradient: Gradient, in direction: GradientOrientation, forState: UIControl.State, reverseDirection: Bool = false) {
		
		var colors: [UIColor]! = [gradient.color1, gradient.color2]
		if reverseDirection {
			colors.reverse()
		}
		
		
		let resolution: CGFloat = 20
		let contextSize = CGSize(width: resolution, height: resolution)
		let contextFrame = CGRect(origin: .zero, size: contextSize)
		
		UIGraphicsBeginImageContext(contextSize)
		UIGraphicsGetCurrentContext()!.fill(contextFrame)
		let gradLayer = CAGradientLayer()
		gradLayer.frame = contextFrame
		gradLayer.colors = colors.map { $0.cgColor }
		gradLayer.startPoint = direction.startPoint
		gradLayer.endPoint = direction.endPoint
		gradLayer.type = .axial
		gradLayer.setNeedsDisplay()
		gradLayer.render(in: UIGraphicsGetCurrentContext()!)
		
		let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
		
		UIGraphicsEndImageContext()
		
		self.setBackgroundImage(gradientImage, for: forState)
	}
}



// MARK: Text Colors
public extension NSMutableAttributedString {
	
	/// Sets the color of a substring within an NSMutableAttributedString
	///
	/// - Parameters:
	///   - color: color to set the substring to
	///   - stringValue: substring to change
	func setColor(color: UIColor, forText stringValue: String) {
		let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
		self.addAttribute(.foregroundColor, value: color, range: range)
	}
	
}

public extension UILabel {
	
	/// Sets a UILabel's text and colorizes a part of it.
	///
	/// - Parameters:
	///   - text: new text for the label
	///   - color: color for the substring
	///   - substring: substring to colorize
	func setText(to text: String, with color: UIColor, for substring: String) {
		let attString = NSMutableAttributedString(string: text)
		attString.setColor(color: color, forText: substring)
		
		self.attributedText = attString
	}
}



// MARK: Miscellaneous
public extension UIImage {
	func resizeTo(_ sizeChange:CGSize) -> UIImage {
		let hasAlpha = true
		let scale: CGFloat = 0.0 // Use scale factor of main screen
		UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
		self.draw(in: CGRect(origin: .zero, size: sizeChange))
		
		let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
		return scaledImage!
	}
}

public extension UIView {
	var parentViewController: UIViewController? {
		var parentResponder: UIResponder? = self
		while parentResponder != nil {
			parentResponder = parentResponder!.next
			if let viewController = parentResponder as? UIViewController {
				return viewController
			}
		}
		return nil
	}
}
