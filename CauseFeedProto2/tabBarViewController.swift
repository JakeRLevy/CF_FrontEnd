	//
//  tabBarViewController.swift
//  CauseFeedProto2
//
//  Created by Jacob Levy on 6/12/17.
//  Copyright © 2017 Jacob Levy. All rights reserved.
//

import UIKit

class tabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

		
		//Code to render the unselected images in the tab bar
		for items in 0 ..< tabBar.items!.count {
			let tabItemIndex = tabBar.items![items]
			tabItemIndex.image = tabItemIndex.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
			
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
