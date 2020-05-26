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
public typealias Response<T> = ((T?, StringError?)->())

public class ARMUtils {
	public static let urls = ARMURLUtils()
	public static let maps = ARMMapUtils()
	public static let dates = ARMDateUtils()
	public static let misc = ARMMiscUtils()
	
	
	
}
