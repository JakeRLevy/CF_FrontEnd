//
//  DjangoManager.swift
//  CauseFeedProto2
//
//  Created by Jacob Levy on 12/19/17.
//  Copyright © 2017 Jacob Levy. All rights reserved.
//

import Foundation
//////////Local data Models

//all Users https://beefsauce.herokuapp.com/profiles/
//all Causes https://beefsauce.herokuapp.com/causes/
fileprivate let profileBaseURL = "https://beefsauce.herokuapp.com/profiles/"
fileprivate let causeBaseURL = "https://beefsauce.herokuapp.com/causes/"
fileprivate let donationBaseURL = "https://beefsauce.herokuapp.com/donations/"
fileprivate let causeFeedURL = "https://beefsauce.herokuapp.com/feeds/"//+"userID/"
fileprivate let skipBaseURL = "https://beefsauce.herokuapp.com/skips/" //POST
let dateFormatPython = "yyyy-MM-dd"

// ind users are link + /String ID
//ind causes are link + /int ID
//Throwable Errors
enum SerializationErrors : Error{
	case missing(String)
	case loading(String)
	case status(String, String, String)
	var message: String{
		switch self{
		case .missing(let attribute):
			return "\(attribute) is missing from the JSON file"
		
		case .loading(let path):
			return "\(path) has some error"
		
		case .status(let path, let response, let statusCode):
			return "Response from \(path) was \(response), STATUS CODE: \(statusCode)"
		default:
			return "Some weird shit happened"
		}
	}
		
}

//Represents the data retrieved from a Cause profile endpoint
/*{
"id": 1,
"title": "cause 1",
"launch_date": "2017-12-21",
"goal": 50000,
"description": "description for cause 1",
"raised": 12456,
"org": 1,
"contact": 1
}*/
class causeDataObject: NSObject{
	var causeID: Int?
	var title: String?
	var launch: String?
	var deadLine: String?
	var goal: Float?
	var desc: String?
	var raised: Float?
	var support: Float?
	var org : Int?
	var contact: String?
	var numOfSupporters: Int?
	
	 required override init(){
		super.init()
		self.causeID = 0
		self.title = "Not yet Initialized"
		self.launch = "2001-01-01"
		self.deadLine = "1999-12-12"
		self.goal = 1000000.11110
		self.desc = "Not yet Initialized"
		self.raised = 0
		self.support = 0
		self.org = nil
		self.contact = nil
		self.numOfSupporters = 0
	}
	public init(json: [String : Any]) throws{
		super.init()
		guard let ID = json["id"] as? Int else{
			throw SerializationErrors.missing("Cause ID")
		//	print("Cause missing ID")
		}
		self.causeID = ID
		guard let causeTitle = json["title"] as? String else {
			throw SerializationErrors.missing("Title")
		}
		self.title = causeTitle
		guard let launchDate = json["launch_date"] as? String else {
			throw SerializationErrors.missing("Launch Date")
		}
		self.launch = launchDate
		guard let endDate = json["deadline"] as? String else {
			throw SerializationErrors.missing("DeadLine Date")
		}
		self.deadLine = endDate
		guard let causeDesc = json["description"] as? String else {
			throw SerializationErrors.missing("Description")
		}
		self.desc = causeDesc

		guard let numBackers = json["total_supporters"] as? Int else{
			throw SerializationErrors.missing("total_Supporters")

		}
		self.numOfSupporters = numBackers
		
		let amtRaised = json["raised"] as? Float ?? 0
		
		self.raised = amtRaised/100.00
		
		guard let goalAmt = json["goal"] as? Float else{
			throw SerializationErrors.missing("Goal")
		}
		
		self.goal = goalAmt/100.00
		self.org = json["org"] as? Int ?? 0
		self.contact = json["contact"] as? String ?? "No Listed Contact"
	}
	
	public func setSupport(mySupport: Float){
		self.support = mySupport
	}
	public func getTitle() -> String {
		return self.title!
	}
	public func getSupporters() -> Int{
		return self.numOfSupporters!
	}
	public func getID() ->  Int {
		return self.causeID!
	}
	public func getDesc() -> String{
		return self.desc!
	}
	public func getGoal() -> Double {
		return Double(self.goal!)
	}
	public func getRaised() -> Double {
		return Double(self.raised!)
	
	}
}
//represents the data retrieved from the user Profile endpoint
//currently creates local donated Dictionary from retrieved cause ID list
//will be updated to retrieve remote donated dictionary once it exists
class profileDataObject:  NSObject{
	var userID: String?
	var userEmail: String?
	var userName: String?
	var balance: Float?
	var causeCount: Int?
	var swipeDonation: Float?
	var donatedToCauses: [String: Float]?
	var totalDonated: Float?

