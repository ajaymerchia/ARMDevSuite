//
//  Onboarding.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 2/9/19.
//

import Foundation
import UIKit


public class ARMOnboarding: UIScrollView {
    
    var slideData = [SlideData]()
    var slides = [Slide]()
    var pageControl: UIPageControl!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentSize = CGSize(width: self.frame.width * CGFloat(slideData.count), height: self.frame.height)
        self.isPagingEnabled = true
        self.delegate = self
        
    }
    
    public func clearSlides() {
        slideData = []
    }
    
    private func addPageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: self.frame.height - (40 + 2 * .padding), width: self.frame.width, height: 40))
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
//        pageControl.currentPageIndicatorTintColor = .ACCENT_BLUE
        pageControl.pageIndicatorTintColor = .white
        self.addSubview(pageControl)
        self.bringSubviewToFront(pageControl)
    }
    
    private func reloadViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
