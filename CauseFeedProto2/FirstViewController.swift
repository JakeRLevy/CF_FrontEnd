//
//  FirstViewController.swift
//  CauseFeedProto2
//
//  Created by Jacob Levy on 6/8/17.
//  Copyright © 2017 Jacob Levy. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
				// Do any additional setup after loading the view, typically from a nib.
		
	}
	override func viewWillAppear(_ animated: Bool) {
		/*self.tabBarController?.tabBar.tintColor = myGreenBG
		self.tabBarController?.tabBar.backgroundColor = myGreenBG*/
		for tabBarItem in (self.tabBarController?.tabBar.items!)!{
			tabBarItem.title = ""
			tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
			
		}
		
		
		
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

