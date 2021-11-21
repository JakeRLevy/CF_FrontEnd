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
	private var rowHeight: CGFloat = 0
	private var causes:Int = 0
	 //call VWA and load the user data from the snap shot there, then remove from VDL
	var curUser = Auth.auth().currentUser
	
	
	var currentRef: DatabaseReference! = Database.database().reference()
	let dateFormatPython = "yyyy-MM-dd"
	private var loadFinished: Bool = false
	private var loadStarted: Bool = false
	private var loadAlert: UIAlertController = UIAlertController()
	var curUserData: UserDataObj = UserDataObj()
	var currentUserProfile : profileDataObject? = profileDataObject()
	var usersCauses = [CauseModel]()
	var downloadedCauses = [causeDataObject]()
	private var causeFlag: Bool = false
	private var numRows: Int = 0
		//currentUser is optional.  If there is no current user, the viewer has not signed in or they have no account (for the current version we do not allow viewing without sign in.  In the future we will want to show something to cover the "person profile" page
	@IBOutlet weak var userName: UILabel!
	@IBOutlet weak var tableHeader: UICollectionReusableView!
	
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
		
	
		//Set the delegate & datasource of the personal causes table to this class
		self.personalCauses.delegate = self
		self.personalCauses.dataSource = self
		self.personalCauses.register(ColumnHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
		self.personalCauses.register(typicalViewCell.self, forCellWithReuseIdentifier: "Causes")
		self.personalCauses.register(GoalCellCollectionViewCell.self, forCellWithReuseIdentifier: "Goal")
		self.personalCauses.register(RaisedViewCell.self, forCellWithReuseIdentifier: "Raised")
		self.personalCauses.register(DaysViewCell.self, forCellWithReuseIdentifier: "Days")
		self.personalCauses.register(SupportViewCell.self, forCellWithReuseIdentifier: "Support")
		
		//FOR DEBUGGING
		personalCauses.contentInset.bottom = 30
		if (self.numRows > 0){
			print ("numRows from VDL: \(self.numRows)")
		}
		
		//set layout
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0
		personalCauses.collectionViewLayout = layout
		self.loadAlert.dismiss(animated: false, completion: nil)
		
		
		
	}

	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	//Delegate method for determining the size of an item(cell) in the collection
	@objc func collectionView(_ sizeForItemAtcollectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
	                          sizeForItemAt indexPath: IndexPath) -> CGSize {
	//set a basic/default size for the cells
		var height: CGFloat = 44
		let padding:CGFloat = 2
		var width:CGFloat = 120
		var text: String
		//the String array TestUSerData corresponds to the number of cells currently stored in the collection
		//if there are any elements in the testUserData Array then there are cells in the collection
		//otherwise no cells have been added yet
		if (testUserData.count > 0){
		text = self.testUserData[indexPath.item]
		}
		else{
			text = "Nothing Created Yet"
		}
		//dynamic cell height
		
		//Every 5 cells in the collection correspond to a single cause row, with 1-1 correspondence with every 5 elements in the String Array which can essentially be thought of as holding the cell's type
		//First will be a Cause Cell, then Goal Cell, then Raised Cell, then Days Cell, and finally a Support Cell
		//This code checks for the type from the TestUserData Array and sets the corresponding cell's size to the appropriate width
		if (text == "Cause"){
			width = personalCauses.frame.width/3
			height = max(self.estimatedFrameHeight(text: text).height + padding, height)  //estimates the height based on the amount of text and chooses the max between that and the default height
			self.rowHeight = height //set the class variable rowheight to the height of the cause cell
		}
		else if (text == "Goal"){
			width  = personalCauses.frame.width/6
			height = self.rowHeight  //set the height of following elements to the same height as the current cause height
		}
		else if (text == "Raised"){
			width = personalCauses.frame.width/6
			height = self.rowHeight
		}
		else if (text == "Days"){
			width = personalCauses.frame.width/6
			height =  self.rowHeight
		}
		else if (text == "Support"){
			width = personalCauses.frame.width/6
			height = self.rowHeight
		}
		else{
			width = personalCauses.frame.width/5
			height = 44
			
		}
		
		  return CGSize(width: width, height: height)
	}
	private func estimatedFrameHeight(text:String) -> CGRect{
		//we make the height arbitrarily large so we don't undershoot height in calculation
		let height: CGFloat = 1000
		let size = CGSize(width: 1000, height: height)
		let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
		let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular)]
		
		return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
	}
	
	
	//there is only a single section
	 func numberOfSections(in collectionView: UICollectionView) -> Int {
		
		
		return 1
	}
	
	//Returns a number of cells = to the total number of Causes * 5 fields per Cause if there has been no userDataObject defined yet
	//Once it has been defined, the numRows var is set to the number of causes that the user has supported
	//and creates that number * 5 cells for the grid
	
	 func collectionView(_ collectionView: UICollectionView,
	                             numberOfItemsInSection section: Int) -> Int {
		guard (self.numRows > 0) else {
			 return 0
		}
		if (self.numRows >= 1){
	
		print("Number of Items in Section called, causes: \(self.numRows * 5)")
		return  (self.numRows * 5)
		} else {
	
			return 5;  //return a single row if there is an error in calculating number of rows
		}
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CGSize(width: personalCauses.frame.width, height: 50)
	}
	
		func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
			
			switch kind{
			case UICollectionElementKindSectionHeader:
			let causeHeaderTitle = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! ColumnHeaderReusableView
			causeHeaderTitle.frame = CGRect(x: 0, y: 0, width: personalCauses.frame.width, height: 50)
			
		
			
		
			causeHeaderTitle.layer.borderColor = UIColor.black.cgColor
			return causeHeaderTitle
			
			
			default: fatalError("Unexpected Sup View type")
			}
	}


		
	// Function that determines what type of cell each cell actually is
	//After the cause table has been reloaded, the user data object exists
	//and the number of table rows (and total number of cells has been determined)
	//and from the numberofitemsInSection function, we know it will always be a multiple of 5

	
	
	 func collectionView(_ collectionView: UICollectionView,
	                             cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		//var currentCause: CauseModel
		var currentData: causeDataObject
		//set a boolean flag to signal when data has been downloaded
		if (indexPath.item % 5 == 0){
			if (self.causeFlag && self.downloadedCauses.count > 0){
				currentData = self.downloadedCauses[ (indexPath.item / 5) ]
			}
			else {
				currentData = causeDataObject()
			}
		let CauseCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCausesID, for: indexPath) as!typicalViewCell
		CauseCell.textLabel?.text  = currentData.title
		
			
		CauseCell.frame = CGRect(x: CauseCell.frame.origin.x, y: CauseCell.frame.origin.y, width: personalCauses.frame.width/3, height: 44)
		
			CauseCell.layer.borderWidth = 1
			CauseCell.layer.borderColor = UIColor.black.cgColor
			return CauseCell
	
		}
		else if (indexPath.item % 5 == 1){
			if (self.causeFlag && self.downloadedCauses.count > 0){
				currentData = self.downloadedCauses[ Int(indexPath.item / 5) ]
			}
			else {
				currentData = causeDataObject()
			}
			 let GoalCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseGoalID,
			                                                    for: indexPath) as! GoalCellCollectionViewCell
			GoalCell.textLabel?.text  =  String(format: "%.2f",(currentData.goal)!)
			GoalCell.frame = CGRect(x: personalCauses.frame.width/3 - 1, y: GoalCell.frame.origin.y, width: personalCauses.frame.width/6, height: 44)
	
			GoalCell.layer.borderWidth = 1
			GoalCell.layer.borderColor = UIColor.black.cgColor
			return GoalCell
		
		}
			else if (indexPath.item % 5 == 2){
			if (self.causeFlag && self.downloadedCauses.count > 0){
				currentData = self.downloadedCauses[ Int(indexPath.item / 5) ]
			}
			else {
				currentData	= causeDataObject()
			}
			let RaisedCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseRaisedID,
			                                                    for: indexPath) as! RaisedViewCell
			RaisedCell.textLabel.text  = String(format: "%.2f", (currentData.raised)!)
			//	displayPercent.text = String(format: "%.2f", percent) + "%"
			RaisedCell.frame = CGRect(x: ((personalCauses.frame.width/2) - 2), y: RaisedCell.frame.origin.y, width: personalCauses.frame.width/6, height: 44)
			
			RaisedCell.layer.borderWidth = 1
			RaisedCell.layer.borderColor = UIColor.black.cgColor
			return RaisedCell
		}
		else if (indexPath.item % 5 == 3){
			if (self.causeFlag && self.downloadedCauses.count > 0){
				currentData = self.downloadedCauses[ Int(indexPath.item / 5) ]
			}
			else {
				currentData = causeDataObject()
			}
			let DaysCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseDaysID,
			                                                    for: indexPath) as! DaysViewCell
			print(currentData)
			let dropDead = calculateRemainingDaysUntil(deadLine: currentData.deadLine!)
			
			if  let value = dropDead["Days"]{
				if value != nil{
					DaysCell.textLabel?.text = "\(Int(value!)) d"
				}
				else{
					DaysCell.textLabel?.text = "Closed"
				}
			}
			else if let value = dropDead["Hours"]{
				DaysCell.textLabel?.text = "\(Int(value!)) h"

			}
			
			DaysCell.frame = CGRect(x: ((personalCauses.frame.width/6) *  4 - 3), y: DaysCell.frame.origin.y, width: personalCauses.frame.width/6, height: 44)
			
			// Configure the cell
			//cell = DaysCell
			DaysCell.layer.borderWidth = 1
			DaysCell.layer.borderColor = UIColor.black.cgColor
			return DaysCell
		}
		else /*if (indexPath.item % 5 == 4)*/{
			if (self.causeFlag && self.downloadedCauses.count > 0){
				currentData = self.downloadedCauses[ Int(indexPath.item / 5) ]
			}
			else {
				currentData	= causeDataObject()
			}
			let SupportCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseSupportID,
			                                                    for: indexPath) as! SupportViewCell
		
			SupportCell.textLabel?.text  = String(format: "%.2f", (currentData.support)!)
			SupportCell.frame = CGRect(x:( (personalCauses.frame.width/6) *  5 - 4), y: SupportCell.frame.origin.y, width: personalCauses.frame.width/6 + 3, height: 44)
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
	/*  Addin
			 self.loadAlert =  UIAlertController(title: "Loading", message: "Loading Your Profile...", preferredStyle: .alert)
			self.loadAlert.view.tintColor = myAdjGreen
			let actIndSize = personalCauses.frame.size
			let actIndFrame = CGRect(x: self.userName.frame.origin.x, y: self.userName.frame.origin.y, width: actIndSize.width, height: actIndSize.height)
			
			
			let loadIndicator = UIActivityIndicatorView(frame: actIndFrame)
			loadIndicator.hidesWhenStopped = true
			loadIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
			loadIndicator.startAnimating()
			loadAlert.view.addSubview(loadIndicator)
			if (!self.loadAlert.isBeingPresented){
			present(self.loadAlert, animated: true, completion: nil)
			}
			else{
				self.loadAlert.dismiss(animated: false, completion: nil)
			}
		*/
		
		//----For Debugging purposes
		if let currentUser = Auth.auth().currentUser { //if there is a current user
			self.curUser = currentUser //set the local page variable curUser to the currentUser
			var receivedData: [String: Any]?
			
			DjangoManager.getUserProfileDataBy(ID: (self.curUser?.displayName)!, completion: { (data, response, error) in
			DispatchQueue.main.async() {
				guard let data = data else{
					print("Some Error Occurred during download")
					return
				}
				do{
					receivedData =  try? JSONSerialization.jsonObject(with: data) as! [String : Any]
					print(receivedData!)
				self.currentUserProfile = try? profileDataObject(json: receivedData!)
				} catch let error as SerializationErrors{
					print("De-Serialization Error")
					print(error.localizedDescription)
				}
				self.numRows = self.currentUserProfile?.causeCount! ?? 0
				self.TotalCauses.text = String(format: "%4d",(self.currentUserProfile?.causeCount)!)
				self.totalDonated.text = String(format: "$%.2f", (self.currentUserProfile?.totalDonated)!)
				self.swipeAmt.text =  String(format: "$%.2f", (self.currentUserProfile?.swipeDonation!)!)
				let feedTab = self.tabBarController?.viewControllers?[1] as! FirstViewController
				feedTab.SwipeAMT = (self.currentUserProfile?.swipeDonation)!
				self.Remaining.text = String(format: "$%.2f", (self.currentUserProfile?.balance!)!)
				for position in 0..<(self.numRows * 5){
					if (position % 5  == 0){
						self.testUserData.append("Cause")
					}else if (position % 5 == 1){
						self.testUserData.append("Goal")
					}else if (position % 5 == 2){
						self.testUserData.append("Raised")
					}else if (position % 5 == 3){
						self.testUserData.append("Days")
					}else {
						self.testUserData.append("Support")
					}
				}//var currentDownloads: [causeDataObject]
				DjangoManager.getAllCausesFor(user: self.currentUserProfile!, completionHandler: { currentDownloads in
						self.downloadedCauses = currentDownloads
						self.causeFlag = true
						self.personalCauses.reloadData()
				})
				}
			}
			);
			
			self.userName.text = self.curUser?.displayName
		}else{
			//eventually we can create a "guest" user who will view something other than personal page when not logged in
			//For now if no current user, we shouldn't be able to view the page so error
			self.userName.text = "Error LINE 290"
			print ("ERROR Line 291")
		}
		//----
		
		//Completion handler that is used in the loadCurrentUserData Function
		//The following code does not run until the data has come back from the asynchronous Firebase Call
		if let existingUD = self.curUser{
		UserDataObj.loadCurrentUserData {
			
			(userCurrent) in
			self.curUserData = userCurrent	//store the current user in a class variable so there is only one user
		
			 //Set the number of rows to the number of causes
		//	self.userName.text = self.curUserData.displayName!

			
			//Now there is a user data object and we know the number of causes so we can create the UserDataArray of Labels for the cell types in a regular pattern as described previously
	/*		for position in 0..<(userCurrent.causeCount! * 5){
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
					self.testUserData.append("Support")
				}
			}*/
			
		//	var currentCause = CauseModel()
			
				/**********
				*For each key in the donated to causes Dict, enter a dispatch group
				*load a cause model with the data
				*pull the mySupport & name from the Donated2CausesDict at the correct location
				*leave the group
				*Use the loaded cause model to fill out the Grid row
				***********/
				//Move this to the testUserData.Append(Cause) line
				//Store these loaded cause models in an array of Cause Models, each corresponding to the row they need to 
				//fill out
				
			
		
			//Print Statements for quick debugging
		//	self.TotalCauses.text = String(format: "%4d",self.curUserData.causeCount!)
			
		//	self.totalDonated.text = String(format: "$%.2f",(self.curUserData.donatedTotal! / 100))
			
		//	self.swipeAmt.text =  String(format: "$%.2f",(self.curUserData.swipeAmt! / 100))
		//	self.Remaining.text =  String(format: "$%.2f",(self.curUserData.balance! / 100))
			
			
			
			
			let causeDict = userCurrent.Donated2CausesDict!
			
			
			let group = DispatchGroup()
			let causeRef  = Database.database().reference().child("causes")
			var simpleDonationDict: Dictionary<String, Float> = Dictionary<String, Float>()
			var mySupport:Float
			for (causeKey, causeSupport) in (causeDict){
				for (subKey) in (causeSupport.keys){
					if (subKey == "donated"){
						mySupport = (causeSupport[subKey]! /  100)
					//	print ("Cause : \(causeKey), My Support: \(mySupport) added to simpleDict")
						simpleDonationDict[causeKey] = mySupport
					}
				}
			}
			
		
		
			self.personalCauses.isHidden = false
			
		
			}
		}
		
	}


	
	
	//Not used
	func isThereAUser(Count: Int) -> Void{
		if (Count > 0){
			self.numRows = Count
			print ("Current User Data Object Created, number of Rows = \(Count)")
		}
		else{
			print("Error line 280, No user data object created")
		}
	}
	//User interaction function.  Called when the user taps the sign out button
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
	@objc(collectionView:didSelectItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("Selected item: \(indexPath.item)")
		if indexPath.item % 5 == 0
		{
			performSegue(withIdentifier: "toCausePageDest", sender: indexPath.item )
		}
	}
	//called by iOS to prepare data for the next View
	//in this case we are primarily concerned with preparing to segue to a specific Cause pageView
	//whose data is set by this method
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		var current: causeDataObject?
		
		if let itemNum = sender as? Int{
			let causePos = itemNum / 5
			current  = downloadedCauses[causePos]
			
		
		if segue.identifier == "toCausePageDest"{
			print("The item generating this segue is a Cause Cell")
			let destVC: CausePageViewViewController  = segue.destination as! CausePageViewViewController
			destVC.currentUserID = (currentUserProfile?.userID)!
			destVC.causeKey = (current!.getID())
			destVC.currentTitle = (current!.getTitle())
			destVC.currentDescription = (current!.getDesc())
			destVC.goal = (current!.getGoal())
			destVC.raised = (current!.getRaised())
			destVC.numBackers = current!.getSupporters()
			var remaining = calculateRemainingDaysUntil(deadLine: current!.deadLine!)
			var labelString: String = String()
			
			if  let value = remaining["Days"]{
				if value != nil{
				labelString = "\(Int(value!)) days"
					
				}
				else{
					labelString  = "Closed"
				}
			}
			else if let value = remaining["Hours"]{
				labelString = "\(Int(value!)) hours"
				
			}
			

			destVC.days2End = labelString
		}
		}
		else{
			
			print("The item generating the segue is NOT a Cause Cell")
			
			return
		}
	}
	override func viewWillDisappear(_ animated: Bool) {
		self.usersCauses.removeAll()
	
	}
	
	///use to figure out number of days and hours until deadline
	func calculateRemainingDaysUntil( deadLine: String) -> [String: Double?]
	{	var label = "Days"
		var time: Double? = nil

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = dateFormatPython
		let current = Date()
		let endDate = dateFormatter.date(from: deadLine)
		
		if (endDate! > current){
			var diffSec: Double =  endDate!.timeIntervalSince(current)
			var diffMin: Double  = diffSec / 60
			var diffHr: Double = diffMin / 60
			var diffDay: Double = diffHr / 24

			var rmHours =  Int(diffHr) % 24
			//var rmMins = Int(diffMin) % 60 in case we want the minutes
			if (diffDay >= 1.0){
				time = diffDay
				return [label : time]
			}
			else{
				label = "Hours"
				time = Double(rmHours)
				return [label : time]
			}
		}
		else{
			return [label: time]
			
		}
	}
	

}
