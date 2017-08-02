//
//  SecondViewController.swift
//  CauseFeedProto2
//
//  Created by Jacob Levy on 6/8/17.
//  Copyright © 2017 Jacob Levy. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
	let myGreenBG = UIColor(colorLiteralRed: 43/255.0, green: 111/255.0, blue: 109/255.0, alpha: 1.0)

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	override func viewWillAppear(_ animated: Bool) {
		/*self.tabBarController?.tabBar.tintColor = myGreenBG
		self.tabBarController?.tabBar.backgroundColor = myGreenBG
		self.tabBarController?.tabBar.tintColor = myGreenBG
		self.tabBarController?.tabBar.backgroundColor = myGreenBG*/
		
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

