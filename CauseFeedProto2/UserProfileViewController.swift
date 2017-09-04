//
//  UserProfileViewController.swift
//  CauseFeedProto2
//
//  Created by Jacob Levy on 8/4/17.
//  Copyright © 2017 Jacob Levy. All rights reserved.
//
import FirebaseAuth
import FirebaseDatabase
		
import UIKit

class UserProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	//have to pull the user's swipe donation amount from DB
	//and store in the user defaults
	//this should be done on the first screen load
	
	private var causes:Int = 0
	 //call VWA and load the user data from the snap shot there, then remove from VDL
	var curUser: User = Auth.auth().currentUser!
	
	var currentRef: DatabaseReference! = Database.database().reference()

	var curUserData: UserDataObj = UserDataObj()
	
	private var numRows: Int = 0
		//currentUser is optional.  If there is no current user, the viewer has not signed in or they have no account (for the current version we do not allow viewing without sign in.  In the future we will want to show something to cover the "person profile" page
	@IBOutlet weak var userName: UILabel!
	@IBOutlet weak var personalCauses: UICollectionView!
	@IBOutlet weak var TotalCauses: UILabel!
	@IBOutlet weak var totalDonated: UILabel!
	@IBOutlet weak var swipeAmt: UILabel!
	@IBOutlet weak var Remaining: UILabel!
	fileprivate let reuseCausesID = "Causes"
	fileprivate let reuseGoalID = "Goal"
	fileprivate let reuseRaisedID = "Raised"
	fileprivate let reuseDaysID = "Days"
	fileprivate let reuseSupportID = "Support"
	fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
	//var testUserData:[String:String] = [:]
	var testUserData: [String] = []
	
 //var columnTags: [int] = [0, 1, 2, 3, 4]
	var numItems: Int?
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		/*var ref: DatabaseReference!
		
	
		ref = Database.database().reference()*/
		
		//let displayName: String = (self.curUser?.displayName)!
		
		self.personalCauses.delegate = self
		self.personalCauses.dataSource = self
		// Get user values from Firebase
		
		//INSERTCODE HERE
		if (self.curUserData.causeCount != nil){
			print(" CORRECT ")
			
		}
		else{
			print(" Incorrect ")
		}
		/*
		
		print("INFO: \((value?["info"])!)")
		let info = value?["info"] as? NSDictionary ?? nil
		//let keys:[String] = info?.allKeys as! [String]
		let infoVal = info?["name"] as? String ?? ""
		print( infoVal )
		
		*/
		
		
		// ...
		

		//Register each reuse Identifier needed
		self.personalCauses.register(typicalViewCell.self, forCellWithReuseIdentifier: "Causes")
		self.personalCauses.register(GoalCellCollectionViewCell.self, forCellWithReuseIdentifier: "Goal")
		self.personalCauses.register(RaisedViewCell.self, forCellWithReuseIdentifier: "Raised")
		self.personalCauses.register(DaysViewCell.self, forCellWithReuseIdentifier: "Days")
		self.personalCauses.register(SupportViewCell.self, forCellWithReuseIdentifier: "Support")
		//set layout
		//SET UP TEST DATA
		
		
		personalCauses.contentInset.bottom = 30
		if (self.numRows > 0){
			print ("numRows from VDL: \(self.numRows)")
		}
		
		///////////
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0
		personalCauses.collectionViewLayout = layout
		
		

		
	}
	
	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	@objc func collectionView(_ sizeForItemAtcollectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
	                          sizeForItemAt indexPath: IndexPath) -> CGSize {
	//	print ("Item #\(indexPath.item)")  //print statement for debugging
		var height: CGFloat = 44
		let padding:CGFloat = 2
		var width:CGFloat = 120
		var text: String
		if (testUserData.count > 0){
		text = self.testUserData[indexPath.item]
		}
		else{
			text = "Nothing Created Yet"
		}
		height = self.estimatedFrameHeight(text: text).height + padding
		if (text == "Cause"){
			width = personalCauses.frame.width/3
		}
		else if (text == "Goal"){
			width  = personalCauses.frame.width/6
		}
		else if (text == "Raised"){
			width = personalCauses.frame.width/6
		}
		else if (text == "Days"){
			width = personalCauses.frame.width/6
		}
		else if (text == "Support"){
			width = personalCauses.frame.width/6
		}
		else{
			width = personalCauses.frame.width/5
		}
		
		  return CGSize(width: width, height: 44)
	}
	private func estimatedFrameHeight(text:String) -> CGRect{
		//we make the height arbitrarily large so we don't undershoot height in calculation
		let height: CGFloat = 1000
		let size = CGSize(width: 1000, height: height)
		let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
		let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular)]
		
		return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
	}
	
	
	
	 func numberOfSections(in collectionView: UICollectionView) -> Int {
		
		
		return 1
	}
	
	//Returns a number of cells = to the total number of Causes * 5 fields per Cause
	
	 func collectionView(_ collectionView: UICollectionView,
	                             numberOfItemsInSection section: Int) -> Int {
		
		if (self.numRows >= 1){
	
		print("Number of Items in Section called, causes: \(self.numRows * 5)")
		return  (self.numRows * 5)
		} else {
	
			return 5;  //return a single row if there is an error in calculating number of rows
		}
	}
	
	// Function that determines what type of cell each cell actually is
	 func collectionView(_ collectionView: UICollectionView,
	                             cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
	
		
		//print ("item is \(indexPath.item)")
		
		if (indexPath.item % 5 == 0){
		
		let CauseCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCausesID, for: indexPath) as!typicalViewCell
		CauseCell.textLabel?.text  = "Causes Supported"
		//	CauseCell.textLabel.sizeToFit()
		//	if (indexPath.item > 0){
		CauseCell.frame = CGRect(x: CauseCell.frame.origin.x, y: CauseCell.frame.origin.y, width: personalCauses.frame.width/3, height: 44)
			/*}
			else{
				CauseCell.frame = CGRect(x: personalCauses.frame.origin.x, y: personalCauses.frame.origin.y, width: 120, height: 44)
			}*/
			CauseCell.layer.borderWidth = 1
			CauseCell.layer.borderColor = UIColor.black.cgColor
			return CauseCell
		// Configure the cell
			//cell = CausesCell
			//return CausesCell
		}
		else if (indexPath.item % 5 == 1){
			
			 let GoalCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseGoalID,
			                                                    for: indexPath) as! GoalCellCollectionViewCell
			GoalCell.textLabel?.text  = "Goal"
			GoalCell.frame = CGRect(x: GoalCell.frame.origin.x, y: GoalCell.frame.origin.y, width: personalCauses.frame.width/6, height: 44)
			//GoalCell.textLabel.sizeToFit()
			//GoalCell.frame = CGRect(x: Cause, y: 0 , width: 50, height: 44)
			GoalCell.layer.borderWidth = 1
			GoalCell.layer.borderColor = UIColor.black.cgColor
			return GoalCell
			// Configure the cell
			//cell = GoalCell
			//return CausesCell
		}
			else if (indexPath.item % 5 == 2){
			
			let RaisedCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseRaisedID,
			                                                    for: indexPath) as! RaisedViewCell
			RaisedCell.textLabel.text  = "Raised"
			RaisedCell.frame = CGRect(x: RaisedCell.frame.origin.x, y: RaisedCell.frame.origin.y, width: personalCauses.frame.width/6, height: 44)
			// Configure the cell
			//cell = RaisedCell
			RaisedCell.layer.borderWidth = 1
			RaisedCell.layer.borderColor = UIColor.black.cgColor
			return RaisedCell
		}
		else if (indexPath.item % 5 == 3){
			
			let DaysCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseDaysID,
			                                                    for: indexPath) as! DaysViewCell
			DaysCell.textLabel?.text  = "Days"
			DaysCell.frame = CGRect(x: DaysCell.frame.origin.x, y: DaysCell.frame.origin.y, width: personalCauses.frame.width/6, height: 44)
			
			// Configure the cell
			//cell = DaysCell
			DaysCell.layer.borderWidth = 1
			DaysCell.layer.borderColor = UIColor.black.cgColor
			return DaysCell
		}
		else /*if (indexPath.item % 5 == 4)*/{
			
			let SupportCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseSupportID,
			                                                    for: indexPath) as! SupportViewCell
			SupportCell.textLabel.numberOfLines = 5
			SupportCell.textLabel?.text  = "My Support"
			SupportCell.frame = CGRect(x: SupportCell.frame.origin.x, y: SupportCell.frame.origin.y, width: personalCauses.frame.width/6, height: 44)
			// Configure the cell
			//cell = SupportCell
			SupportCell.layer.borderWidth = 1
			SupportCell.layer.borderColor = UIColor.black.cgColor
			return SupportCell
		}
			}
	
	var handle: AuthStateDidChangeListenerHandle?
	
	override func viewWillAppear(_ animated: Bool) {
		self.personalCauses.isHidden = true
		if let currentUser = Auth.auth().currentUser { //if there is a current user
			self.curUser = currentUser //set the local page variable curUser to the currentUser
			print ("Current User :  SUCCESS")
		}else{
			//eventually we can create a "guest" user who will view something other than personal page when not logged in
			//For now if no current user, we shouldn't be able to view the page so error
			self.userName.text = "Error LINE 290"
			print ("ERROR Line 291")
		}
	
		UserDataObj.loadCurrentUserData {
	//DispatchQueue? May update this function to utilize Swift Dispatch Queues to improve load time
			(userCurrent) in
			self.curUserData = userCurrent
			self.numRows = userCurrent.causeCount!
			
			for position in 0..<(userCurrent.causeCount! * 5){
				//print("Item # \(position)")  //Print statement for debugging
				if (position % 5  == 0){
					self.testUserData.append("Cause")
				}
				else if (position % 5 == 1){
					self.testUserData.append("Goal")
				}
				else if (position % 5 == 2){
					self.testUserData.append("Raised")
				}
				else if (position % 5 == 3){
					self.testUserData.append("Days")
				}
				else {
					//testUserData["Support"] = "Support"
					self.testUserData.append("Support")
				}
			}
			self.TotalCauses.text = String(format: "%4d",self.curUserData.causeCount!)
			
			self.totalDonated.text = String(format: "$%.2f",(self.curUserData.donatedTotal! / 100))
			
			self.swipeAmt.text =  String(format: "$%.2f",(self.curUserData.swipeAmt! / 100))
			self.Remaining.text =  String(format: "$%.2f",(self.curUserData.balance! / 100))
			self.personalCauses.reloadData()
			self.personalCauses.isHidden = false

		}
		
		//	var curUserData: UserDataObj = UserDataObj()
		
		

		
	}
	
	func isThereAUser(Count: Int) -> Void{
		if (Count > 0){
			self.numRows = Count
			print ("Current User Data Object Created, number of Rows = \(Count)")
		}
		else{
			print("Error line 280, No user data object created")
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
	
		
	
	}
	
	

}
