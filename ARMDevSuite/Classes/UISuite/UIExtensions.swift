//
//  UIExtensions.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 2/7/19.
//

import Foundation
import UIKit


public extension UILabel {
	/// Returns the amount of space occupied by 1 line of this font
	///
	/// - Parameter font: font
	/// - Returns: amount of space occupied
static func getEstimatedLineHeight(for font: UIFont) -> CGFloat {
			let label = UILabel()
			label.font = font
			label.text = "Lorem Ipsum"
			label.sizeToFit()
			return label.frame.height
	}
	
}

public extension UIView {
	/// Adds a border `thick` units wide, on the `side` of the calling view colored `color`. If `outside` will show up `THICKNESS` pixels outside of the bounding box.
	func addOneSidedBorder(with color: UIColor, thickness: CGFloat, on side: CGRectEdge, outside: Bool = true) {
		let border = UIView()
		
		if outside {
			guard let parent = self.superview else {
				fatalError("Can't add a border outside a view if parent superview doesn't exist")
			}
			parent.addSubview(border)
		} else {
			self.addSubview(border)
		}
		
		border.translatesAutoresizingMaskIntoConstraints = false
		border.backgroundColor = color
		
		switch side {
		case .minYEdge:
			border.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
			if outside {
				border.bottomAnchor.constraint(equalTo: self.topAnchor).isActive = true
			} else {
				border.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
			}
			border.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
			border.heightAnchor.constraint(equalToConstant: thickness).isActive = true
		case .minXEdge:
			if outside {
				border.trailingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
			} else {
				border.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
			}
			border.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
			border.widthAnchor.constraint(equalToConstant: thickness).isActive = true
			border.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
		case .maxYEdge:
			border.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
			if outside {
				border.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
			} else {
				border.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
			}
			border.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
			border.heightAnchor.constraint(equalToConstant: thickness).isActive = true
		case .maxXEdge:
			if outside {
				border.leadingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
			} else {
				border.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
			}
			border.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
			border.widthAnchor.constraint(equalToConstant: thickness).isActive = true
			border.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
		}
	}
}






public extension UIView {
	func applyGradient(with colors: [UIColor], locations: [NSNumber]? = nil) {
		let gradient = CAGradientLayer()
		gradient.frame = self.bounds
		gradient.colors = colors.map { $0.cgColor }
		gradient.locations = locations
		self.layer.insertSublayer(gradient, at: 0)
	}
	
	func applyGradient(with colors: [UIColor], gradient orientation: GradientOrientation) {
		let gradient = CAGradientLayer()
		gradient.frame = self.bounds
		gradient.colors = colors.map { $0.cgColor }
		gradient.startPoint = orientation.startPoint
		gradient.endPoint = orientation.endPoint
		self.layer.insertSublayer(gradient, at: 0)
	}
	
	func addBorder(gradient: Gradient, in direction: GradientOrientation, thickness: CGFloat, reverse: Bool = false,  name: String = Gradient.layerName) {
		let grad = CAGradientLayer()
		grad.frame =  CGRect(origin: .zero, size: self.frame.size)
		grad.colors = gradient.colors.map { $0.cgColor }
		grad.startPoint = direction.startPoint
		grad.endPoint = direction.endPoint
		
		let shape = CAShapeLayer()
		shape.lineWidth = thickness
		shape.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
		shape.strokeColor = UIColor.black.cgColor
		shape.fillColor = UIColor.clear.cgColor
		grad.mask = shape
		grad.name = name
		
		self.layer.addSublayer(grad)
	}

	
	func addBorder(colored color: UIColor, thickness: CGFloat) {
		self.layer.borderWidth = thickness
		self.layer.borderColor = color.cgColor
	}
}

