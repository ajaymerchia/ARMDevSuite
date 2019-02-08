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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initUI() {
        
        runTimerButton = UIButton(frame: LayoutManager.inside(inside: self.view, justified: .TopCenter, verticalPadding: 100, horizontalPadding: 0, width: view.frame.width/1.2, height: 70))
        runTimerButton.setTitle("Start a progress HUD", for: .normal)
        runTimerButton.backgroundColor = .blue
        runTimerButton.addTarget(self, action: #selector(askHud), for: .touchUpInside)
        view.addSubview(runTimerButton)
        
        
        
        let displayAlertButton = UIButton(frame: LayoutManager.belowLeft(elementAbove: runTimerButton, padding: 20, width: view.frame.width/2.2, height: 70))
        displayAlertButton.setTitle("Display Alert", for: .normal)
        displayAlertButton.backgroundColor = .gray
        displayAlertButton.addTarget(self, action: #selector(displayAlert), for: .touchUpInside)
        view.addSubview(displayAlertButton)
        
        
        let actionSheetButton = UIButton(frame: LayoutManager.belowRight(elementAbove: runTimerButton, padding: 20, width: view.frame.width/2.2, height: 70))
        actionSheetButton.setTitle("Display ActionSheet", for: .normal)
        actionSheetButton.backgroundColor = .gray
        actionSheetButton.addTarget(self, action: #selector(displayAction), for: .touchUpInside)
        
    }
    
    @objc func displayAlert() {
        alerts.askYesOrNo(question: "Are you ready to see an alert", helpText: "help") { (ready) in
            if ready {
                self.alerts.displayAlert(titled: "Pretty cool alert", withDetail: "Don't agree?", dismissPrompt: "I'm a dummy")
            } else {
                return
            }
        }
    }
    
    @objc func displayAction() {
        
        let configs = [(String?, UIAlertAction.Style, (()->())?)]()
        
        alerts.showActionSheet(withTitle: "Whaddya wanna do?", andDetail: nil, configs: <#T##[(String?, UIAlertAction.Style, (() -> ())?)]#>)
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

