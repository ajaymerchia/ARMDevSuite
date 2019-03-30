//
//  ARMCalendarHeader.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 3/29/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
class ARMCalendarHeader: UICollectionReusableView {
    var contentView: UIView!
    var label: UILabel!
    
    var dayOfWeekHeaders = [UILabel]()
    
    func clearCell() {
        self.subviews.forEach({$0.removeFromSuperview()})
    }
    
    private func createDayOfWeekHeaders() -> UIView {
        dayOfWeekHeaders = []
        var last: UIView = self
        for i in 0..<7 {
            let label = UILabel(); self.addSubview(label)
                label.translatesAutoresizingMaskIntoConstraints = false
                label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
                if i == 0 {
                    label.leadingAnchor.constraint(equalTo: last.leadingAnchor).isActive = true
                } else {
                    label.leadingAnchor.constraint(equalTo: last.trailingAnchor).isActive = true
                    label.heightAnchor.constraint(equalTo: last.heightAnchor).isActive = true
                }
                label.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/7).isActive = true
            
            label.adjustsFontSizeToFitWidth = true
            label.textAlignment = .center
            self.dayOfWeekHeaders.append(label)
            
            last = label
            
        }
        
        return last
        
    }
    
    func createViewHierarchy(withDayOfWeek: Bool) {
        self.contentView = UIView(); self.addSubview(contentView)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            contentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        if withDayOfWeek {
            contentView.bottomAnchor.constraint(equalTo: createDayOfWeekHeaders().topAnchor).isActive = true
        } else {
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
    }
    
    func createLabel() {
        label = UILabel(); self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
    }
    
    init() {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)        
        // Customize here
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}
