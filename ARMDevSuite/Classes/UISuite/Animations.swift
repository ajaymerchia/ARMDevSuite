//
//  Animations.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 5/26/20.
//

import Foundation
import UIKit

extension UIView {
	/// Shakes the UIView given the parameters
	///
	/// - Parameters:
	///   - count: number of movements
	///   - duration: duration of the shaking animation
	///   - translation: how much the uiview should move when shaking
	func shake(count : Float = 1, duration : TimeInterval = 0.125, withTranslation translation : Float = 7.5) {
		
		let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
		animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
		animation.repeatCount = count
		animation.duration = duration/TimeInterval(animation.repeatCount)
		animation.autoreverses = true
		animation.fromValue = NSValue(cgPoint: CGPoint(x: CGFloat(-translation), y: self.center.y))
		animation.toValue = NSValue(cgPoint: CGPoint(x: CGFloat(translation), y: self.center.y))
		layer.add(animation, forKey: "shake")
		
		
	}
	
	
	private static let kRotationAnimationKey = "rotationanimationkey"
	
	func rotate(duration: Double = 1) {
		if layer.animation(forKey: UIView.kRotationAnimationKey) == nil {
			let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
			
			rotationAnimation.fromValue = 0.0
			rotationAnimation.toValue = Float.pi * 2.0
			rotationAnimation.duration = duration
			rotationAnimation.repeatCount = Float.infinity
			
			layer.add(rotationAnimation, forKey: UIView.kRotationAnimationKey)
		}
	}
	
	func stopRotating() {
		if layer.animation(forKey: UIView.kRotationAnimationKey) != nil {
			layer.removeAnimation(forKey: UIView.kRotationAnimationKey)
		}
	}
}
