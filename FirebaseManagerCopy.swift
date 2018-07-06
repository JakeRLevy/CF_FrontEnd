
//
//  FirebaseManage.swift
//  
//
//  Created by Jacob Levy on 10/25/17.
//
//

import Foundation


class FirebaseManager {
	
	
	class func downloadSingleCause(causeKey: String, causeSupport: Float, completion: @escaping (_ singleCauseData: CauseModel) -> ()){
		let causeRef  = Database.database().reference().child("causes").child(causeKey)
		var currentCause: CauseModel = CauseModel()
		
		causeRef.observeSingleEvent(of: .value, with: { (snapshot) in
			let value = snapshot.value as? NSDictionary
			currentCause.setCauseDataFromSnapShot(indSupport: causeSupport, name: causeKey, value: value)
			completion(currentCause)
			
		})
		
	}
	
}
