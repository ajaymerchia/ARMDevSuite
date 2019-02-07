//
//  LocalDataManager.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 2/7/19.
//
import Foundation
import UIKit
public class LocalData {
    public static let defaultKey = LocalData("defaultKey")
    
    public var key_name: String!
    
    
    /// Declare additional keys in a LocalData extension in your project.
    /// Use notation: "static let myCustomKey = LocalData("[uniqueIdentifier]").
    ///
    /// - Parameter key: key used by UserDefaults to manage a alue
    public init(_ key: String) {
        key_name = key
    }
    
    public static func getLocalData(forKey: LocalData) -> String? {
        let defaults = UserDefaults.standard
        guard let str = defaults.string(forKey: forKey.key_name) else {
            return nil
        }
        return str
    }
    public static func putLocalData(forKey: LocalData, data: String) {
        let defaults = UserDefaults.standard
        defaults.set(data, forKey: forKey.key_name)
    }
    
    
    public static func getLocalDataAsArr(forKey: LocalData) -> [String]? {
        let defaults = UserDefaults.standard
        guard let arr = defaults.array(forKey: forKey.key_name) as? [String] else {
            return nil
        }
        return arr
    }
    public static func putLocalData(forKey: LocalData, data: [String]) {
        let defaults = UserDefaults.standard
        defaults.set(data, forKey: forKey.key_name)
    }
    
    
    public static func deleteLocalData(forKey: LocalData) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: forKey.key_name)
    }
    
}