	required override init() {
		super.init()
	}
	
	public init( json: [String: Any] ) throws{
		super.init()
		guard let ID = json["username"] as? String else{
			throw SerializationErrors.missing("User ID")
		}
		self.userID = ID
		guard let email = json["email"] as? String else {
			throw SerializationErrors.missing("Email")
		}
		self.userEmail = email
		guard let balance = json["balance"] as? Float else {
			throw SerializationErrors.missing("Balance")
		}
		self.balance = balance/100
		guard let name = json["first_name"] as? String else {
			throw SerializationErrors.missing("Name")
		}
		self.userName = name
		
		guard let donationLev = json["donation_level"] as? Float else {
			throw SerializationErrors.missing("Donation Level")
		}
		self.swipeDonation = donationLev/100
		
		guard let totalDonation = json["total_donated"] as? Float else{
			throw SerializationErrors.missing("Total Donated")
		}
		self.totalDonated = totalDonation/100
		
		//Will need to remove causeList. Redundancy with donatedToCauses Dictionary
	
		guard (json ["causes"]  as? [Int]) != nil  else {
			throw SerializationErrors.missing("Causes")
		}
		/*self.donatedToCauses = [String : Float]()
		if let userSupportedCauses = json["supported"] as? [Int] {
			print("INTs")
		for cause in userSupportedCauses{
			print("Adding Cause\(String(cause)) ")
			self.donatedToCauses?[String(cause)] = Float(0)
			
		}
		}*/
		
		let userSupportedCauses = json["supported"] as? [[String: Float]] ?? [[String: Float]]()
		print(userSupportedCauses)
		self.donatedToCauses = [String:Float]()
	
		for cause in userSupportedCauses{
			if let causeID = cause["cause"]{
				if let amount = cause["amount"] {
					self.donatedToCauses?[String(Int(causeID))] = amount
				}
			}
		}
		//self.donatedToCauses = userSupportedCauses
		
		guard let howManySupported = json["total_supported"] as? Int else {
			throw SerializationErrors.missing("User Supported Causes")

		}
		
		self.causeCount = howManySupported

		/*
		var localDict = [String: Float]()
		var localNum: String

		for  causeNum in causeList {
			localNum = String(causeNum)
			localDict[localNum] = (totalDonation/Float(causeList.count)).rounded()/100.0 //rounded to nearest cent (.01 $)
		self.donatedToCauses = localDict

		}*/
		
		
		
	}
	public func getCauses()-> [String: Float]{
		return self.donatedToCauses!
	}
}
//class to manage the DJango API Calls
class DjangoManager{
	//Pre: The current logged in User Profile exists within the database
	//Post: The current User's profile has been downloaded
	
	//method to load single user Profile by ID
	public class func getUserProfileDataBy(ID: String, completion: @escaping(_ data: Data?, _ newResponse: URLResponse?,_ newError: Error?)  -> ()) {
		let requestURL = profileBaseURL + ID
		
		let loadedData =  URLSession.shared.dataTask(with: URL(string: requestURL)!) {(data, response, error) in
			guard let data = data, error == nil else {
				print(error!.localizedDescription)
				return completion(nil, nil, error)//return an error
			
			}
			if let response = response as? HTTPURLResponse {
				if response.statusCode != 200 {
					if response.statusCode == 404 {
						let userError = NSError(domain: requestURL,
						                        code: response.statusCode,
						                        userInfo: [NSLocalizedDescriptionKey: "User Doesn't Exist"])
						 completion(nil, response, userError)//return a User Doesn't Exist Error
					}
					else{
						
					let statusError = NSError(domain: requestURL,
					                          code: response.statusCode,
					                          userInfo: [NSLocalizedDescriptionKey: "HTTP status code has unexpected value."])
					completion(nil, response, statusError) //return unexpected HTTP status error
					}
				}
				else{
					//download went smoothly, run the completionHandler
					completion(data, response, nil)
				}
			}
		}
		loadedData.resume()
	}
	
	
	//method to load a single cause profile by ID
	//GET REQUEST
	//Pre: Cause with the given ID exists within the DataBase
	//Post: Correct Cause Data has been downloaded and passed to the Completion Handler
	public class func loadSingleCauseBy(ID: String, completion: @escaping (_ data: [String : Any]?, _ response: URLResponse?, _ error: Error?)->()){
		let requestURL = causeBaseURL + ID
		
