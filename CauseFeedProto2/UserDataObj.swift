//
//  UserDataObj.swift
//contains Models for UserData and CauseData
//  CauseFeedProto2
//
//  Created by Jacob Levy on 8/30/17.
//  Copyright © 2017 Jacob Levy. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class UserDataObj : NSObject, NSCopying{
	//init method not req'd because all values are optional or if containers, initialized to empty.
	var displayName:String?
	
	 var userID:String?
	 var balance: Float?
	 var causeCount: Int?
	 var Donated2CausesDict: Dictionary? = [String : [String : Float]]()
	 var donatedTotal: Float?
	 var swipeAmt: Float?
	 var info: Dictionary? = [String : [String : String]]()
	
	required override init(){
		super.init()
	}
	
	init(displayName: String, userID: String, balance: Float, causeCount: Int, donatedTotal: Float, swipeAmt: Float){
		self.displayName = displayName
		self.userID = userID
		self.balance = balance
		self.causeCount = causeCount
		self.donatedTotal = donatedTotal
		self.swipeAmt = swipeAmt
		
	}
	
	override var description: String{
		return ("User Name: \(displayName!)  User ID: \(userID!) Balance: $\(balance!/100) Typical Swipe Donation: $\(swipeAmt!/100) Total Amount Donated: $\(donatedTotal!/100)")
	}
/*
	class func loadCurrentCauseData( simpleDonationDict: Dictionary<String, Float>, completion: @escaping (_ causeData: [CauseModel])-> () ) {
		var currentCause: CauseModel
		var causeArray: [CauseModel] = [CauseModel]()
		let group = DispatchGroup()
		let causeRef  = Database.database().reference().child("causes")
		for (causeKey, mySupport) in simpleDonationDict {
			print( "Cause: \(causeKey), My Support: \(mySupport)")
		}
		var counter: Int = 0
		
		for (causeKey, mySupport) in simpleDonationDict {
			print("Fetching Cause Data for SimpleDict Cause: \(causeKey), With My Support: \(mySupport)")
			
			group.enter()
			print("Getting \(causeKey)")
			self.downloadSingleCause(causeKey: causeKey, causeSupport: mySupport, completion: { (thisCause) in
				if (thisCause != nil){
					print ("\(thisCause.getName()) has been downloaded" )
				}

			})
			
			//print("Current Cause: \(currentCause.getName())")
			
				
					//currentCause.setCauseDataFromSnapShot(value: value)
			
		}
		
		group.notify(queue: .main) {
			print("Callbacks Completed")
			for (cause) in (causeArray){
				print("Loading...")
				print("\(cause.getName()) my Support: \(cause.getMySup()) Goal: \(cause.getGoal())")
			}
			completion(causeArray)
			//completion(currentCause)
		}
		//return causeArray

	}//Continue from here.....
	
	*/
	/**This function sets the local User Data Object*/
	class func loadCurrentUserData(  completion: @escaping (_ userData: UserDataObj) -> ()) {
		let current : User = Auth.auth().currentUser!
		let currentRef = Database.database().reference().child("users").child((current.displayName)!)
		var currentData = UserDataObj()
		
	//	currentRef.child("users").child((self.curUser.displayName)!).observe(.value, with: { (snapshot) in
			
		currentRef.observeSingleEvent(of: .value, with: { (snapshot) in
			
			let value = snapshot.value as? NSDictionary
			currentData.setUserDataFromSnapShot(value: value)
			
			//self.curUserData.displayName = (self.curUser.displayName)!
			//self.userName.text = self.curUserData.displayName
			
			//self.userName.text
			if let numCauses = currentData.causeCount{
				//self.TotalCauses.text = "\(numCauses)"
				print("Current User # of Causes: \(numCauses)")
			}
			else{
				//self.TotalCauses.text = "Error Line 73"
				print("ERROR LINE 63")
			}
			
			if let totalDonations = currentData.donatedTotal{
				//self.totalDonated.text = "\(totalDonations)"
				print("Current User Total Donations: \(totalDonations)")

			}
			else{
				//self.totalDonated.text = "ERROR Line 80"
				print("Current User Total Donations: Error Line 80")

			}
			
			
			if let fundAmt = currentData.swipeAmt{
				//self.swipeAmt.text = "\(fundAmt)"
				print("Current User Donation: \(fundAmt)")

			}
			else{
				//self.swipeAmt.text = "Error Line 88"
				print("Current User Total Donations: Error line 85")

			}
			
			
			if let balance = currentData.balance{
				//self.Remaining.text = "\(balance)"
				print("Current User Balance: \(balance)")

			}else{
				//self.swipeAmt.text = "Error Line 95"
				print ("Error Line 96")
			}
			
			//print ("LINE 309")
			//print("Number of Causes: \(self.curUserData.causeCount!)")
			
			completion(currentData)
			
			/*DispatchQueue.main.async{
				
				self.personalCauses.reloadData()
			}*/
		})
	
	}

	
	
	//class func

	
	func setUserDataFromSnapShot(value: NSDictionary?){
		let causes = value?["cause-count"] as? Float ?? -1.0
		causeCount = Int (causes)
		balance = value?["balance"] as? Float ?? -10.0
		userID = value?["uid"] as? String ?? "Error.  Contact Help"
		
		swipeAmt = value?["funding-amt"] as? Float ?? -1.0
		
		info = value?["info"] as? Dictionary<String, Dictionary<String, String>> ??  ["name" : ["Missing":"Error.  Contact Help"]]
		
		donatedTotal = value?["donated-amt"] as? Float ?? -11.11
		
		Donated2CausesDict = value?["causes"] as? Dictionary<String, Dictionary<String, Float>> ?? ["causeName" : ["Missing" : -1234567.89] ]
	
	}
	func copy(with zone: NSZone? = nil) -> Any {
		let theCopy = type(of: self).init()
		
		
		theCopy.displayName = self.displayName
		theCopy.userID = self.userID
		theCopy.balance = self.balance
		theCopy.causeCount = self.causeCount
		theCopy.Donated2CausesDict = self.Donated2CausesDict
		theCopy.donatedTotal = self.donatedTotal
		theCopy.swipeAmt = self.swipeAmt
		theCopy.info = self.info
		
		return theCopy
	}
	
	
}

