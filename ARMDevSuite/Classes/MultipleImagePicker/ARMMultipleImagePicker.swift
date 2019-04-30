//
//  ARMMultipleImagePicker.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 4/30/19.
//

import Foundation
import UIKit
import DKImagePickerController

public class ARMMultipleImagePicker: UICollectionView {
    public var imageMap: [String: UIImage] = [:]
    private var imageOrder: [String] {
        return imageMap.keys.sorted(by: {$0<$1})
    }
    
    public var contentPadding: UIEdgeInsets = ARMMultipleImagePicker.contentPadding
    
    private static let frameworkBundle = Bundle(for: ARMPhotoPickerButton.self)
    private static let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("MultipleImagePickerBundle.bundle")
    private static let resourceBundle = Bundle(url: bundleURL!)
    
    
    public var addImageIcon: UIImage = UIImage(named: "add", in: ARMMultipleImagePicker.resourceBundle, compatibleWith: nil)!
    public var removeImageIcon: UIImage = UIImage(named: "remove", in: ARMMultipleImagePicker.resourceBundle, compatibleWith: nil)!
    
    public var allowsDeletion: Bool = true
    
    
    
    private var isFirstLayout: Bool = true
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setUpView()
    }
    public init() {
        super.init(frame: .zero, collectionViewLayout: ARMMultipleImagePicker.defaultLayout)
        setUpView()
    }
    public init(layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: layout)
        setUpView()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setUpView() {
        self.register(ARMPhotoCell.self, forCellWithReuseIdentifier: ARMPhotoCell.kID)
        self.register(SpacingCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SpacingCell.kID)
        self.register(SpacingCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SpacingCell.kID)
        
        self.dataSource = self
        self.delegate = self
        
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension ARMMultipleImagePicker: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageMap.count + 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SpacingCell.kID, for: indexPath)
            
            headerView.frame.size.width = self.contentPadding.left
            
            return headerView
        } else if kind == UICollectionView.elementKindSectionFooter {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SpacingCell.kID, for: indexPath)
            
            headerView.frame.size.width = self.contentPadding.right
            
            return headerView
        } else {
            assert(false, "Unexpected element kind")
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ARMPhotoCell.kID, for: indexPath) as! ARMPhotoCell
        
        cell.contentView.subviews.forEach({$0.removeFromSuperview()})
        cell.awakeFromNib()
        
        cell.delegate = self
        
        if indexPath.row == 0 {
            let padding: CGFloat = 10
            cell.imgHolder.imageEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
            cell.imgHolder.setImage(addImageIcon.withRenderingMode(.alwaysTemplate), for: .normal)
            cell.imgHolder.tintColor = ARMPhotoCell.tintColor
        } else {
            cell.imgHolder.imageEdgeInsets = .zero
            cell.imgHolder.imageView?.contentMode = .scaleAspectFill
            let imgKey = imageOrder[indexPath.row - 1]
            cell.imgHolder.setImage(self.imageMap[imgKey], for: .normal)
            cell.imageKey = imgKey
            
            if allowsDeletion {
                cell.addDelete(img: removeImageIcon.withRenderingMode(.alwaysTemplate))
            }
            
        }
        
        
        return cell
        
    }
    
    
}

extension ARMMultipleImagePicker: UICollectionViewDelegateFlowLayout {
    /// Default Layout to be modified
    static var contentPadding: UIEdgeInsets = UIEdgeInsets(top: 4, left: .padding, bottom: 4
        , right: .padding)
    
    static var defaultLayout: UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = .padding
        layout.headerReferenceSize = CGSize(width: contentPadding.left, height: 100)
        layout.footerReferenceSize = CGSize(width: contentPadding.right, height: 100)
        
        return layout
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.frame.height - (self.contentPadding.top + self.contentPadding.bottom)
        return CGSize(width: size, height: size)
    }
    
    
}

extension ARMMultipleImagePicker {
    private func getFromLibrary(_ completion: @escaping ([UIImage]) -> ()) {
        guard let parent = self.parentViewController else {
            fatalError("Button must be added a view controller to present")
        }
        
        let pickerController = DKImagePickerController()
        pickerController.assetType = .allPhotos
        pickerController.maxSelectableCount = 0
        pickerController.sourceType = .both
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            var ret = [UIImage]()
            
            if assets.count == 0 {
                completion([])
                return
            }
            
            let imgGetters = DispatchGroup()
            assets.forEach({ (_) in
                imgGetters.enter()
            })
            
            assets.forEach({ (dk) in
                dk.fetchOriginalImage(completeBlock: { (img, _) in
                    if let img = img {
                        ret.append(img)
                        
                    }
                    imgGetters.leave()
                })
            })
            
            imgGetters.notify(queue: .main, execute: {
                completion(ret)
            })
        }
        
