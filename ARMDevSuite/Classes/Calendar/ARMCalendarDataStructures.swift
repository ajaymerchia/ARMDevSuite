//
//  ARMCalendarDataStructures.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 3/29/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import Foundation
class MonthConfig {
    var firstOfMonth: Date
    var monthName: String
    
    var firstWeekdayIndex: Int
    var numberDays: Int
    var numberWeeks: Int
    
    var numCells: Int {
        return firstWeekdayIndex + numberDays
    }
    
    init(first: Date) {
        self.firstOfMonth = first
        self.firstWeekdayIndex = (Calendar.current.component(.weekday, from: first) - 1) % 7
        self.numberDays = Calendar.current.range(of: .day, in: .month, for: first)!.count
        self.numberWeeks = Calendar.current.range(of: .weekOfMonth, in: .month, for: first)!.count
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        self.monthName = formatter.string(from: self.firstOfMonth)
        
    }
    
}

extension Date {
    var firstOfMonth: Date {
        let comps = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: comps)!
    }
}


extension DateComponents {
    static var advanceOneMonth = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, era: nil, year: nil, month: 1, day: 0, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
}
