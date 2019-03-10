//
//  ARMBubbleProgressHud.swift
//  test
//
//  Created by Ajay Merchia on 3/9/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit

public enum ARMBubbleProgressHudStyle {
    case light
    case dark
}

public enum ARMBubbleProgressHudAnimation {
    case rotating
    case blinking
}

public enum ARMBubbleProgressHudBubbleStyle {
    case filled
    case border
}

public class ARMBubbleProgressHud: UIView {
    
    override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(for view: UIView) {
        super.init(frame: view.frame)
        parentView = view
        titleLabel.textAlignment = .center
        detailLabel.textAlignment = .center
        self.titleColor = colors.first ?? .black
        self.detailColor = colors.last ?? .black
        
        createBubbleViews()
        addBubbles()
        formatBubbles()
        positionContentView()
        updateAppearance()
        self.addSubview(contentView)
    }
    
    private func rotateAnimation() {
        for i in 0..<self.bubbles.count {
            let bubble = self.bubbles[i]
            let xanimation = CAKeyframeAnimation()
            let yanimation = CAKeyframeAnimation()
            
            xanimation.keyPath = "position.x"
            yanimation.keyPath = "position.y"
            
            let numPositions = self.bubbleCenters.count + 1
            
            let positions = (0..<numPositions).map { (j) -> CGPoint in
                return self.bubbleCenters[(i + j) % (numPositions - 1)]
            }
            
            xanimation.values = positions.map({ (point) -> CGFloat in
                return point.x
            })
            yanimation.values = positions.map({ (point) -> CGFloat in
                return point.y
            })
            
            
            let keytimes = (0..<numPositions).map { (val) -> CGFloat in
                
                return CGFloat(val)/CGFloat(numPositions)
            }
            
            xanimation.keyTimes = keytimes as [NSNumber]
            xanimation.duration = 2
            yanimation.keyTimes = keytimes as [NSNumber]
            yanimation.duration = 2
            
            
            xanimation.isAdditive = false
            yanimation.isAdditive = false
            
            xanimation.repeatCount = Float.infinity
            yanimation.repeatCount = Float.infinity
            
            xanimation.fillMode = .forwards
            yanimation.fillMode = .forwards
            
            let animationStyle = CAMediaTimingFunction(name: .easeInEaseOut)
            xanimation.timingFunction = animationStyle
            yanimation.timingFunction = animationStyle
            
            bubble.layer.add(xanimation, forKey: "xmove")
            bubble.layer.add(yanimation, forKey: "ymove")
            
        }
        
    }
    
    private func blinkAnimation() {
        let sizes = self.bubbles.map ({ (bubble) -> CGFloat in return bubble.frame.width })
        var colors = self.bubbles.map ({ (bubble) -> CGColor in return bubble.layer.shadowColor!})
        
        for i in 0..<self.bubbles.count {
            let bubble = self.bubbles[i]
            
            let size = CAKeyframeAnimation()
            let color = CAKeyframeAnimation()
            let shadow = CAKeyframeAnimation()
            let border = CAKeyframeAnimation()
            
            var sizeProportions = sizes.map { (size) -> CGFloat in
                return size/bubble.frame.width
            }
            sizeProportions = sizeProportions + sizeProportions.reversed()
            let keytimes = (0..<sizeProportions.count).map { (val) -> CGFloat in
                
                return CGFloat(val)/CGFloat(sizeProportions.count)
            }
            let sizeValues = (0..<sizeProportions.count).map { (j) -> CGFloat in
                return sizeProportions[(i + j) % (sizeProportions.count)]
            }
            
            size.keyPath = "transform.scale"
            size.values = sizeValues
            size.keyTimes = keytimes as [NSNumber]
            size.duration = 1.5
            size.repeatCount = Float.infinity
            size.calculationMode = .paced
            size.timingFunction = CAMediaTimingFunction(name: .linear)
            size.fillMode = .both
            bubble.layer.add(size, forKey: "scaling")
            
            if self.bubbleStyle == .border {
                border.keyPath = "borderWidth"
                border.values = sizeValues.map({ (scale) -> CGFloat in
                    return 1/scale * self.bubbleBorderWidth
                })
                border.keyTimes = keytimes as [NSNumber]
                border.duration = 1.5
                border.repeatCount = Float.infinity
                border.calculationMode = .paced
                border.timingFunction = CAMediaTimingFunction(name: .linear)
                border.fillMode = .both
                
                bubble.layer.add(border, forKey: "borderScaling")
            }
            
            
            var colorVals = (0..<colors.count).map { (j) -> CGColor in
                return colors[(i + j) % (colors.count)]
            }
            
            
            shadow.keyPath = "shadowColor"
            shadow.values = colorVals + colorVals.reversed()
            shadow.keyTimes = keytimes as [NSNumber]
            shadow.duration = 1
            shadow.repeatCount = Float.infinity
            shadow.calculationMode = .paced
            shadow.timingFunction = CAMediaTimingFunction(name: .linear)
            shadow.fillMode = .both
            bubble.layer.add(shadow, forKey: "shadow")
            
            
            if self.bubbleStyle == .filled {
                color.keyPath = "backgroundColor"
                let uicolors = colorVals.map({UIColor(cgColor: $0)})
                color.values = uicolors + uicolors.reversed()
            } else {
                color.keyPath = "borderColor"
                color.values = colorVals + colorVals.reversed()
            }
            
            
            color.keyTimes = keytimes as [NSNumber]
            color.duration = 1.5
            color.repeatCount = Float.infinity
            color.calculationMode = .paced
            color.timingFunction = CAMediaTimingFunction(name: .linear)
            color.fillMode = .both
            bubble.layer.add(color, forKey: "coloring")
            
            
            
            
            
            
        }
    }
    
