//
//  ARMCalendar.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 3/29/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 9.0, *)
protocol ARMCalendarDelegate {
    var headersForDaysOfWeek: [String] {get}
    
    
    func calendar(_ calendar: ARMCalendar, formatterFor month: Date) -> DateFormatter
    
    func calendar(_ calendar: ARMCalendar, additionalStylingForMonth header: UILabel)
    func calendar(_ calendar: ARMCalendar, additionalStylingForDay header: UILabel)
    func calendar(_ calendar: ARMCalendar, additionalStylingForDate label: UILabel)
    func calendar(_ calendar: ARMCalendar, viewForHeaderFor month: Date, in contentView: UIView) -> UIView?
    
    func calendar(_ calendar: ARMCalendar, shouldDisableCellAt date: Date) -> Bool
    func calendar(_ calendar: ARMCalendar, didSelect date: Date)
    func calendar(_ calendar: ARMCalendar, didDeselect date: Date)
    
    
}
@available(iOS 9.0, *)
extension ARMCalendarDelegate {
    func calendar(_ calendar: ARMCalendar, formatterFor month: Date) -> DateFormatter {
        let ret = DateFormatter()
        ret.dateFormat = "MMMM YYYY"
        return ret
    }
    func calendar(_ calendar: ARMCalendar, additionalStylingForMonth header: UILabel) {
        header.font = calendar.defaultFont.withSize(20)
        header.textColor = .red
    }
    func calendar(_ calendar: ARMCalendar, additionalStylingForDay header: UILabel) {
        header.font = calendar.defaultFont.withSize(10)
        header.textColor = .gray
    }
    func calendar(_ calendar: ARMCalendar, additionalStylingForDate label: UILabel) {
        label.font = calendar.defaultFont.withSize(14)
    }
    
    func calendar(_ calendar: ARMCalendar, viewForHeaderFor month: Date, in contentView: UIView) -> UIView? {
        return nil
    }
    
    var headersForDaysOfWeek: [String] {
        get {
            return ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        }
    }
    
    
    func calendar(_ calendar: ARMCalendar, shouldDisableCellAt date: Date) -> Bool {
        return false
    }
    func calendar(_ calendar: ARMCalendar, didSelect date: Date) {}
    func calendar(_ calendar: ARMCalendar, didDeselect date: Date) {}
    
    
}


class ARMCalendar: UICollectionView, ARMCalendarDelegate {
    // public variables
    public var calendarDelegate: ARMCalendarDelegate!
    // Calendar Data
    public var numMonths: Int = 12
    public var startDate: Date = Date() {
        didSet {
            updateMonths()
        }
    }
    
    // Calendar Layout
    public var sectionHeaderHeight: CGFloat = 70
    public var showsDaysOfWeek: Bool = true
    
    // Cells
    public var animatedSelection: Bool = true
    // Coloring
    public var normalDateColor: UIColor = .black
    public var disabledDateColor: UIColor = .gray
    public var selectedDateColor: UIColor = .white
    public var selectedCircleColor: UIColor = .red
    
    // Fonts
    public var defaultFont: UIFont = UIFont.systemFont(ofSize: 12)
    
    // initializers
    
    
    init() {
        super.init(frame: .zero, collectionViewLayout: ARMCalendar.createFlowLayout())
        setUpCalendar()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: ARMCalendar.createFlowLayout())
        setUpCalendar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // private variables
    private var monthConfigs = [MonthConfig]()
    
