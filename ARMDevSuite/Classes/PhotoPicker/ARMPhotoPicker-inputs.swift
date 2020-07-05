//
//  ARMPhotoPicker-inputs.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 3/4/19.
//

import Foundation

public enum ARMPhotoPickerStyle {
    case custom
    case normal
    case profile
}

public class ARMPhotoPickerProfileConfig {
    
    public static var normal = ARMPhotoPickerProfileConfig()
    
    public var circular: Bool!
    public var selectedText: String!
    public var unselectedText: String!
    public var borderColor = UIColor(hex: 0xa8a8a8)
    public var borderWidth: CGFloat = 1
    
    public var tintColor = UIColor(hex: 0xa8a8a8)
    
    public init(circular: Bool = true, selectedText: String = "edit", unselectedText: String = "select") {
        self.circular = circular
        self.selectedText = selectedText
        self.unselectedText = unselectedText
    }
}