		let loadedData = URLSession.shared.dataTask(with: URL(string: requestURL)!) {(data, response, error) in
			guard let data = data, error == nil else {
				print(error!.localizedDescription)
				return completion(nil, nil, error) //remove return statement after you add
				//throw error
			}
			if let response = response as? HTTPURLResponse {
				if response.statusCode != 200 {
					if response.statusCode == 404 {
						let causeError = NSError(domain: requestURL,
						                        code: response.statusCode,
						                        userInfo: [NSLocalizedDescriptionKey: "Cause Doesn't Exist"])
						completion(nil, response, causeError)
					}
					else{
						
						let statusError = NSError(domain: requestURL,
						                          code: response.statusCode,
						                          userInfo: [NSLocalizedDescriptionKey: "HTTP status code has unexpected value."])
						completion(nil, response, statusError)
					}
				}
				else{
					let parsedData = try! JSONSerialization.jsonObject(with: data) as! [String : Any]

					completion(parsedData, response, nil)
				}
			}
			
			
		}
		loadedData.resume()
	}
	//method to load all causes for a given profile object
	//GET REQUEST
	//Pre: user is a valid profileDataObject
	//Post:  returns an array of Causes after having retrieved all the cause objects (Unpaginated at the moment)
	public class func getAllCausesFor(user: profileDataObject, completionHandler: @escaping (_ causeList: [causeDataObject]) -> ()) {
		let group = DispatchGroup()
		var arrCauses = [causeDataObject]()
		var singleCause = causeDataObject()
		
		for(causeKey, mySupport) in user.getCauses(){
			print("Fetching Cause Data for SimpleDict Cause: \(causeKey), With My Support: \(mySupport)")
			group.enter()
			loadSingleCauseBy(ID: causeKey, completion: { (data, response, error) in
				if let data = data {
					print(String(describing: data))
					do{
					
						try singleCause = causeDataObject.init(json: data)
					} catch (let error) {
						print(error)
					}
					singleCause.setSupport(mySupport: mySupport/100)
					arrCauses.append(singleCause)
				} else {
					if let netResp = response as? HTTPURLResponse{
						if netResp.statusCode != 200{
					print("Error from getAllCausesforUser: ", error!.localizedDescription)
					print("Status code", netResp.statusCode)
					}
					}
				}
				group.leave()
			})
		}
		group.notify(queue: .main) { 
			print("Callbacks completed, loaded all User's Causes")
			completionHandler(arrCauses) //pass the filled array of causes back to the completion handler
		}
	}
	
	//	var donationLink: String = "https://beefsauce.herokuapp.com/donations/"
	//Make a Donation Method.  Posts a Donation to the DataBase
/* 
"id": 1,
"user": "test02",
"cause": 9,
"amount": 5
*/
	//do not need to include the id field (auto-generated)
	//Must Include, userName (not legal name)	(Firebase displayName, Django username, pDO: userID)	
	//POST REQUEST
	public class func makeADonation(forUser: String, andCause: Int, withAmt: Float,  completionHandler: @escaping (Error?, HTTPURLResponse)->()){
		let json: [String: Any] = ["user" : forUser,
		                           "cause" : andCause,
		                           "amount" : Int(withAmt * 100)]
		
		let jsonData = try? JSONSerialization.data(withJSONObject: json)
	
		let postURL = URL(string: donationBaseURL)
		var request = URLRequest(url: postURL!)
	
		request.httpMethod = "POST"
		request.httpBody = jsonData
		request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

		let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
			guard let data = data, error == nil else {
				print(error?.localizedDescription ?? "No data")
				return
			}
			let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
			/*if let responseJSON = responseJSON as? [String: Any] {
				print("&&&&&&&")
				print(responseJSON)
				print("&&&&&&&&&&&")
			}*/
			
