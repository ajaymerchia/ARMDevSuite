//
//  URLUtils.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 5/25/20.
//

import Foundation

public class ARMURLUtils {
	
	public static let shared = ARMURLUtils()
	
	/// Makes a string URL safe by adding percent encoding
	///
	/// - Parameter url: URL to encode
	/// - Returns: URL-safe URL
	public func makeURLSafe(_ url: String) -> String{
		return url.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
	}
	
	
	/// Causes the application to open a URL by switching to the browser.
	///
	/// - Parameter urlString: url to open
	public func openURL(_ urlString: String, completion: @escaping ((Bool)->())) {
		if let url = URL(string: urlString) {
			UIApplication.shared.open(url, options: [:], completionHandler: completion)
		}
	}
}


