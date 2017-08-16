//
//  UserProfileViewController.swift
//  CauseFeedProto2
//
//  Created by Jacob Levy on 8/4/17.
//  Copyright © 2017 Jacob Levy. All rights reserved.
//
import FirebaseAuth
import UIKit

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	//have to pull the user's swipe donation amount from DB
	//and store in the user defaults
	//this should be done on the first screen load
	@IBOutlet weak var personalCauses: UITableView!
 var tabledata: [String] = ["20", "$100.00", "$0.20"]
    override func viewDidLoad() {
        super.viewDidLoad()
		personalCauses.delegate = self
		personalCauses.dataSource = self
  //UITabBar.appearance().ackgroundColor = myGreenBG
		
        // Do any additional setup after loading the view.
    }
	
	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return 10 //for now, eventually will need count from DB
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell:BasicTableRow = tableView.dequeueReusableCell(withIdentifier: "Basic", for: indexPath) as! BasicTableRow
		
			if (indexPath.row == 0){
		cell.Causes.text = "Causes Supported"
		cell.Goal.text = "Goal"
		cell.Raised.text = "Raised"
		cell.Days.text = "Days Remaining"
		cell.Support.text = "My Support"
		
			}
		if (indexPath.row > 0)
		{
		cell.Causes.text = "Sample Cause: Funding for Charity"
		cell.Goal.text = "$500.00"
		cell.Raised.text = "$235.75"
		cell.Days.text = "10"
		cell.Support.text = "53.25"
		}
		
		return cell
	}
	
	var handle: AuthStateDidChangeListenerHandle?
	
	override func viewWillAppear(_ animated: Bool) {
	
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
	
	

}