    private func updateAppearance() {
        switch overlayStyle {
        case .dark:
            self.backgroundColor = UIColor.black.withAlphaComponent(self.backgroundAlpha)
        case .light:
            self.backgroundColor = UIColor.white.withAlphaComponent(self.backgroundAlpha)
        }
        
        addBubbles()
        formatBubbles()
        
        
    }
    
    private func createBubbleViews() {
        for view in bubbles {
            view.removeFromSuperview()
        }
        bubbles = (0..<numBubbles).map({ (int) -> UIView in
            return UIView()
        })
    }
    
    private func addBubbles() {
        let indicatorDiameter:CGFloat = self.frame.width/4 // This is the diameter of the circle on which the rings will appear
        let maxDiameter:CGFloat = indicatorDiameter/2
        let minDiameter:CGFloat = maxDiameter/2.5
        
        if indicatorView == nil {
            indicatorView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: indicatorDiameter + 2 * maxDiameter))
        }
        
        
        let diameters = (0..<numBubbles+1).map({ (i) -> CGFloat in
            return minDiameter + CGFloat(i) * (maxDiameter - minDiameter)/CGFloat(numBubbles+1)
        })
        
        let onPathInscribedArcs = diameters.map({ (d) -> CGFloat in
            let r = d/2
            let R = indicatorDiameter/2
            return (atan(r/(R*2)) * 2) * 180/CGFloat.pi
        })
        
        let residualDegrees = 360 - onPathInscribedArcs.reduce(0, +)
        
        self.bubbleCenters = []
        
        for i in 0..<(numBubbles+1) {
            let bubble = i < numBubbles ? bubbles[i] : UIView()
            let bubbleDiameter = diameters[i]
            degreeOffset += residualDegrees/CGFloat(numBubbles + 2)
            let bubbleX = indicatorView.center.x + indicatorDiameter/2 * cos(degreeOffset * CGFloat.pi/180)
            let bubbleY = indicatorView.center.y + indicatorDiameter/2 * sin(degreeOffset * CGFloat.pi/180)
            bubble.frame = CGRect(x: bubbleX - bubbleDiameter/2, y: bubbleY, width: bubbleDiameter/2, height: bubbleDiameter/2)
            bubble.layer.cornerRadius = bubble.frame.width/2
            
            if i < numBubbles {
                indicatorView.addSubview(bubble)
                degreeOffset += onPathInscribedArcs[i]
            }
            
            self.bubbleCenters.append(bubble.center)
        }
        
        
    }
    
    private func formatBubbles() {
        guard let c1 = self.colors.first, let c2 = self.colors.last else { return }
        
        let start = c1.rgba
        let end = c2.rgba
        
        let stepsize = (0..<start.count).map { (i) -> CGFloat in
            return (end[i]-start[i])/CGFloat(numBubbles-1)
        }
        
        for i in 0..<numBubbles {
            let bubble = bubbles[i]
            let step = stepsize.map { (val) -> CGFloat in return CGFloat(i) * val}
            let thisColor = UIColor(zip(start, step).map(+))
            
            switch self.bubbleStyle {
            case .filled:
                bubble.backgroundColor = thisColor
                bubble.layer.borderWidth = 0
            case .border:
                bubble.backgroundColor = .clear
                bubble.frame = bubble.frame.inset(by: UIEdgeInsets(top: -bubbleBorderWidth/2, left: -bubbleBorderWidth/2, bottom: -bubbleBorderWidth/2, right: -bubbleBorderWidth/2))
                bubble.layer.cornerRadius = bubble.frame.width/2
                bubble.layer.borderWidth = bubbleBorderWidth
                bubble.layer.borderColor = thisColor.cgColor
                
            }
            bubble.layer.shadowColor = thisColor.cgColor
            bubble.layer.shadowRadius = bubbleShadowRadius
            bubble.layer.shadowOpacity = bubbleShadowOpacity
            
            
            
        }
    }
    
    
    private func positionContentView() {
        // Label updates
        titleLabel.text = title
        detailLabel.text = detail
        
        titleLabel.font = titleFont
        detailLabel.font = detailFont
        titleLabel.textColor = titleColor
        detailLabel.textColor = titleColor
        
        detailLabel.numberOfLines = 0
        detailLabel.lineBreakMode = .byWordWrapping
        
        titleLabel.sizeToFit()
        detailLabel.sizeToFit()
        contentView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: indicatorView.frame.height + titleLabel.frame.height + detailLabel.frame.height + 2 * .padding)
        
        titleLabel.frame = LayoutManager.belowCentered(elementAbove: indicatorView, padding: .padding, width: titleLabel.frame.width, height: titleLabel.frame.height)
        detailLabel.frame = LayoutManager.belowCentered(elementAbove: titleLabel, padding: .padding, width: self.frame.width - 6 * .padding, height: detailLabel.frame.height)
        
        
        contentView.addSubview(indicatorView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.center = self.center
        
        
    }
    
    public var degreeOffset: CGFloat = 100
    public var numBubbles = 7 {
        didSet {
            createBubbleViews()
        }
    }
    
    private var parentView: UIView!
    
    public var backgroundAlpha: CGFloat = 0.5
    public var bubbleBorderWidth: CGFloat = 4
    public var bubbleShadowRadius: CGFloat = 10
    public var bubbleShadowOpacity: Float = 0.4
    
    private(set) public var colors = [UIColor.colorWithRGB(rgbValue: 0xEB592E), UIColor.colorWithRGB(rgbValue: 0xEA38A7)]
    
    public var overlayStyle: ARMBubbleProgressHudStyle = .light
    public var animationStyle: ARMBubbleProgressHudAnimation = .blinking
    public var bubbleStyle: ARMBubbleProgressHudBubbleStyle = .filled
    
    
    public var title: String? {
        didSet {
            positionContentView()
        }
    }
    public var detail: String? {
        didSet {
            positionContentView()
        }
    }
    public var titleFont: UIFont = UIFont(name: "Avenir-Heavy", size: 18)! {
        didSet {
            positionContentView()
        }
    }
    public var detailFont: UIFont = UIFont(name: "Avenir-Book", size: 14)!{
        didSet {
            positionContentView()
        }
    }
    public var titleColor: UIColor! {
        didSet {
            positionContentView()
        }
    }
    public var detailColor: UIColor! {
        didSet {
            positionContentView()
        }
    }
    
    
    public var indicatorView: UIView!
    private var contentView = UIView()
    private var titleLabel = UILabel(frame: .zero)
    private var detailLabel = UILabel(frame: .zero)
    
    private var bubbles = [UIView]()
    private var bubbleCenters = [CGPoint]()
    
    
    public func set(color: UIColor) {
        self.colors = [color]
    }
    
    public func set(color1: UIColor, color2: UIColor) {
        self.colors = [color1, color2]
    }
    
    
    public func show() {
        updateAppearance()
        
        switch self.animationStyle {
        case .blinking:
            self.blinkAnimation()
        case .rotating:
            self.rotateAnimation()
        }
        
        self.alpha = 0
        
        parentView.addSubview(self)
        
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1
        }
    }
    
    public func dismiss() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }) { (b) in
            self.removeFromSuperview()
        }
    }
}

