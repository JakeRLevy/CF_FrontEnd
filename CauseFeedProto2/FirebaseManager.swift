 //
//  FirebaseManage.swift
//  
//
//  Created by Jacob Levy on 10/25/17.
//
//

import Foundation
import FirebaseDatabase
import Firebase
fileprivate let ref = Database.database().reference()
class FirebaseManager {
	
	
	class func downloadSingleCause(causeKey: String, causeSupport: Float, completion: @escaping (_ singleCauseData: CauseModel) -> ()){
		let causeRef  = ref.child("causes").child(causeKey)
		var currentCause: CauseModel = CauseModel()
		
		causeRef.observeSingleEvent(of: .value, with: { (snapshot) in
			let value = snapshot.value as? NSDictionary
			currentCause.setCauseDataFromSnapShot(indSupport: causeSupport, name: causeKey, value: value)
			completion(currentCause)
			
		})
		
	}
	
	class func initialSwipeQuery(completion: @escaping(_ causeArray: [CauseModel]) -> ()){
		var myArr = [CauseModel]()
		let initialQuerySnap = ref.child("causes").queryLimited(toFirst: 5).queryOrderedByKey()
		
		//initialQuerySnap.observe(<#T##eventType: DataEventType##DataEventType#>, with: <#T##(DataSnapshot) -> Void#>)
		initialQuerySnap.observe( DataEventType.value, with: { (initialSnap) in
		//	let value  = initialSnap.value as? [String: Any] ?? [:]
			
			for child in initialSnap.children.allObjects as! [DataSnapshot] {
				var currentCause = CauseModel()
				print("key : \(child.key)  value: \(String(describing: child.value)) ")
				currentCause.setCauseDataFromSnapShot(name: child.key, value: child.value as? NSDictionary)
				myArr.append(currentCause)
				

			}
		
			completion(myArr)
			
		})
		
			
		}
		
	}
	