class CauseModel{
	private var name: String
	private var description: String?
	private var Goal: Float
	private var Raised: Float
	private var Days: Int
	private var Support: Float
	private var Title: String
	
	init(name: String, description: String?, Goal: Float, Raised: Float, Days: Int, Support: Float) {
		self.name = name
		self.description = (description != nil) ? description : ""
		self.Goal = Goal
		self.Raised = Raised
		self.Days = Days
		self.Support = Support
		self.Title = "No Title Yet"
	}
	init(){
		self.name = "UnNamed"
		self.description = "Missing Description..."
		self.Goal = 0
		self.Raised = 0
		self.Days = 10000000
		self.Support = 0
		self.Title = "No Title Yet"
	}
	
	 func setSupport( newSupport: Float){
		self.Support = newSupport
	}
	func getName() -> String {
		return self.name
	}
	func getGoal() -> Float{
		return self.Goal
	}
	func getRaised() -> Float{
		return self.Raised
	}
	func getMySup() -> Float{
		return self.Support
	}
	func getTitle()->String{
		return self.Title
	}
	class func downloadSingleCause(causeKey: String, causeSupport: Float, completion: @escaping (_ singleCauseData: CauseModel) -> ()){
		let causeRef  = Database.database().reference().child("causes").child(causeKey)
		var currentCause: CauseModel = CauseModel()
		
		causeRef.observeSingleEvent(of: .value, with: { (snapshot) in
			let value = snapshot.value as? NSDictionary
			currentCause.setCauseDataFromSnapShot(indSupport: causeSupport, name: causeKey, value: value)
			completion(currentCause)

		})
		
	}
	func setCauseDataFromSnapShot(indSupport: Float, name: String, value: NSDictionary?){
		self.name = name
		self.Support = indSupport
		
		let calendar = Calendar.current
		var deadStr: Date
		var now: Date = Date()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MM-dd-yyyy"
		self.description = (value?["description"] as? String ?? "Missing Description")!
		self.Goal = value?["goal"] as? Float ?? -1000.0
		self.Title = value?["title"] as? String ?? "No Title"
		print("Goal: \(self.Goal)")
		print ("Deadline : \(value?["deadline"] as? String)")
		
		
		
		
		
		self.Raised = value?["raised"] as? Float ?? 0000
		
	}
}
