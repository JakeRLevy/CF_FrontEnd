//
//  UserProfileViewController.swift
//  CauseFeedProto2
//
//  Created by Jacob Levy on 8/4/17.
//  Copyright © 2017 Jacob Levy. All rights reserved.
//
import FirebaseAuth
import UIKit

class UserProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	//have to pull the user's swipe donation amount from DB
	//and store in the user defaults
	//this should be done on the first screen load
	@IBOutlet weak var personalCauses: UICollectionView!
	fileprivate let reuseCausesID = "Causes"
	fileprivate let reuseGoalID = "Goal"
	fileprivate let reuseRaisedID = "Raised"
	fileprivate let reuseDaysID = "Days"
	fileprivate let reuseSupportID = "Support"
	fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
	//var testUserData:[String:String] = [:]
	var testUserData: [String] = []
	
 //var columnTags: [int] = [0, 1, 2, 3, 4]
	
    override func viewDidLoad() {
        super.viewDidLoad()
		personalCauses.delegate = self
		personalCauses.dataSource = self

		//Register each reuse Identifier needed
		self.personalCauses.register(typicalViewCell.self, forCellWithReuseIdentifier: "Causes")
		self.personalCauses.register(GoalCellCollectionViewCell.self, forCellWithReuseIdentifier: "Goal")
		self.personalCauses.register(RaisedViewCell.self, forCellWithReuseIdentifier: "Raised")
		self.personalCauses.register(DaysViewCell.self, forCellWithReuseIdentifier: "Days")
		self.personalCauses.register(SupportViewCell.self, forCellWithReuseIdentifier: "Support")
		//set layout
		//SET UP TEST DATA
		for position in 0...49{
			if (position % 5  == 0){
				//testUserData["Causes"] = "Causes"
				testUserData.append("Cause")
			}
			else if (position % 5 == 1){
				//testUserData["Goal"] = "Goal"
				testUserData.append("Goal")
			}
			else if (position % 5 == 2){
				//testUserData["Raised"] = "Raised"
				testUserData.append("Raised")
			}
			else if (position % 5 == 3){
				//testUserData["Days"] = "Days"
				testUserData.append("Days")
			}
			else {
				//testUserData["Support"] = "Support"
				testUserData.append("Support")
			}
			
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
		var height: CGFloat = 44
		let padding:CGFloat = 2
		var width:CGFloat = 120
		let text: String = testUserData[indexPath.item]
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
		else{
			width = personalCauses.frame.width/6
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
	
	//2
	 func collectionView(_ collectionView: UICollectionView,
	                             numberOfItemsInSection section: Int) -> Int {
		return 50
	}
	
	//3
	 func collectionView(_ collectionView: UICollectionView,
	                             cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
	//	var cell: typicalViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCausesID, for: indexPath) as! typicalViewCell
		
		print ("item is \(indexPath.item)")
		
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
	/*
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
		//		cell.Causes.frame.origin = CGPoint(x: 0, y: 18)
		cell.Causes.text = "Causes Supported"
			//	view.addSubview(cell.Causes)

			//	cell.Goal.frame.origin = CGPoint(x:120, y: 18)

		cell.Goal.text = "Goal"
				//view.addSubview(cell.Goal)

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
		cell.Causes.isHidden = true
		cell.Goal.isHidden = false
		cell.Raised.isHidden = true
		cell.Days.isHidden = true
		cell.Support.isHidden = true
		
		return cell
	}*/
	
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
