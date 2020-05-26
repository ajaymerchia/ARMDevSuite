//
//  ConstraintUtils.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 5/25/20.
//

import Foundation
import UIKit

public extension UIView {
	/// Fits a subview perfectly in its parent (`other`)
	/// - Parameters:
	///   - other: parent view to pin to
	///   - safeAreaLayoutGuide: Pin to parent's safeAreaLayoutGuide instead of its bounds
	func pinTo(_ other: UIView, safeAreaLayoutGuide: Bool = false) {
		self.translatesAutoresizingMaskIntoConstraints = false
		
		if safeAreaLayoutGuide {
			self.centerXAnchor.pinTo(other.safeAreaLayoutGuide.centerXAnchor)
			self.centerYAnchor.pinTo(other.safeAreaLayoutGuide.centerYAnchor)
			self.widthAnchor.pinTo(other.safeAreaLayoutGuide.widthAnchor)
			self.heightAnchor.pinTo(other.safeAreaLayoutGuide.heightAnchor)
		} else {
			self.centerXAnchor.pinTo(other.centerXAnchor)
			self.centerYAnchor.pinTo(other.centerYAnchor)
			self.widthAnchor.pinTo(other.widthAnchor)
			self.heightAnchor.pinTo(other.heightAnchor)
		}
	}
	
	enum CenteringDirection {
		case both
		case vertical
		case horizontal
	}
	
	/// Pins center layout anchors to one another
	/// - Parameters:
	///   - other: View to match cetners with
	///   - direction: orientation in which to center a view
	///   - safeAreaLayoutGuide: Whether or not to use `other`'s safeAreaLayoutGuide
	func center(in other: UIView, direction: CenteringDirection = .both, safeAreaLayoutGuide: Bool = false) {
		self.translatesAutoresizingMaskIntoConstraints = false
		if direction == .both || direction == .horizontal  {
			self.centerXAnchor.pinTo(safeAreaLayoutGuide ? other.safeAreaLayoutGuide.centerXAnchor : other.centerXAnchor)
		}
		if direction == .both || direction == .vertical  {
			self.centerYAnchor.pinTo(safeAreaLayoutGuide ? other.safeAreaLayoutGuide.centerYAnchor : other.centerYAnchor)
		}
		
	}
}

public extension NSLayoutXAxisAnchor {
	/// Pins a anchor constraint to equal another
	/// - Parameter other: The other anchor to match
	func pinTo(_ other: NSLayoutXAxisAnchor) {
		self.constraint(equalTo: other).isActive = true
	}
}

public extension NSLayoutYAxisAnchor {
	/// Pins a anchor constraint to equal another
	/// - Parameter other: The other anchor to match
	func pinTo(_ other: NSLayoutYAxisAnchor) {
		self.constraint(equalTo: other).isActive = true
	}
}

public extension NSLayoutDimension {
	/// Pins a dimension constraint to match another
	/// - Parameter other: The other dimension to match
	func pinTo(_ other: NSLayoutDimension) {
		self.constraint(equalTo: other).isActive = true
	}
}


