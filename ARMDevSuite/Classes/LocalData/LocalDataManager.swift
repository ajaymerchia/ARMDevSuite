//
//  LocalDataManager.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 5/25/20.
//
import Foundation
import UIKit

@propertyWrapper
/// Makes the value of a given variable live in UserDefaults
struct UserDefaultsBacked<Value> {
	let key: String
	var storage: UserDefaults = .standard
	
	var wrappedValue: Value? {
		get { storage.value(forKey: key) as? Value }
		set { storage.setValue(newValue, forKey: key) }
	}
}
