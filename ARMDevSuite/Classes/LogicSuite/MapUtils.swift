//
//  MapUtils.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 5/25/20.
//

import Foundation
import CoreLocation

public class ARMMapUtils {
	public static let shared = ARMMapUtils()
	
	public struct ARMStreetAddress {
		public var street: String?
		public var city: String?
		public var state: String?
		public var zip: String?
		public var postalString: String {
			return [[self.street, self.city, self.state].compactMap({$0}).joined(separator: ", "), (self.zip ?? "")].joined(separator: " ")
		}
	}
	
	/// Geocodes an address string into a CLLocation
	///
	/// - Parameters:
	///   - address: Address to be encoded
	///   - complete: Closure accepting a location, or nil if not found
	public func geocode(_ address: String, completion: Response<CLLocation>? ) {
		let geoCoder = CLGeocoder()
		geoCoder.geocodeAddressString(address) { (placemarks, error) in
			if let error = error {
				completion?(nil, error.localizedDescription)
				return
			}
			
			guard
				let placemarks = placemarks,
				let location = placemarks.first?.location
				else {
					completion?(nil, "No locations found for \(address)")
					return
			}
			
			completion?(location, nil)
		}
	}
	
	/// ReverseGeocodes a coordinate into an address structure
	///
	/// - Parameters:
	///   - coordinate: coordinate to reverse geocode
	///   - completion: passed address and error if any
	public func reverseGeocode(coordinate: CLLocationCoordinate2D, completion: Response<ARMStreetAddress>?) {
		let geoCoder = CLGeocoder()
		geoCoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { (placemark, error) in
			guard let placemark = placemark?.first, error == nil else {
				completion?(nil, error?.localizedDescription)
				return
			}
			let street = placemark.name
			let city = placemark.locality
			let state = placemark.administrativeArea
			let zip = placemark.postalCode
			
			completion?(ARMStreetAddress(street: street, city: city, state: state, zip: zip), nil)
		}
	}
}
