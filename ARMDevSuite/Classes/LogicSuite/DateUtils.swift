//
//  DateUtils.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 5/25/20.
//

import Foundation

public class ARMDateUtils {
	/// Returns a string of date in `YYYY-MM-dd` format.
	public func getYYYYMMDDRepr(date: Date) -> String { return date.yyyymmddRepr }
	
	/// Returns a string of date in `M/dd/yy` format.
	public func getMDDYYRepr(date: Date) -> String { return date.mddyyRepr }
	
	/// Returns a URL-safe string of a date in `M-dd-yy` format.
	public func getURLSafeDateFormat(date: Date) -> String { return date.urlSafeRepr }
	
	/// Returns the time as typically shown on digital clocks (`h:mm am/pm`)
	public func getTimeWithAMPM(date: Date) -> String { return date.timeRepr }

	/// Returns the date as `MM/DD/YY H:MM AM/PM`
	public func getFormattedDateAndTime(date: Date) -> String { return date.humanReadable }
	
	/// Returns the date as `yyyy-MM-dd HH:mm:ss xxx`
	public func getLogFormatting(date: Date) -> String { return date.logRepr }
}

public extension TimeInterval {
	static let second: TimeInterval = 1
	static let minute: TimeInterval = second * 60
	static let hour: TimeInterval = minute * 60
	static let day: TimeInterval = hour * 24
	static let month: TimeInterval = day * 30
}

public extension Date {
	/// Converts a date to a string based on the `fmt` string.
	/// - Parameter fmt: Format string for the date to conform to
	/// - Returns: Formatted date string
	func toString(fmt: String) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = fmt
		dateFormatter.locale = Locale(identifier: "en_US")
		return dateFormatter.string(from: self)
	}
	
	/// Returns a string of date in `YYYY-MM-dd` format.
	var yyyymmddRepr: String {
		return self.toString(fmt: "yyyy-MM-dd")
	}
	
	/// Returns a string of date in `M/dd/yy` format.
	var mddyyRepr: String {
		return self.toString(fmt: "M/dd/yy")
	}
	
	/// Returns a URL-safe string of a date in `M-dd-yy` format.
	var urlSafeRepr: String {
		return self.toString(fmt: "M-dd-yy")
	}
	
	/// Returns the time as typically shown on digital clocks (`h:mm am/pm`)
	var timeRepr: String {
		return self.toString(fmt: "h:mm a")
	}
	
	/// Returns the date as `MM/DD/YY H:MM AM/PM`
	var humanReadable: String {
		return "\(self.mddyyRepr), \(self.timeRepr)"
	}
	
	
	/// Returns the date as `yyyy-MM-dd HH:mm:ss xxx`
	var logRepr: String {
		return self.toString(fmt: "yyyy-MM-dd HH:mm:ss xxx")
	}
}

public extension String {
	/// Parses a string into a date using its "yyyy-MM-dd HH:mm:ss xxx" format
	/// - Returns: Date Object
	func toDateTime() -> Date {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss xxx"
			return dateFormatter.date(from: self)!
	}
}
