//
//  Onboarding-scroll.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 2/9/19.
//

import Foundation
import UIKit

extension ARMOnboarding: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(self.contentOffset.x/self.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        
        
        /*
         * below code scales the imageview on paging the scrollview
         */
        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        let increments:CGFloat = CGFloat(1.0)/CGFloat(slides.count - 1) // this becomes the base: (.25)
        
        let prevPageIndex: Int = Int((percentOffset.x/increments).rounded(.towardZero))
        let newPageIndex: Int = prevPageIndex + 1
        
        
        let upperBoundPercent: CGFloat = increments * CGFloat(newPageIndex) // This is the .25/.5
        
        let previousScaleFactor: CGFloat = (upperBoundPercent - percentOffset.x)/increments
        let newScaleFactor: CGFloat = percentOffset.x/upperBoundPercent
        
        
        slides[prevPageIndex].imageView.transform = CGAffineTransform(scaleX: previousScaleFactor, y: previousScaleFactor)
        guard newPageIndex < slides.count else {return}
        slides[newPageIndex].imageView.transform = CGAffineTransform(scaleX: newScaleFactor, y: newScaleFactor)
    }

}