        parent.present(pickerController, animated: true)
    }
}

extension ARMMultipleImagePicker: ARMPhotoCellDelegate {
    func armPhotoCell(_ armPhotoCell: ARMPhotoCell, didRemoveImageWith key: String) {
        if let ind = self.imageOrder.index(of: key) {
            let index = IndexPath(row: ind + 1, section: 0)
            self.imageMap.removeValue(forKey: key)
            self.deleteItems(at: [index])
        }
    }
    
    func didRequestMoreImages(from: ARMPhotoCell) {
        self.getFromLibrary { (imgs) in
            
            let newImagesToAdd = imgs.map({ (img) -> (String, UIImage) in
                return (LogicSuite.uuid(), img)
            })
            
            newImagesToAdd.forEach({ (pair) in
                self.imageMap[pair.0] = pair.1
            })
            
            let indices = newImagesToAdd.map({ (pair) -> IndexPath in
                return IndexPath(row: self.imageOrder.index(of: pair.0)!, section: 0)
            })
            
            self.insertItems(at: indices)
        }
    }
    
    
}




public class ARMPhotoCell: UICollectionViewCell {
    static let kID = "armPhotoCell"
    static let defaultBackground = UIColor.colorWithRGB(rgbValue: 0xf2f2f2)
    static let tintColor = UIColor.colorWithRGB(rgbValue: 0x9c9c9c)
    
    static let deleteBackground: UIColor = .white
    static let deleteTint: UIColor = UIColor.colorWithRGB(rgbValue: 0x9c9c9c)
    static let deleteSize: CGFloat = 20
    static let deletePadding: CGFloat = 5
    
    var imgHolder: UIButton!
    var deleteButton: UIButton!
    var imageKey: String?
    
    var delegate: ARMPhotoCellDelegate?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        imgHolder = UIButton(); contentView.addSubview(imgHolder)
        imgHolder.center(in: contentView)
        imgHolder.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -ARMPhotoCell.deleteSize/2).isActive = true
        imgHolder.heightAnchor.constraint(equalTo: imgHolder.widthAnchor).isActive = true
        
        
        imgHolder.layer.cornerRadius = 10
        imgHolder.clipsToBounds = true
        imgHolder.setBackgroundColor(color: ARMPhotoCell.defaultBackground, forState: .normal)
        
        imgHolder.addTarget(self, action: #selector(didTapAction), for: .touchUpInside)
        
    }
    
    public func addDelete(img: UIImage) {
        deleteButton = UIButton(); contentView.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.centerXAnchor.constraint(equalTo: imgHolder.leadingAnchor, constant: 2).isActive = true
        deleteButton.centerYAnchor.constraint(equalTo: imgHolder.topAnchor, constant: 2).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: ARMPhotoCell.deleteSize).isActive = true
        deleteButton.heightAnchor.constraint(equalTo: deleteButton.widthAnchor).isActive = true
        
        deleteButton.layer.cornerRadius = ARMPhotoCell.deleteSize/2
        deleteButton.clipsToBounds = true
        deleteButton.setBackgroundColor(color: ARMPhotoCell.deleteBackground, forState: .normal)
        let padding = ARMPhotoCell.deletePadding
        deleteButton.imageEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        deleteButton.setImage(img, for: .normal)
        deleteButton.tintColor = ARMPhotoCell.deleteTint
        
        deleteButton.addTarget(self, action: #selector(didTapAction), for: .touchUpInside)
        imgHolder.isUserInteractionEnabled = false
    }
    
    @objc private func didTapAction() {
        if let key = self.imageKey {
            delegate?.armPhotoCell(self, didRemoveImageWith: key)
        } else {
            delegate?.didRequestMoreImages(from: self)
        }
    }
    
}

protocol ARMPhotoCellDelegate {
    func armPhotoCell(_ armPhotoCell: ARMPhotoCell, didRemoveImageWith key: String)
    func didRequestMoreImages(from: ARMPhotoCell)
}

private class SpacingCell: UICollectionReusableView {
    static let kID = "spacing"
}
