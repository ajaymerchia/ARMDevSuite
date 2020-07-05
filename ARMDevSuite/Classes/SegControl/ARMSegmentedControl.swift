//
//  ARMSegmentedControl.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 2/7/19.
//

import Foundation
import UIKit

private extension UIColor {
	static let accentBlue = UIColor(hex: 0x40c8e1)
	static let lightGray = UIColor(hex: 0xa8a8a8)
}

private extension CGFloat {
	static let padding: CGFloat = 20
}


public class ARMSegmentedControl: UIControl  {
	
	/// Delegate that receives a callback when the control switches states
	public var delegate: ARMSegmentedControlDelegate?
	
	
	/// Font of the titles
	public var font: UIFont = UIFont(name: "HelveticaNeue-Medium", size: 18)! {
		didSet {
			for button in segSwitchButtons {
				button.titleLabel?.font = self.font
			}
		}
	}
	
	/// Height of the indicator view
	public var indicatorHeight: CGFloat = 5 {
		didSet {
			relayout()
		}
	}
	
	/// Vertical distance between the titles and the indicator (can be negative)
	public var indicatorDistance: CGFloat = 0 {
		didSet {
			relayout()
		}
	}
	
	/// Duration of the indicator movement
	public var indicatorAnimationDuration: TimeInterval = 0.25
	
	// Coloring
	
	/// Color of the indicator view
	public var indicatorColor: UIColor = .accentBlue {
		didSet {
			self.indicatorView.backgroundColor = indicatorColor
		}
	}
	
	/// Color of the titles when selected
	public var selectedTitleColor: UIColor = .accentBlue {
		didSet {
			for button in segSwitchButtons {
				button.setTitleColor(self.selectedTitleColor, for: .selected)
			}
		}
	}
	
	/// Color of the titles when not selected
	public var titleColor: UIColor = .lightGray {
		didSet {
			for button in segSwitchButtons {
				button.setTitleColor(self.titleColor, for: .normal)
				button.setTitleColor(self.titleColor, for: .highlighted)
			}
		}
	}
	
	
	// Private Visual Elements
	private var segSwitchButtons = [UIButton]()
	private var indicatorView: UIView!
	private var swipeView: UIView?
	private var swipeBounds: CGRect?
	private var leftSwipe: UISwipeGestureRecognizer!
	private var rightSwipe: UISwipeGestureRecognizer!
	
	// Private Logical Elements
	private(set) var segTitles = [String]()
	private var numSections: Int {
		return segTitles.count
	}
	private(set) public var activeIndex = 0
	private var initialized: Bool {
		return numSections != 0
	}
	
	
	/// Creates an ARMSegmentedControl with the given frame
	///
	/// - Parameter frame: frame of the new UIControl element
	public override init(frame: CGRect) {
		super.init(frame: frame)
		
	}
	
	/// Creates an ARMSegmentedControl with the given frame and titles
	///
	/// - Parameters:
	///   - frame: frame of the new UIControl element
	///   - titles: titles of the segments
	public init(frame: CGRect, titles: [String]) {
		super.init(frame: frame)
		self.setTitles(to: titles)
	}
	
	/// Sets the titles of the segments.
	///
	/// - Parameter titles: segment names
	public func setTitles(to titles: [String]) {
		self.segTitles = titles
		self.relayout()
	}
	
	
	/// Enables a UISwipeGestureRecognizer in the given view
	///
	/// - Parameters:
	///   - view: View in which to listen for swipes
	///   - bounds: Subarea within the view in which to listen. Assumes entire view if nil.
	public func respondToSwipe(in view: UIView, inside bounds: CGRect?) {
		swipeView?.removeGestureRecognizer(leftSwipe)
		swipeView?.removeGestureRecognizer(rightSwipe)
		
		self.swipeView = view
		self.swipeBounds = bounds
		
		leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft))
		leftSwipe.direction = .left
		
		rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeRight))
		rightSwipe.direction = .right
		
		self.swipeView?.addGestureRecognizer(leftSwipe)
		self.swipeView?.addGestureRecognizer(rightSwipe)
	}
	
	private func relayout() {
		clear()
		for i in 0..<numSections {
			let buttonWidth: CGFloat = (self.frame.width - 2 * CGFloat.padding)/CGFloat(numSections)
			
			
			let button = UIButton(frame: CGRect(x: .padding + buttonWidth * CGFloat(i), y: 0, width: buttonWidth, height: self.frame.height - indicatorHeight))
			
			
			button.setTitleColor(titleColor, for: .normal)
			button.setTitleColor(titleColor, for: .highlighted)
			button.setTitleColor(selectedTitleColor, for: .selected)
			button.addTarget(self, action: #selector(segControlWasTapped(_:)), for: .touchUpInside)
			button.setTitle(segTitles[i], for: .normal)
			button.titleLabel?.font = font
			button.tag = i
			
			if i == activeIndex {
				button.isSelected = true
			}
			
			segSwitchButtons.append(button)
			self.addSubview(button)
			
		}
		
		if segSwitchButtons.count != 0 {
			indicatorView = UIView(frame: LayoutManager.belowCentered(elementAbove: segSwitchButtons[activeIndex], padding: indicatorDistance, width: segSwitchButtons[activeIndex].frame.width, height: indicatorHeight))
			indicatorView.backgroundColor = indicatorColor
			self.addSubview(indicatorView)
		}
		
		
		
		
		
	}
	
	private func clear() {
		for view in self.subviews {
			view.removeFromSuperview()
		}
		self.indicatorView = nil
		self.segSwitchButtons = []
		self.activeIndex = 0
	}
	
	@objc private func segControlWasTapped(_ sender: UIButton) {
		guard initialized else { return }
		
		if sender.tag == activeIndex {
			return
		}
		
		for button in segSwitchButtons {
			button.isSelected = false
		}
		sender.isSelected = true
		
		self.activeIndex = sender.tag
		
		UIView.animate(withDuration: self.indicatorAnimationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveEaseInOut, animations: {
			self.indicatorView.frame = LayoutManager.belowCentered(elementAbove: self.segSwitchButtons[sender.tag], padding: self.indicatorDistance, width: self.segSwitchButtons[sender.tag].frame.width, height: self.indicatorHeight)
		})
		
		delegate?.segmentedControl(self, changedTo: self.activeIndex)
		
	}
	
	@objc private func didSwipeLeft() {
		guard initialized else { return }
		
		guard let area = self.swipeView else {
			return
		}
		let nextButton = segSwitchButtons[min(segSwitchButtons.count-1, activeIndex + 1)]
		let boundary = self.swipeBounds ?? area.frame
		
		self.isUserInteractionEnabled = false
		if boundary.contains(leftSwipe.location(in: self.swipeView)) {
			segControlWasTapped(nextButton)
		}
		self.isUserInteractionEnabled = true
		
	}
	
	@objc private func didSwipeRight() {
		guard initialized else { return }
		
		guard let area = self.swipeView else {
			return
		}
		let prevButton = segSwitchButtons[max(0, activeIndex - 1)]
		let boundary = self.swipeBounds ?? area.frame
		
		self.isUserInteractionEnabled = false
		if boundary.contains(rightSwipe.location(in: self.swipeView)) {
			segControlWasTapped(prevButton)
		}
		self.isUserInteractionEnabled = true
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
