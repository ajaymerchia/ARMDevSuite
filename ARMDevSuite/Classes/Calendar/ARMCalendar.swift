//
//  ARMCalendar.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 3/29/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit

public class ARMCalendar: UICollectionView, ARMCalendarDelegate {
    // public variables
    public var calendarDelegate: ARMCalendarDelegate!
    // Calendar Data
    public var numMonths: Int = 12
    public var startDate: Date = Date() {
        didSet {
            updateMonths()
        }
    }
    public var preselected: [Date] = [] {
        didSet {
            setPreselected()
        }
    }
    public var selectedDates: [Date]? {
        guard let paths = self.indexPathsForSelectedItems else { return nil}
        let dates = paths.map({ (path) -> Date? in
            return self.translateToDate(path)
        }).filter { (date) -> Bool in
            return date != nil
        }
        
        return (dates as? [Date])?.sorted()
        
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
        
        var refDate = startDate.firstOfMonth
        for _ in 0..<numMonths {
            self.monthConfigs.append(MonthConfig(first: refDate))
            refDate = Calendar.current.date(byAdding: .advanceOneMonth, to: refDate)!
            
        }
        setPreselected()
    }
    
    private func setPreselected() {
        for date in self.preselected {
            if let indPath = translateToIndexPath(date) {
                self.selectItem(at: indPath, animated: false, scrollPosition: [])
                self.cellForItem(at: indPath)?.isSelected = true
            }
        }
    }
    
    public func translateToIndexPath(_ date: Date) -> IndexPath? {
        guard let section = Calendar.current.dateComponents([.month], from: monthConfigs.first?.firstOfMonth ?? startDate, to: date).month else {
            return nil
        }
        guard numMonths > section && section >= 0 else { return nil}
        guard let day = Calendar.current.dateComponents([.day], from: date).day else { return nil}
        
        let information = monthConfigs[section]
        let row = information.firstWeekdayIndex + day - 1
        
        return IndexPath(row: row, section: section)
    }
    
    public func translateToDate(_ indexPath: IndexPath) -> Date? {
        let information = monthConfigs[indexPath.section]
        let dateIndex = indexPath.row - information.firstWeekdayIndex
        guard dateIndex >= 0 else {
            return nil
        }
        let date = information.firstOfMonth.addingTimeInterval(TimeInterval.day * TimeInterval(dateIndex))
        
        return date
    }
    
    
    
}


public extension ARMCalendar {
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
    override public func layoutSubviews() {
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
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: sectionHeaderHeight)
    }
}

@available(iOS 9.0, *)
extension ARMCalendar: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numMonths
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthConfigs[section].numCells
    }
    
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
        cell.circleColor = self.selectedCircleColor
        
        cell.awakeFromNib()
        cell.createViews()
        cell.initializeCellWith(date: date)
        
        cell.animatedSelect = false
        cell.isSelected = (preselected.contains(date))
        cell.animatedSelect = true
        
        self.calendarDelegate.calendar(self, additionalStylingForDate: cell.dateLabel)
        
        cell.isEnabled = !self.calendarDelegate.calendar(self, shouldDisableCellAt: date)
        
        
        
        return cell
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
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
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let date = translateToDate(indexPath) else { return }
        if !self.allowsMultipleSelection {
            self.indexPathsForSelectedItems?.forEach({ (ind) in
                if ind != indexPath {
                    self.deselectItem(at: ind, animated: true)
                }
            })
            preselected.removeAll()
        }
        
        calendarDelegate.calendar(self, didSelect: date)
    }
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let date = translateToDate(indexPath) else { return }
        preselected.removeAll { (d) -> Bool in
            return d.timeIntervalSince1970 == date.timeIntervalSince1970
        }
        calendarDelegate.calendar(self, didDeselect: date)
    }
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let date = translateToDate(indexPath) else { return false }
        return !self.calendarDelegate.calendar(self, shouldDisableCellAt: date)
    }
    public func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
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
