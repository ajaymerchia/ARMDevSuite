//
//  ARMCalendarCell.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 3/29/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
class ARMCalendarCell: UICollectionViewCell {
    
    var dateLabel: UILabel!
    var circleView: UIView!
    var animatedSelect: Bool = true
    
    var selectedColor: UIColor = .white
    var disabledColor: UIColor = .gray
    var normalColor: UIColor = .black
    
    var circleColor: UIColor = .red
    
    func createViews() {

        dateLabel = UILabel(); self.contentView.addSubview(dateLabel)
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            dateLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
            dateLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        dateLabel.adjustsFontSizeToFitWidth = true

        dateLabel.textAlignment = .center
        
        circleView = UIView(); self.contentView.insertSubview(circleView, belowSubview: dateLabel)
            circleView.translatesAutoresizingMaskIntoConstraints = false
            circleView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
            circleView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
            circleView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7).isActive = true
            circleView.heightAnchor.constraint(equalTo: circleView.widthAnchor).isActive = true
        circleView.alpha = 0
        circleView.backgroundColor = circleColor
        circleView.clipsToBounds = true
     
    }
    
    func initializeCellWith(date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        
        dateLabel.text = formatter.string(from: date)
    }
    
    override var isSelected: Bool {
        didSet {
            guard dateLabel != nil else { return }
            
            if animatedSelect {
                UIView.transition(with: dateLabel, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    self.performSelect()
                }, completion: nil)
            } else {
                performSelect()
            }
        }
    }
    
    private func performSelect() {
        self.dateLabel.textColor = self.isSelected ? self.selectedColor : self.normalColor
        self.circleView.alpha = self.isSelected ? 1 : 0
        self.circleView.layer.cornerRadius = self.isSelected ? self.circleView.frame.height/2 : 0 
    }
    
    var isEnabled: Bool = true {
        didSet {
            guard dateLabel != nil else { return }
            isUserInteractionEnabled = isEnabled
            
            dateLabel.textColor = isUserInteractionEnabled ? normalColor : disabledColor
        }
    }
    
}
