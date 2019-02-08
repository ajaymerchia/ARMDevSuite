//
//  AlertManager.swift
//  ARMDevSuite
//
//  Created by Ajay Merchia on 2/7/19.
//

import Foundation
import UIKit
import JGProgressHUD

public class AlertManager {
    private var vc: UIViewController!
    private(set) public var callback: (() -> ())?
    public var hud: JGProgressHUD?
    
    // Yes or No Question Variables
    public var affirmativePrompt = "Yes"
    public var negatoryPrompt = "No"
    
    // Hud config variables
    public var hudResponseWait = 1.5
    
    public init(vc: UIViewController) {
        self.vc = vc
    }
    
    public init(vc: UIViewController, defaultHandler: @escaping (() -> ()) ) {
        self.vc = vc
        callback = defaultHandler
    }
    
    public func displayAlert(titled title: String?, withDetail message: String?, dismissPrompt: String = "Ok") {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: dismissPrompt, style: .default, handler: nil)
        alert.addAction(defaultAction)
        vc.present(alert, animated: true, completion: nil)
        callback?()
    }
    
    
    /// Asks a binary question with help text
    ///
    /// - Parameters:
    ///   - question: Question to be asked
    ///   - helpText: Any help text in a smaller font
    ///   - onAnswer: Returns whether if the affirmative response was selected
    public func askYesOrNo(question: String, helpText: String?, onAnswer: @escaping (Bool) -> ()) {
        
        let alert = UIAlertController(title: question, message: helpText, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: affirmativePrompt, style: .default, handler: { (_) in
            onAnswer(true)
        }))
        alert.addAction(UIAlertAction(title: negatoryPrompt, style: .destructive, handler: { (_) in
            
            onAnswer(false)
        }))
        
        vc.present(alert, animated: true) {
            self.resetDefaultText()
        }
        
    }
    
    public func startProgressHud(withTitle:String, withDetail: String? = nil, style: JGProgressHUDStyle = .light) {
        self.hud = JGProgressHUD(style: style)
        self.hud?.textLabel.text = withTitle
        self.hud?.detailTextLabel.text = withDetail
        self.hud?.show(in: self.vc.view)
    }
    
    @available(iOS 10.0, *)
    public func triggerHudFailure(withHeader: String?, andDetail: String?, onComplete: @escaping() -> () = {}) {
        hud?.indicatorView = JGProgressHUDErrorIndicatorView(contentView: vc.view)
        changeHUD(toTitle: withHeader, andDetail: andDetail)
        self.hud?.dismiss(afterDelay: hudResponseWait, animated: true)
        Timer.scheduledTimer(withTimeInterval: hudResponseWait, repeats: false) { (t) in
            onComplete()
        }
    }
    
    @available(iOS 10.0, *)
    public func triggerHudSuccess(withHeader: String?, andDetail: String?, onComplete: @escaping() -> () = {}) {
        hud?.indicatorView = JGProgressHUDSuccessIndicatorView(contentView: vc.view)
        changeHUD(toTitle: withHeader, andDetail: andDetail)
        self.hud?.dismiss(afterDelay: hudResponseWait, animated: true)
        Timer.scheduledTimer(withTimeInterval: hudResponseWait, repeats: false) { (t) in
            onComplete()
        }

    }
    
    public func changeHUD(toTitle: String?, andDetail: String?) {
        if let title = toTitle {
            self.hud?.textLabel.text = title
        }
        if let detail = andDetail {
            self.hud?.detailTextLabel.text = detail
        }
    }
    

    public func getTextInput(withTitle: String, andHelp: String?, andPlaceholder: String, placeholderAsText: Bool = false,  completion: @escaping (String) -> (), cancellation: @escaping () -> () = {}) {
        let alert = UIAlertController(title: withTitle, message: andHelp, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { textField in
            if placeholderAsText {
                textField.text = andPlaceholder
            } else {
                textField.placeholder = andPlaceholder
                
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            _ in
            cancellation()
        }))
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { action in
            guard let response = alert.textFields?.first?.text else {
                cancellation()
                return
            }
            completion(response)
        }))
        
        vc.present(alert, animated: true)
    }
    
   
    
    public func showActionSheet(withTitle: String?, andDetail: String?, configs: [ActionConfig]) {
        
        let actionSheet = UIAlertController(title: withTitle, message: andDetail, preferredStyle: .actionSheet)
        
        for config in configs {
            actionSheet.addAction(UIAlertAction(title: config.title, style: config.style, handler: { (_) in
                guard let callback = config.callback else {
                    return
                }
                callback()
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.popoverPresentationController?.sourceView = vc.view
        
        vc.present(actionSheet, animated: true)
        
    }
    
    private func resetDefaultText() {
        affirmativePrompt = "Yes"
        negatoryPrompt = "No"
    }
    
    
    
}

public struct ActionConfig {
    public var title: String
    public var style: UIAlertAction.Style
    public var callback: (()->())?
    
    public init(title: String, style: UIAlertAction.Style, callback: (()->())?) {
        self.title = title
        self.style = style
        self.callback = callback
    }
}
    