			if let response = response as? HTTPURLResponse {
				if response.statusCode != 201 {
					if response.statusCode == 404 {
						let causeError = NSError(domain: donationBaseURL,
						                         code: response.statusCode,
						                         userInfo: [NSLocalizedDescriptionKey: "Eror 404 Something's Whack /n Response JSON: " + String(describing: responseJSON) ])
						print(response)
						completionHandler(causeError, response)
					}
					else  if response.statusCode == 400 {
						let causeError = NSError(domain: donationBaseURL,
						                         code: response.statusCode,
						                         userInfo: [NSLocalizedDescriptionKey: "Error 400 from server /n Response JSON: " + String(describing: responseJSON) ])
					

						completionHandler(causeError, response)
					}
					else{
						
						let statusError = NSError(domain: donationBaseURL,
						                          code: response.statusCode,
						                          userInfo: [NSLocalizedDescriptionKey: "HTTP status code has unexpected value. Code: " + String(response.statusCode)])
						completionHandler(statusError, response)
					}
				}
				else{
					completionHandler(nil, response)
				}
		}
		
	}
		task.resume()
}	//left swipe skips a cause
	//https://beefsauce.herokuapp.com/skips/
	public class func skipThis( forUser: String, andCause: Int,  with SkipHandler: @escaping (Error?, HTTPURLResponse) -> () ){
		let json: [String: Any] = ["user" : forUser,
		                           "cause" : andCause]
		
		let jsonData = try? JSONSerialization.data(withJSONObject: json)
		
		let skipURL = URL(string: skipBaseURL)
		var request = URLRequest(url: skipURL!)
		request.httpMethod = "POST"
		request.httpBody = jsonData
		request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
		
		let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
			guard let data = data, error == nil else {
				print(error?.localizedDescription ?? "Error with Skipping")
				return
			}
			let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
			
			if let response = response as? HTTPURLResponse {
				if response.statusCode != 201 {
					if response.statusCode == 404 {
						let causeError = NSError(domain: (skipURL?.absoluteString)!,
						                         code: response.statusCode,
						                         userInfo: [NSLocalizedDescriptionKey: "Eror 404 Something's Whack /n Response JSON: " + String(describing: responseJSON) ])
						print(response)
						SkipHandler(causeError, response)
					}
					else  if response.statusCode == 400 {
						let causeError = NSError(domain: (skipURL?.absoluteString)!,
						                         code: response.statusCode,
						                         userInfo: [NSLocalizedDescriptionKey: "Error 400 from server /n Response JSON: " + String(describing: responseJSON) ])
						
						
						SkipHandler(causeError, response)
					}
					else if response.statusCode == 409{
						let skipError = NSError(domain: (skipURL?.absoluteString)!,
						                        code: response.statusCode,
						                        userInfo: [NSLocalizedDescriptionKey: "Error 409 from Server /n Response JSON: " + String(describing: responseJSON)])
						SkipHandler(skipError, response)
					}
					else{
						
						let statusError = NSError(domain: donationBaseURL,
						                          code: response.statusCode,
						                          userInfo: [NSLocalizedDescriptionKey: "HTTP status code has unexpected value. Code: " + String(response.statusCode)])
						SkipHandler(statusError, response)
					}
				}
				else{
					print("NO ERRORS")
					SkipHandler(nil, response)
				}
			}
			
		}
		task.resume()
	}
	
	
	//fileprivate let causeFeedURL = "https://beefsauce.herokuapp.com/feeds/ + userID/"
	//method to download the current user's initial causefeed and populate the swipe cards with data
	public class func fillCauseFeed(forUser: String, withFeedHandler: @escaping (_ feedList: [causeDataObject]?, _ error: Error?) -> ()){
		var localCauseList = [causeDataObject]()
		let requestURL = causeFeedURL + forUser + "/"
		
		let loadedFeed = URLSession.shared.dataTask(with: URL(string: requestURL)!){(data, response, error) in
			guard let data = data,  error == nil else {
				print("Error Description from fillCauseFeed Method: ")
				print(error!.localizedDescription)
				print()
				print()
				print("Returning Nil CauseFeed")
					
				return	withFeedHandler(nil, error)
				
			}
				
				if let response = response as? HTTPURLResponse{
					if response.statusCode != 200 {
						if response.statusCode == 404 {
							let feedError = NSError(domain: causeFeedURL,
							                        code: response.statusCode,
							                        userInfo: [NSLocalizedDescriptionKey: "Cannot produce Feed! User Does not Exist!"])
							withFeedHandler(nil, feedError)
						}
					
						else if response.statusCode == 400 {
							let requestError = NSError(domain: causeFeedURL,
						                           code: response.statusCode,
						                           userInfo: [NSLocalizedDescriptionKey: "Mal-formed request, cannot produce Feed"])
							withFeedHandler(nil, requestError)
						}
						else{
							let statusError = NSError(domain: requestURL,
						                               code: response.statusCode,
						                               userInfo: [NSLocalizedDescriptionKey: "HTTP status code has unexpected value: " + String(response.statusCode)])
							withFeedHandler(nil, statusError)

							
						}
					}
					else{
						//feedData is a List of Causes.  Causes are basically [String: Any]. So a list of Causes is [[String:Any]]
						let  feedData = try! JSONSerialization.jsonObject(with: data) as! [[String : Any]]
						//for each
						for (cause) in feedData{
							do{
								try? localCauseList.append(causeDataObject.init(json: cause ))
							}
						}
						withFeedHandler(localCauseList, nil)
				}
			
		}
	
	}
		loadedFeed.resume()

}
}
