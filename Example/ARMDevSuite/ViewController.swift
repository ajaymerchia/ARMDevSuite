//
//  ViewController.swift
//  ARMDevSuite
//
//  Created by ajaymerchia on 02/07/2019.
//  Copyright (c) 2019 ajaymerchia. All rights reserved.
//

import UIKit
import ARMDevSuite

class ViewController: UIViewController {

    var alerts: AlertManager!
    var runTimerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        alerts = AlertManager(vc: self)
        initUI()
        
//        let button = ARMPhotoPickerButton(frame: LayoutManager.inside(inside: self.view, justified: .MidCenter, verticalPadding: 0, horizontalPadding: 0, width: view.frame.width/2, height: view.frame.width/2))
//        button.style = .profile
//        view.addSubview(button)
//        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @available(iOS 10.0, *)
    @objc func createARMHUD() {
        let hud = ARMBubbleProgressHud(for: self.view)
        hud.animationStyle = .rotateContinuous
        hud.bubbleStyle = .filled
        hud.bubbleGap = true
        hud.numBubbles = 7
        hud.setMessage(title: "Loading Your Preferences", detail: "This many take a while... Feel free to go check your email")
        
        hud.show()
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (t) in
            hud.showResult(success: true, title: "All Done!", detail: nil)
        }
    }
    
    func initUI() {
        
        runTimerButton = UIButton(frame: LayoutManager.inside(inside: self.view, justified: .TopCenter, verticalPadding: 100, horizontalPadding: 0, width: view.frame.width/1.1, height: 70))
        runTimerButton.setTitle("Start a progress HUD", for: .normal)
        runTimerButton.backgroundColor = .blue
//        runTimerButton.addTarget(self, action: #selector(askHud), for: .touchUpInside)
        if #available(iOS 10.0, *) {
            runTimerButton.addTarget(self, action: #selector(createARMHUD), for: .touchUpInside)
        } else {
            // Fallback on earlier versions
        }
        view.addSubview(runTimerButton)
        
        
        
        let displayAlertButton = UIButton(frame: LayoutManager.belowLeft(elementAbove: runTimerButton, padding: 20, width: view.frame.width/3, height: 70))
        displayAlertButton.setTitle("Display Alert", for: .normal)
        displayAlertButton.backgroundColor = .gray
        displayAlertButton.addTarget(self, action: #selector(displayAlert), for: .touchUpInside)
        view.addSubview(displayAlertButton)
        
        
        let actionSheetButton = UIButton(frame: LayoutManager.belowRight(elementAbove: runTimerButton, padding: 20, width: view.frame.width/3, height: 70))
        actionSheetButton.setTitle("Display ActionSheet", for: .normal)
        actionSheetButton.backgroundColor = .gray
        actionSheetButton.addTarget(self, action: #selector(displayAction), for: .touchUpInside)
        view.addSubview(actionSheetButton)
    }
    
    @objc func displayAlert() {
        alerts.askYesOrNo(question: "Are you ready to see an alert", helpText: "help") { (ready) in
            if ready {
                self.alerts.displayAlert(titled: "Pretty cool alert", withDetail: "Don't agree?", dismissPrompt: "I'm a dummy", completion: nil)
            } else {
                return
            }
        }
    }
    
    @objc func displayAction() {
        
        
        var configs = [ActionConfig]()
        configs.append(ActionConfig(title: "Show Alert", style: .default) {
            self.displayAlert()
        })
        configs.append(ActionConfig(title: "redo", style: .default, callback: {
            self.displayAction()
        }))
        configs.append(ActionConfig(title: "Remove Timer", style: .destructive, callback: {
            self.runTimerButton.removeFromSuperview()
        }))
        configs.append(ActionConfig(title: "nada", style: .default, callback: nil))
        
        alerts.showActionSheet(withTitle: "Are yaaaaa ready", andDetail: nil, configs: configs)
        
    }
    
    @objc func askHud() {
        alerts.getTextInput(withTitle: "How should it run for", andHelp: nil, andPlaceholder: "enter a numvber of seconds", completion: ({ (data) in
            let waitFor = Int(data)
            self.alerts.startProgressHud(withTitle: "Running")
            guard let waitingPeriod = waitFor else { return }
            if #available(iOS 10.0, *) {
                Timer.scheduledTimer(withTimeInterval: TimeInterval(waitingPeriod), repeats: false, block: { (t) in
                    
                    if waitingPeriod < 2 {
                        self.alerts.triggerHudFailure(withHeader: "Great Success", andDetail: nil)
                    } else {
                        self.alerts.triggerHudSuccess(withHeader: "Yeet", andDetail: "for realz", onComplete: {
                            self.runTimerButton.backgroundColor = .gray
                            
                            
                        })
                    }
                })
            } else {
                // Fallback on earlier versions
            }
            
        }))
        

    }

    
    

}

