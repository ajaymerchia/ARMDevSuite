//
//  ARMUtils.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 5/25/20.
//

import Foundation

public typealias StringError = String
public typealias BlankClosure = ()->()
public typealias Closure<T> = (T)->()
public typealias arm<T> = ((T?, StringError?)->())

public class ARMUtils {
	public static let urls = ARMURLUtils.shared
	public static let maps = ARMMapUtils.shared
	public static let dates = ARMDateUtils.shared
	public static let misc = ARMMiscUtils.shared
	public static let networking = ARMNetworkingUtils.shared
	
	
}
