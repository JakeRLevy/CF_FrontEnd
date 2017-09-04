//
//  LoginViewController.swift
//  CauseFeedProto2
//
//  Created by Jacob Levy on 6/14/17.
//  Copyright © 2017 Jacob Levy. All rights reserved.
//

import UIKit
//import FacebookLogin

class LoginViewController: UIViewController {

	@IBOutlet weak var CFlogo: UIImageView!
	@IBOutlet weak var SignUpView: UIView!
	@IBOutlet weak var SignInView: UIView!
	
	@IBOutlet weak var logInIMG: UIImageView!
	weak var currentVC: UIViewController?
	private var embeddedVC: UIViewController!
	/*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let currentVC = segue.destination as? SignInViewController, segue.identifier == "segueSignUp"{
			self.embeddedVC = currentVC
	}
	}*/
    override func viewDidLoad() {
	
		logInIMG.image = UIImage(named: "met_office_body")
		CFlogo.image = UIImage(named: "CauseFeedLogo")
	
		
	}
	@IBAction func LoginButt(_ sender: Any) {
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
