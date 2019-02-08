//
//  LogicSuite.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 2/7/19.
//

import Foundation

public class LogicSuite {
    // Logic & Datastructures
    public static func uuid() -> String {
        return UUID().uuidString
    }
    
    public static func randomNum(from: Int = 0, upTo: Int, _ inclusive: Bool = false) -> Int {
        if !inclusive {
            return Int.random(in: from..<upTo)
        } else {
            return Int.random(in: from...upTo)
        }
    }
    
    public static func mergeDictionaries(d1: [String: String]?, d2: [String: String]?) -> [String: String] {
        let d1Unwrap: [String: String]! = d1 ?? [:]
        let d2Unwrap: [String: String]! = d2 ?? [:]
        let result: [String: String]! = d1Unwrap.merging(d2Unwrap) { (str1, str2) -> String in
            return str1
        }
        
        return result
    }
    
    
    
    
    // URL Stuff
    public static func makeURLSafe(_ url: String) -> String{
        return url.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    public static func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            print("Opening URL: \(urlString)")
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    // Time Management Stuff
    public static func getYYYYMMDDRepr(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
    
    public static func getMDDYYRepr(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/dd/yy"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
    
    public static func getURLSafeDateFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M-dd-yy"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
    
    public static func getTimeWithAMPM(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
    
    public static func getFormattedDateAndTime(date: Date) -> String {
        return getMDDYYRepr(date: date) + ", " + getTimeWithAMPM(date: date)
    }
    
    public static func days(s: Double) -> Double {
        return s/(24.0*60*60)
    }
    
    public static func seconds(d: Double) -> Double {
        return d * 24.0 * 60 * 60
    }
    
    public static func seconds(hr: Double) -> Double {
        return hr * seconds(min: 60)
    }
    
    public static func seconds(min: Double) -> Double {
        return min * 60
    }
    
    
    // JSON Read Stuff
    public static func jsonSwitchBlank(potential blank: String, with substitute: String) -> String {
        if blank == "" {
            return substitute
        }
        return blank
    }
    
    // Math
    public static func pow(b: Int, e: Int) -> Int {
        var ret = 1
        for _ in 1...e {
            ret = ret * b
        }
        
        return ret
    }
    
    /// Prints all Fonts that have been loaded into the application
    public static func printFontFamilies() {
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
    }
}

public extension String
{
    public func toDateTime() -> Date
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss xxx"
        
        //Parse into NSDate
        let dateFromString : Date = dateFormatter.date(from: self)!
        
        //Return Parsed Date
        return dateFromString
    }
}
