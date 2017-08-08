//
//  UserProfileViewController.swift
//  CauseFeedProto2
//
//  Created by Jacob Levy on 8/4/17.
//  Copyright © 2017 Jacob Levy. All rights reserved.
//
import FirebaseAuth
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
	var handle: AuthStateDidChangeListenerHandle?
	
	override func viewWillAppear(_ animated: Bool) {
		// handle = Auth.auth().addStateDidChangeListener{ (auth, user) in
	//		print("Listening State Added for current user")
	//	}
		 let user = Auth.auth().currentUser
		if user != nil {
			print("There is a current USER\n")
			let uid = user?.uid
			print("current user ID: \(String(describing: uid))")
			let email = user?.email
			print("Current user EMAIL:\(String(describing: email))")
		}
		else{
			print("NO CURRENT USERS")
		}
	}
	
	@IBAction func TappedSignOut(_ sender: Any) {
		let firebaseAuth = Auth.auth()
		do {
			try firebaseAuth.signOut()
			print("SIGNING OUT")
			self.performSegue(withIdentifier: "Exit", sender: nil)
			
		} catch let signOutError as NSError {
			print ("Error signing out of app: %@", signOutError)
		}
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
