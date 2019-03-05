//
//  ARMPhotoPicker.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 3/4/19.
//

import Foundation
import UIKit
import DKImagePickerController
import ARMDevSuite

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}



public class ARMPhotoPickerButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        innerLabel = UILabel(frame: CGRect(x: 0, y: self.frame.height - 30, width: self.frame.width, height: 30))
        configureLabel()
        reshape()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Coloring
    private static var skyBlue = UIColor.colorWithRGB(rgbValue: 0x40c8e1)
    private static var placeholder = UIColor.colorWithRGB(rgbValue: 0xa8a8a8)
    private static var avatar = UIImage(named: "avatar")!.withRenderingMode(.alwaysTemplate)
    
    // Styling
    /// Determines the appearance and behavior of ARMPhotoPicker
    public var style: ARMPhotoPickerStyle = .normal {
        didSet {
            reshape()
        }
    }
    
    /// Configuration for ARMPhotoPicker when in profile mode
    public var profileConfig: ARMPhotoPickerProfileConfig  = .normal {
        didSet {
            reshape()
        }
    }
    
    
    
    // Functionality
    
    /// Determines the source of any media to be imported
    public var sourceType: DKImagePickerControllerSourceType = .both
    
    /// Read https://github.com/zhangao0086/DKImagePickerController before setting
    public var UIDelegate: DKImagePickerControllerBaseUIDelegate?
    
    /// Delegate object to receive UIImages.
    public var delegate: ARMPhotoPickerDelegate?
    
    public var innerLabel: UILabel!
    
    
    /// Receives any profile pictures if selected
    private(set) public var profileImage: UIImage?
    
    // Internal Functionality
    private var origin: UIViewController!
    private var userSetImage: Int?
    private var maximumImages = 0
    
    
    /// Maximum number of images the user can select. 0 means no limit. Set to 1 when in profile mode.
    public func setMaxImage(to: Int) {
        if self.style == .profile {
            self.userSetImage = to
        } else {
            self.maximumImages = to
        }
    }
    
    
    
    public func getImages(src: UIViewController) {
        self.origin = src
        getFromLibrary()
    }
    
    private func configureLabel() {
        innerLabel.textAlignment = .center
        innerLabel.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        innerLabel.textColor = ARMPhotoPickerButton.skyBlue
        innerLabel.text = self.profileConfig.selectedText
    }
    
    private func resetButton() {
        if let oldCount = self.userSetImage {
            self.maximumImages = oldCount
            self.userSetImage = nil
        }
        if innerLabel != nil {
            innerLabel.removeFromSuperview()
        }
        self.removeTarget(self, action: #selector(editPhoto), for: .touchUpInside)
        
        self.addTarget(self, action: #selector(getFromLibrary), for: .touchUpInside)
        
        self.tintColor = .white
        self.clipsToBounds = false
        self.layer.cornerRadius = 0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0
        self.backgroundColor = .white
        self.setBackgroundColor(color: .white, forState: .normal)
        self.setImage(nil, for: .normal)
    }
    
    func reshape() {
        switch self.style {
        case .custom:
            resetButton()
        case .normal:
            resetButton()
            self.setBackgroundColor(color: ARMPhotoPickerButton.skyBlue, forState: .normal)
            self.layer.cornerRadius = self.frame.height/2
            self.clipsToBounds = true
            self.setTitle("Get Images", for: .normal)
            self.setTitleColor(.white, for: .normal)
        case .profile:
            resetButton()
            self.userSetImage = self.maximumImages
            self.maximumImages = 1
            self.tintColor = ARMPhotoPickerButton.placeholder
            
            self.imageView?.contentMode = .scaleAspectFill
            self.clipsToBounds = true
            
            self.setImage(self.profileImage ?? ARMPhotoPickerButton.avatar, for: .normal)
            
            // if circle mode do the thing
            if self.profileConfig.circular {
                self.layer.cornerRadius = self.frame.height/2
            }
            
            innerLabel.text = self.profileConfig.unselectedText
            
            if self.profileImage != nil {
                self.removeTarget(self, action: #selector(getFromLibrary), for: .touchUpInside)
                self.addTarget(self, action: #selector(editPhoto), for: .touchUpInside)
                innerLabel.text = self.profileConfig.selectedText
            }
            
            self.layer.borderWidth = 1
            self.layer.borderColor = ARMPhotoPickerButton.placeholder.cgColor
            
            
            
            self.imageView?.addSubview(innerLabel)
            
            
            
        }
        
    }
    
    @objc private func getFromLibrary() {
        guard let parent = self.parentViewController else {
            fatalError("Button must be added a view controller to present")
        }
        origin = parent
        
        
        let pickerController = DKImagePickerController()
        pickerController.assetType = .allPhotos
        pickerController.maxSelectableCount = maximumImages
        pickerController.sourceType = self.sourceType
        if let uiManager = self.UIDelegate {
            pickerController.UIDelegate = uiManager
        }
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            var ret = [UIImage]()
            var failures = 0
            
            if assets.count == 0 {
                self.delegate?.photoPicker(self, received: ret)
                return
            }
            
            for asset in assets {
                asset.fetchOriginalImage(completeBlock: { (img, _) in
                    if let img = img {
                        ret.append(img)
                    } else {
                        failures+=1
                    }
                    
                    if ret.count == (assets.count - failures) {
                        if self.style == .profile {
                            self.profileImage = ret.first
                            self.reshape()
                        }
                        
                        self.delegate?.photoPicker(self, received: ret)
                    }
                })
            }
        }
        
        origin.present(pickerController, animated: true)
    }
    
    @objc private func editPhoto() {
        guard let parent = self.parentViewController else {
            fatalError("Button must be added a view controller to present")
        }
        origin = parent
        
        let alert = AlertManager(vc: origin)
        alert.showActionSheet(withTitle: nil, andDetail: nil, configs: [
            ActionConfig(title: "Change Photo", style: .default, callback: {
                self.getFromLibrary()
            }),
            ActionConfig(title: "Remove Photo", style: .destructive, callback: {
                self.profileImage = nil
                self.reshape()
                
            })
            ])
        
    }
}
