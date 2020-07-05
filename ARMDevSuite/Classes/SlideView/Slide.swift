//
//  Slide.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 12/24/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit

private extension CGFloat {
	static let padding: CGFloat = 20
	static let marginalPadding: CGFloat = 8
}

public class Slide: UIView {
    
    var size: CGSize {
        return self.frame.size
    }
    var safeWidth: CGFloat {
        return Slide.getSafeWidth(for: self.size)
    }
    var data: SlideData!
    
    var imageView: UIImageView?
    var labelTitle: UITextView!
    var centerView: UIView?
    var labelDesc: UITextView!
    
    var descriptionToTitleSpacing: CGFloat = 0 {
        didSet {
            buildFromScratch()
        }
    }
    var imageViewScale: CGFloat = 0.9 {
        didSet {
            buildFromScratch()
        }
    }
    
    init(size: CGSize, data: SlideData) {
        super.init(frame: CGRect(origin: .zero, size: size))
        self.data = data
        buildFromScratch()
    }
    
    func shiftFrameTo(position: Int) {
        self.frame = CGRect(origin: CGPoint(x: self.size.width * CGFloat(position), y: 0), size: size)
    }
    
    // Frame Building
    static func getSafeWidth(for size: CGSize) -> CGFloat{
        return 0.75 * size.width
    }
    
    static func getImageViewFrame(for size: CGSize) -> CGRect {
        let safeWidth = getSafeWidth(for: size)
        return CGRect(x: 0, y: 0, width: safeWidth, height: safeWidth)
    }
    
    func getImageViewFrame() -> CGRect {
        return Slide.getImageViewFrame(for: self.size)
    }
    
    func getTitleLabelFrame() -> CGRect {
        if let imgview = self.imageView {
            return LayoutManager.belowCentered(elementAbove: imgview, padding: .padding, width: safeWidth, height: 40)
        } else {
            let titleHeight: CGFloat = 40
            return LayoutManager.inside(inside: self, justified: .TopCenter, verticalPadding: (self.frame.height + titleHeight)/2, horizontalPadding: 0, width: safeWidth, height: titleHeight)
        }
    }
    
    func createUIElements() {
        if let img = data.image {
            imageView = UIImageView(frame: getImageViewFrame())
            imageView?.center = CGPoint(x: self.size.width/2, y: .padding * 3 + safeWidth/2)
            imageView?.contentMode = .scaleAspectFit
            imageView?.image = img
            self.addSubview(imageView!)
        }
        
        labelTitle = UITextView(frame: getTitleLabelFrame())
        
        labelTitle.backgroundColor = .clear
        labelTitle.text = data.header
        labelTitle.textAlignment = .center
        labelTitle.isScrollEnabled = false
        labelTitle.isUserInteractionEnabled = false
        self.addSubview(labelTitle)
        
        labelDesc = UITextView(frame: LayoutManager.belowCentered(elementAbove: labelTitle, padding: .padding/4, width: safeWidth, height: self.size.height - (labelTitle.frame.maxY + .padding/4)))
        
        labelDesc.backgroundColor = .clear
        labelDesc.text = data.detail
        labelDesc.textContainer.lineBreakMode = .byWordWrapping
        labelDesc.textAlignment = .center
        
        labelDesc.isScrollEnabled = false
        labelDesc.isUserInteractionEnabled = false
        self.addSubview(labelDesc)
    }
    
    func relayout() {
        // Adjust the Title size to fit
        labelTitle.sizeToFit()
        // Position to Top
        labelTitle.frame = LayoutManager.inside(inside: self, justified: .TopCenter, verticalPadding: 0, horizontalPadding: 0, width: safeWidth, height: labelTitle.frame.height)
        labelTitle.center = CGPoint(x: self.center.x, y: labelTitle.frame.midY)
        
        // Adjust the Description Size to fit given the font (use size to fit)
        labelDesc.sizeToFit()
        // Add some padding (externally sourced) between description and title
        labelDesc.frame = LayoutManager.belowCentered(elementAbove: labelTitle, padding: descriptionToTitleSpacing, width: safeWidth, height: labelDesc.frame.height)
        labelDesc.center = CGPoint(x: self.center.x, y: labelDesc.frame.midY)
        
        // remove both from superview
        centerView?.removeFromSuperview()
        labelTitle.removeFromSuperview()
        labelDesc.removeFromSuperview()
        // put both in a view that composes the both of them
        centerView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: labelDesc.frame.maxY))
        
        guard let centerView = centerView else { return }
        
        centerView.addSubview(labelTitle)
        centerView.addSubview(labelDesc)
        
        self.addSubview(centerView)
        
        // if no image
        if let imgview = self.imageView {
            centerView.frame = LayoutManager.inside(inside: self, justified: .BottomCenter, verticalPadding: 0, horizontalPadding: 0, width: centerView.frame.width, height: centerView.frame.height)
            
            // have an image fill (width/height = min(safeWidth, height - height of combined view + some padding)
            let remainingHeight = self.size.height - centerView.frame.height
            let squareDim = min(safeWidth, remainingHeight) * imageViewScale
            imgview.frame = LayoutManager.aboveCentered(elementBelow: centerView, padding: (remainingHeight - squareDim)/2, width: squareDim, height: squareDim)
            // scale the image by the externally sourced variable -- maintain centering
        } else {
            // center that view and return
            centerView.center = self.center
        }
        
        
        
    }
    
    func buildFromScratch() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        createUIElements()
        relayout()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
