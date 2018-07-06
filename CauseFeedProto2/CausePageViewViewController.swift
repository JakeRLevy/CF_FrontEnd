//
//  CausePageViewViewController.swift
//  CauseFeedProto2
//
//  Created by Jacob Levy on 10/18/17.
//  Copyright © 2017 Jacob Levy. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class CausePageViewViewController: UIViewController, UIAlertViewDelegate {
	//DONATION LINK
	var donationLink: String = "https://beefsauce.herokuapp.com/donations/"
	
	@IBOutlet weak var ContributorPic: UIImageView!
	@IBOutlet weak var ContributorName: UILabel!
	@IBOutlet weak var ContributorLoc: UILabel!
	@IBOutlet weak var CauseOrg: UILabel!
	@IBOutlet weak var CauseLoc: UILabel!
	@IBOutlet weak var CauseIMG: UIImageView!
	@IBOutlet weak var displayTitle: UILabel!
	//need to add horizontal spacer views on the autolayout
	//width of spacers proportional to (superview width - total width of all labels (have to make this fixed/hardcoded I guess?)/5
	@IBOutlet weak var displayPercent: UILabel!
	@IBOutlet weak var DisplayRaised: UILabel!
	@IBOutlet weak var displayBackers: UILabel!
	@IBOutlet weak var displayDays: UILabel!
	@IBOutlet weak var displayProgress: UIProgressView!
	@IBOutlet weak var displayDescr: UILabel!
	@IBOutlet weak var GoalLabel: UILabel!
	@IBOutlet weak var donateMoreButton: UIButton!
	//weak var currentCause: causeDataObject?
	
	@IBAction func willDonateMore(_ sender: Any) {
		
		var isValidDonation: Bool = false
		let donateOptions = UIAlertController(title: "New Donation",
		                                      message: "Please enter amount to Donate:",
											preferredStyle: UIAlertControllerStyle.alert)

		donateOptions.addTextField { (mainField) in
			mainField.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
			mainField.placeholder = "Valid $ amounts only"
			mainField.becomeFirstResponder()
		//	mainField.delegate = self
		}
		donateOptions.addAction(UIAlertAction(title: "submit", style: UIAlertActionStyle.default, handler: { (alert) -> Void in
			let newDonationAmount = donateOptions.textFields![0] as UITextField
			repeat {
			if (self.isValidDecimal(donation: newDonationAmount.text!)){
				//Hook for posting the donation amount to the link
				isValidDonation = true
				print(newDonationAmount.text!)
				//var submitDonation = F
				DjangoManager.makeADonation(forUser: self.currentUserID, andCause: self.causeKey, withAmt: Float(newDonationAmount.text!)!, completionHandler: { error, response in
					if let error = error {
						print(error.localizedDescription )
						return
					}
					if error == nil {
					self.raised = Double(newDonationAmount.text!)! + self.raised
					
					
					self.percent = self.raised/self.goal * 100
					DispatchQueue.main.async {
						self.DisplayRaised.text = "$" + String(format: "%.2f", self.raised)
						self.displayPercent.text = String(format: "%.2f", self.percent) + "%"
					}
					self.upDateProgress()
					}
				})
				
			}
			else {
				//newDonationAmount.text = "Enter Valid Number Only"
				//never actually runs since the button is disabled until a valid decimal is entered
				donateOptions.textFields?[0].placeholder = "Enter Valid Number Only"
				print("BAD AMOUNT: ", newDonationAmount.text!)
				
			}
			} while (!isValidDonation)
		}))
		//Create the cancel action to dismiss the alert
		let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
			(action : UIAlertAction!) -> Void in
			self.dismiss(animated: true, completion: nil)
			
		})
		//add the action
		donateOptions.addAction(cancelAction)
		//disable submit initially
		donateOptions.actions[0].isEnabled = false
		//present the alert
			self.present(donateOptions, animated: true, completion: nil)
	}
	func textChanged(_ sender: Any){
		let alertTF = sender as! UITextField
		var resp: UIResponder! = alertTF
		while !(resp is UIAlertController){resp = resp.next}
		let theAlert = resp as! UIAlertController
		theAlert.actions[0].isEnabled = (self.isValidDecimal(donation: alertTF.text!))
		
	}
	
	let storage = Storage.storage()
	var currentUserID: String = ""
	var percent: Double = Double()
	var causeKey: Int = Int()
	var currentTitle: String = ""
	var currentDescription: String = ""
	var goal: Double = Double()
	var raised: Double = Double()
	var days2End: String = String()
	var numBackers: Int = Int()
	
	override func viewWillAppear(_ animated: Bool) {
		
		//Image store References
		donateMoreButton.titleLabel?.minimumScaleFactor = 0.5
		donateMoreButton.titleLabel?.adjustsFontSizeToFitWidth = true
		donateMoreButton.titleLabel?.numberOfLines = 0
		donateMoreButton.titleLabel?.lineBreakMode = .byWordWrapping
		
		let storageRef = storage.reference()
		let path: String = "img/causes/" + "\(causeKey)" + ".jpg"
		let imgRef = storage.reference(withPath: path)
		
		displayDescr.lineBreakMode = .byWordWrapping
		displayDescr.numberOfLines = 0
		
		displayTitle.text = currentTitle
		displayDescr.text = currentDescription

		displayDescr.frame = self.estimatedFrameHeight(text: currentDescription, width: self.displayDescr.frame.width)

		displayDays.text = days2End
		displayBackers.text = String(numBackers)
		DisplayRaised.text = "$" + String(format: "%.2f", raised)
		percent  = raised/goal * 100
		displayPercent.text = String(format: "%.2f", percent) + "%"
		
		GoalLabel.text = "of " + String(format: "%.2f", goal) + " $"
		imgRef.getData(maxSize: 2 * 1024 * 1024) { (data, error) in
			if let error = error{
				print("Sorry an error occurred downloading the img at " + path)
				print ("\(error.localizedDescription)")
			}
			else {
				self.CauseIMG.image = UIImage(data: data!)
			}
		}
		upDateProgress()
	}
    override func viewDidLoad() {
        super.viewDidLoad()
		print("\(self.causeKey)")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	//Checks to make sure text is a valid decimal for price (aka whole number
	func isValidDecimal(donation: String) ->Bool {
		guard donation.isEmpty == false else{
			return false
		}
		
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		
		if let _ = formatter.number(from: donation){
			let numComponents = donation.components(separatedBy: ".")
			let fractDigits = (numComponents.count == 2) ? numComponents.last ?? "" : ""
			let convert = Double(donation)
			var isNotZero = false
			if (convert != nil && convert! > 0){
				print ("Value: ", convert!)
				isNotZero = true
			}
			
			return (fractDigits.characters.count <= 2 && isNotZero )
		}
		
		return false
		
	}
	
	private func upDateProgress(){
		let upDatedProgress: Double = ((self.raised / (self.goal)))
		
		DispatchQueue.main.async{
			self.displayProgress.progress = Float(upDatedProgress)
		}
	}
	private func estimatedFrameHeight(text:String, width: CGFloat) -> CGRect{
		//we make the height arbitrarily large so we don't undershoot height in calculation
		let height: CGFloat = 10000
		
		let size = CGSize(width: width, height: height)
		let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
		let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 10, weight: UIFontWeightBold)]
		
		return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
	}
}
