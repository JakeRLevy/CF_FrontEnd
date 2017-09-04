//
//  UserDataObj.swift
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
	 var Donated2CausesDict: Dictionary? = [String : Float]()
	 var donatedTotal: Float?
	 var swipeAmt: Float?
	 var info: Dictionary? = [String: String]()
	
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

	
	
	


	func setUserDataFromSnapShot(value: NSDictionary?){
		let causes = value?["cause-count"] as? Float ?? -1.0
		causeCount = Int (causes)
		balance = value?["balance"] as? Float ?? -10.0
		userID = value?["uid"] as? String ?? "Error.  Contact Help"
		
		swipeAmt = value?["funding-amt"] as? Float ?? -1.0
		
		info = value?["info"] as? [String : String] ??  ["name" : "Error.  Contact Help"]
		donatedTotal = value?["donated-amt"] as? Float ?? -11.11
		
		Donated2CausesDict = value?["causes"] as? [String : Float] ?? ["causeName" : -1234567.89]
	
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
