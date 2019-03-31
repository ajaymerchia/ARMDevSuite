//
//  LogicSuite.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 2/7/19.
//

import Foundation
import CryptoSwift
import CoreLocation

public class LogicSuite {
    // Logic & Datastructures
    
    /// Returns a unique identifier as a string.
    ///
    /// - Returns: a unique identifier as a string
    public static func uuid() -> String {
        return UUID().uuidString
    }
    
    
    /// Produces a SHA256 Hash for the given string
    ///
    /// - Parameter string: value to hash
    /// - Returns: Hashed value as hex string
    public static func hash(_ string: String) -> String {
        let bytes = Data(Array(string.utf8)).sha256()
        return bytes.toHexString()
    }
    
    
    /// Returns a random number within the given range.
    ///
    /// - Parameters:
    ///   - from: lower bound
    ///   - upTo: upper bound
    ///   - inclusive: include the upper bound in the set of possible numbeers
    /// - Returns: Random number fitting specification
    public static func randomNum(from: Int = 0, upTo: Int, _ inclusive: Bool = false) -> Int {
        if !inclusive {
            return Int.random(in: from..<upTo)
        } else {
            return Int.random(in: from...upTo)
        }
    }
    
    
    /// Merges two optional dictionaries, favoring the (key, value) pairs of d1
    ///
    /// - Parameters:
    ///   - d1: Favored Dictionary
    ///   - d2: Other Dictionary
    /// - Returns: Combined Dictionary
    public static func mergeDictionaries(d1: [String: String]?, d2: [String: String]?) -> [String: String] {
        let d1Unwrap: [String: String]! = d1 ?? [:]
        let d2Unwrap: [String: String]! = d2 ?? [:]
        let result: [String: String]! = d1Unwrap.merging(d2Unwrap) { (str1, str2) -> String in
            return str1
        }
        
        return result
    }
    
    
    /// Geocodes an address string into a CLLocation
    ///
    /// - Parameters:
    ///   - address: Address to be encoded
    ///   - complete: Closure accepting a location, or nil if not found
    public static func geocode(_ address: String, complete: @escaping ((CLLocation?) -> ()) ) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    complete(nil)
                    return
            }
            
            // Use your location
            complete(location)
        }
    }
    
    
    
    
    // URL Stuff
    
    /// Makes a string URL safe by adding percent encoding
    ///
    /// - Parameter url: URL to encode
    /// - Returns: URL-safe URL
    public static func makeURLSafe(_ url: String) -> String{
        return url.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    
    /// Causes the application to open a URL by switching to the browser.
    ///
    /// - Parameter urlString: url to open
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
    
    /// Returns a string of date in YYYY-MM-dd format.
    public static func getYYYYMMDDRepr(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
    
    /// Returns a string of date in M/dd/yy format.
    public static func getMDDYYRepr(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/dd/yy"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
    
    /// Returns a URL-safe string of a date in M-dd-yy format.
    public static func getURLSafeDateFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M-dd-yy"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
    
    /// Returns the time as typically shown on digital clocks (h:mm am/pm)
    public static func getTimeWithAMPM(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }

    /// Returns the date as MM/DD/YY H:MM AM/PM
    public static func getFormattedDateAndTime(date: Date) -> String {
        return getMDDYYRepr(date: date) + ", " + getTimeWithAMPM(date: date)
    }
    
    
    /// Converts seconds to days
    ///
    /// - Parameter s: seconds
    /// - Returns: days
    public static func days(s: Double) -> Double {
        return s/(24.0*60*60)
    }
    
    
    /// Converts days to seconds
    ///
    /// - Parameter d: days
    /// - Returns: seconds
    public static func seconds(d: Double) -> Double {
        return d * 24.0 * 60 * 60
    }
    
    
    /// Converts hours to seconds
    ///
    /// - Parameter hr: hours
    /// - Returns: seconds
    public static func seconds(hr: Double) -> Double {
        return hr * seconds(min: 60)
    }
    
    
    /// Converts minutes to seconds
    ///
    /// - Parameter min: minutes
    /// - Returns: seconds
    public static func seconds(min: Double) -> Double {
        return min * 60
    }
    
    // Math
    
    /// Raises a base to the power of an exponent
    ///
    /// - Parameters:
    ///   - b: base
    ///   - e: exponent
    /// - Returns: result
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
    func toDateTime() -> Date
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
