//
//  SlideView.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 2/9/19.
//

import Foundation
import UIKit


public class ARMSlideView: UIScrollView {
    
    var slideData = [SlideData]()
    var slides = [Slide]()
    var pageControl: UIPageControl!
    
    public var slideDelegate: ARMSlideViewDelegate?
    
    var slideSize: CGSize {
        return CGSize(width: self.frame.width, height: self.frame.height - pageControlSafeZone)
    }
    
    // Coloring
    static var skyBlue = UIColor.colorWithRGB(rgbValue: 0x40c8e1)
    static var placeholder = UIColor.colorWithRGB(rgbValue: 0xa8a8a8)
    
    // Control the pageControl Appearance
    
    /// Offset of the Page Control from the bottom of the slide scroll view
    public var pageControlOffset: CGFloat = .padding {
        didSet {
            createSlides(from: self.slideData)
        }
    }
    
    /// Determines the height of the PageControl element
    public var pageControlHeight: CGFloat = 40{
        didSet {
            createSlides(from: self.slideData)
        }
    }
    
    
    /// Color of the PageControl Indicator when selected
    public var currentPageIndicatorTintColor: UIColor = ARMSlideView.skyBlue {
        didSet {
            self.pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor
        }
    }
    
    /// Color of the PageControl Indicator
    public var pageIndicatorTintColor: UIColor = ARMSlideView.placeholder {
        didSet {
            self.pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor
        }
    }
    
    private var pageControlSafeZone: CGFloat {
        return pageControlHeight + 1.25 * pageControlOffset
    }
    
    
    // Control how the image displays;
    
    /// Width of a slide's image border
    public var imageBorderWidth: CGFloat = 1.5 {
        didSet {
            for slide in self.slides {
                guard let imageView = slide.imageView else { continue }
                imageView.layer.borderWidth = self.imageBorderWidth
            }
        }
    }
    
    /// Color of a slide's image border
    public var imageBorderColor: UIColor = ARMSlideView.placeholder {
        didSet {
            for slide in self.slides {
                guard let imageView = slide.imageView else { continue }
                imageView.layer.borderColor = self.imageBorderColor.cgColor
            }
        }
    }
    
    /// Corner radius of imageview. Set to negative values for circular views.
    public var imageCornerRadius: CGFloat = -1 {
        didSet {
            for slide in self.slides {
                guard let imageView = slide.imageView else { continue }
                
                if self.imageCornerRadius >= 0 {
                    imageView.layer.cornerRadius = self.imageCornerRadius
                } else {
                    imageView.layer.cornerRadius = imageView.frame.width/2
                }
            }
        }
    }
    
    
    /// Adjust the way the image displays in the imageview.
    public var imageContentMode: UIView.ContentMode = .scaleAspectFit {
        didSet {
            for i in 0..<self.slides.count {
                let slide = self.slides[i]
                slide.imageView?.contentMode = self.imageContentMode
                slide.imageView?.image = self.slideData[i].image
            }
        }
    }
    
    /// Scale Factor for the image relative to the slide/text elements. 1 is normal.
    public var imageScaler: CGFloat = 1 {
        didSet {
            createSlides(from: self.slideData)
        }
    }
    
    /// Sets the space between the title and description labels.
    public var textSpacing: CGFloat = 10 {
        didSet {
            createSlides(from: self.slideData)
        }
    }
    
    // Control how the labels display
    
    /// Font of the title label
    public var titleFont = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize + 8) {
        didSet {
            createSlides(from: self.slideData)
        }
    }
    
    /// Color of the title label
    public var titleColor = ARMSlideView.skyBlue {
        didSet {
            for slide in self.slides {
                slide.labelTitle.textColor = self.titleColor
            }
        }
    }
    
    
    /// Font of the description label
    public var descriptionFont = UIFont.systemFont(ofSize: UIFont.systemFontSize) {
        didSet {
            createSlides(from: self.slideData)
        }
    }
    
    /// Color of the description label
    public var descriptionColor = ARMSlideView.placeholder {
        didSet {
            for slide in self.slides {
                slide.labelDesc.textColor = self.descriptionColor
            }
        }
    }
    
    
    /// Returns the currently selected page
    public var currentPage: Int {
        return pageControl.currentPage
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isPagingEnabled = true
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.delegate = self
        
    }
    
    convenience init(frame: CGRect, data: [SlideData]) {
        self.init(frame: frame)
        self.slideData = data
        self.createSlides(from: slideData)
    }
    
    
    /// Refreshes the SlideView to contain slides based on the new data.
    ///
    /// - Parameter slideData: provides the configuration objects for slides in this view.
    public func createSlides(from slideData: [SlideData]) {
        clearSlides()
        self.slideData = slideData
        addSlides()
    }
    
    
    private func clearSlides() {
        for slide in slides {
            slide.removeFromSuperview()
        }
        slides = []
        slideData = []
        
        if pageControl != nil {
            pageControl.removeFromSuperview()
        }
    }
    
    private func addSlides() {
        buildSlides()
        
        self.contentSize = CGSize(width: slideSize.width * CGFloat(slideData.count), height: slideSize.height)
        
        for i in 0 ..< slides.count {
            
            slides[i].imageViewScale = self.imageScaler
            slides[i].descriptionToTitleSpacing = self.textSpacing
            
            // Config the imageview
            if let imageView = slides[i].imageView {
                imageView.clipsToBounds = true
                imageView.contentMode = self.imageContentMode
                imageView.image = slideData[i].image
                imageView.layer.borderColor = self.imageBorderColor.cgColor
                imageView.layer.borderWidth = self.imageBorderWidth
                if self.imageCornerRadius >= 0 {
                    imageView.layer.cornerRadius = self.imageCornerRadius
                } else {
                    imageView.layer.cornerRadius = imageView.frame.width/2
                }
                
            }
            
            slides[i].labelTitle.font = self.titleFont
            slides[i].labelTitle.textColor = self.titleColor
            
            slides[i].labelDesc.font = self.descriptionFont
            slides[i].labelDesc.textColor = self.descriptionColor
            
            slides[i].relayout()
            slides[i].shiftFrameTo(position: i)
            self.addSubview(slides[i])
        }
        
        addPageControl()
    }
    
    private func buildSlides() {
        slides = slideData.map({ (slideData) -> Slide in return Slide(size: slideSize, data: slideData)})
    }
    
    
    private func addPageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: self.frame.height - (pageControlSafeZone - pageControlOffset), width: self.frame.width, height: pageControlHeight))
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor
        pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor
        self.addSubview(pageControl)
        self.bringSubviewToFront(pageControl)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