    // private functions
    private func setUpCalendar() {
        self.backgroundColor = .clear
        self.register(ARMCalendarCell.self, forCellWithReuseIdentifier: "dateCell")
        self.register(ARMCalendarHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")

        self.calendarDelegate = self
        self.delegate = self
        self.dataSource = self
        updateMonths()
        
        self.showsVerticalScrollIndicator = false
        
    }
    
    private func updateMonths() {
        self.monthConfigs = []
        
        var refDate = Date().firstOfMonth
        for _ in 0..<numMonths {
            self.monthConfigs.append(MonthConfig(first: refDate))
            refDate = Calendar.current.date(byAdding: .advanceOneMonth, to: refDate)!
            
        }
        
    }
    
    private func translateToDate(_ indexPath: IndexPath) -> Date? {
        let information = monthConfigs[indexPath.section]
        let dateIndex = indexPath.row - information.firstWeekdayIndex
        guard dateIndex >= 0 else {
            return nil
        }
        let date = information.firstOfMonth.addingTimeInterval(TimeInterval.day * TimeInterval(dateIndex))
        
        return date
    }
    
    
    
}


extension ARMCalendar {
    private static func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize(width: 100, height: 100)
        
        return layout
    }
}



extension ARMCalendar: UICollectionViewDelegateFlowLayout {
    override func layoutSubviews() {
        super.layoutSubviews()
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            let residual = self.frame.width.truncatingRemainder(dividingBy: 7).rounded()
            let newInsets = UIEdgeInsets(top: 0, left: residual/2, bottom: 0, right: residual/2)
            if layout.sectionInset != newInsets {
                layout.sectionInset = newInsets
                layout.invalidateLayout()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var trueWidth = collectionView.frame.width.rounded()
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            let insets = (layout.sectionInset.left + layout.sectionInset.right)
            trueWidth -= insets
            if insets > 0 {
                assert(Int(trueWidth) % 7 == 0)
            }
        }
        
        return CGSize(width: trueWidth/7 - 1, height: trueWidth/7 - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: sectionHeaderHeight)
    }
}

@available(iOS 9.0, *)
extension ARMCalendar: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numMonths
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthConfigs[section].numCells
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! ARMCalendarCell
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
      
        guard let date = translateToDate(indexPath) else {
            return cell
        }
        
        cell.selectedColor = self.selectedDateColor
        cell.disabledColor = self.disabledDateColor
        cell.normalColor = self.normalDateColor
        cell.animatedSelect = self.animatedSelection
        
        cell.awakeFromNib()
        cell.createViews()
        cell.initializeCellWith(date: date)
        self.calendarDelegate.calendar(self, additionalStylingForDate: cell.dateLabel)
        
        cell.isEnabled = !self.calendarDelegate.calendar(self, shouldDisableCellAt: date)
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! ARMCalendarHeader
        
        let monthRepr = monthConfigs[indexPath.section].firstOfMonth
        
        
        headerView.clearCell()
        headerView.createViewHierarchy(withDayOfWeek: showsDaysOfWeek)
        
        if let newView = self.calendarDelegate.calendar(self, viewForHeaderFor: monthRepr, in: headerView.contentView) {
            if newView.superview == nil {
                headerView.contentView.addSubview(newView)
            }
            return headerView
        }
        headerView.createLabel()
        headerView.label.text = self.calendarDelegate.calendar(self, formatterFor: monthRepr).string(from: monthRepr)
        
        self.calendarDelegate.calendar(self, additionalStylingForMonth: headerView.label)
        
        if showsDaysOfWeek {
            for i in 0..<headerView.dayOfWeekHeaders.count {
                let label = headerView.dayOfWeekHeaders[i]
                self.calendarDelegate.calendar(self, additionalStylingForDay: label)
                label.text = self.calendarDelegate.headersForDaysOfWeek[safe: i]
            }
            
        }
        
        return headerView
    }
    
}

@available(iOS 9.0, *)
extension ARMCalendar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let date = translateToDate(indexPath) else { return }
        calendarDelegate.calendar(self, didSelect: date)
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let date = translateToDate(indexPath) else { return }
        calendarDelegate.calendar(self, didDeselect: date)
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let date = translateToDate(indexPath) else { return false }
        return !self.calendarDelegate.calendar(self, shouldDisableCellAt: date)
    }
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        guard let date = translateToDate(indexPath) else { return false }
        return !self.calendarDelegate.calendar(self, shouldDisableCellAt: date)
    }
}

extension Collection {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
