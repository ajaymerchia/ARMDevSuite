//
//  MenuViewController.swift
//  ARMDevSuite_Example
//
//  Created by Ajay Merchia on 5/25/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import ARMDevSuite



class SimpleMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	var targets: [(String, UIViewController.Type)] = [] {
		didSet {
			self.table.reloadData()
		}
	}
	
	var table = UITableView()
	
	override func viewDidLoad() {
		guard self.navigationController != nil else {
			fatalError("Can not present \(String(describing: self)) outside of UINavigationController context")
		}
		initUI()
	}
	
	func initUI() {
		self.view.addSubview(table)
		table.translatesAutoresizingMaskIntoConstraints = false
		table.pinTo(self.view, safeAreaLayoutGuide: true)
		
		self.table.dataSource = self
		self.table.delegate = self
		
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return targets.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: "menu_item")
		cell.textLabel?.text = targets[indexPath.row].0
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let clazz = targets[indexPath.row].1
		self.navigationController?.pushViewController(clazz.init(), animated: true)
		
	}
	
	
	
	
	
}


