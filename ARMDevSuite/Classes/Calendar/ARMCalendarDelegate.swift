//
//  ARMCalendarDelegate.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 3/31/19.
//

import Foundation
import UIKit

@available(iOS 9.0, *)
public protocol ARMCalendarDelegate {
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
public extension ARMCalendarDelegate {
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
