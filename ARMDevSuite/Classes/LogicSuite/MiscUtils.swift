//
//  MiscUtils.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 2/7/19.
//

import Foundation
import CryptoSwift

public class ARMMiscUtils {
	/// Produces a SHA256 Hash for the given string
	///
	/// - Parameter string: value to hash
	/// - Returns: Hashed value as hex string
	public static func hash(_ string: String) -> String {
		let bytes = Data(Array(string.utf8)).sha256()
		return bytes.toHexString()
	}
	
	/// Merges two optional dictionaries, favoring the (key, value) pairs of d1
	///
	/// - Parameters:
	///   - d1: Favored Dictionary
	///   - d2: Other Dictionary
	/// - Returns: Combined Dictionary
	public static func mergeDictionaries<K, V>(d1: [K: V]?, d2: [K: V]?) -> [K: V] {
		let d1Unwrap: [K: V]! = d1 ?? [:]
		let d2Unwrap: [K: V]! = d2 ?? [:]
		let result: [K: V]! = d1Unwrap.merging(d2Unwrap) { (v1, v2) -> V in
			return v1
		}
		
		return result
	}
	
	/// Prints all Fonts that have been loaded into the application
	public static func printFontFamilies() {
		for family in UIFont.familyNames.sorted() {
			let names = UIFont.fontNames(forFamilyName: family)
			print("Family: \(family) Font names: \(names)")
		}
	}
}
