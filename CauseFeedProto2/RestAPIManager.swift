//
//  RestAPIManager.swift
//  CauseFeedProto2
//
//  Created by Jacob Levy on 10/6/17.
//  Copyright © 2017 Jacob Levy. All rights reserved.
//

import Foundation

class RestAPIManager: NSObject {
	static let sharedManager = RestAPIManager()
	
	static let postURL = URL(string:"https://us-central1-causefeed-d6e5c.cloudfunctions.net/newUser")!
	
	class func makeUserPostRequest(email: String?, password: String?, FullName: String?, userName: String?, with Completion: @escaping (_ data: Data?, _ response: URLResponse ,_ error: Error?) -> ()){
		
		let jsonBody: [String: String]
	
		jsonBody = ["email": email!,
		            "password": password!,
		            "name": FullName!,
		            "username": userName!]
		
		
			let session = URLSession.shared
			
			var request = URLRequest(url: self.postURL)
			request.httpMethod = "POST"
			//request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
			do{
			request.httpBody = try JSONSerialization.data(withJSONObject: jsonBody, options: .prettyPrinted)
			} catch let error{
				print (error.localizedDescription)
		}
		
		
			//From my research on posts this is
			request.addValue("application/json", forHTTPHeaderField: "Content-Type")
			request.addValue("application/json", forHTTPHeaderField: "Accept")
		
		
			let task = session.dataTask(with: request ){data, response, error in
				Completion(data!, response!, error)
		}
	
	
		task.resume()
		
	}
	
}
