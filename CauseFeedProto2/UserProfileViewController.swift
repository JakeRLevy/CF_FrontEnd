//
//  UserProfileViewController.swift
//  CauseFeedProto2
//
//  Created by Jacob Levy on 8/4/17.
//  Copyright © 2017 Jacob Levy. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

  //UITabBar.appearance().ackgroundColor = myGreenBG
		
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	override func viewWillAppear(_ animated: Bool) {
		//UITabBar.appearance().backgroundColor = UIColor(colorLiteralRed: 43/255.0, green: 111/255.0, blue: 109/255.0, alpha: 1.0)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		//UITabBar.appearance().backgroundColor = UIColor(colorLiteralRed: 43/255.0, green: 111/255.0, blue: 109/255.0, alpha: 1.0)
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
