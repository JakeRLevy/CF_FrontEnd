//
//  SignInViewController.swift
//  CauseFeedProto2
//
//  Created by Jacob Levy on 6/21/17.
//  Copyright © 2017 Jacob Levy. All rights reserved.
//
import FirebaseAuth
import SwiftKeychainWrapper 
import UIKit
//import TPKeyboardAvoiding
class SignInViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {
	
	@IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?

	//@IBOutlet weak var ScrView: TPKeyboardAvoidingScrollView!
	
	@IBOutlet weak var SIScroll: MyScroll!
	@IBOutlet weak var SignInButt: UIButton!
	@IBOutlet weak var orLine: UIImageView!
	@IBOutlet weak var FBph: UIImageView!
	@IBOutlet weak var TWTph: UIImageView!
	@IBOutlet weak var GOOGph: UIImageView!
	
	
	@IBOutlet weak var UNtxtField: UITextField!
	@IBOutlet weak var PWtxtField: UITextField!
	var nameBool = false
	var passBool = false
	var signInError: Bool =  false
	var userName: String = ""
	var passWord: String = ""
	
	@IBAction func SignUpNow(_ sender: UIButton) {
		self.performSegue(withIdentifier: "SI2SU", sender: self)
	}
	
	
	@IBAction func DidTapSI(_ sender: UIButton) {
		
		if UNtxtField.text != nil{
			nameBool = true
			 userName = UNtxtField.text!

		}
		else {
			nameBool = false
		}
		
		if PWtxtField.text != nil{
			passBool = true
			 passWord = PWtxtField.text!
		}
		else
		{
			passBool = false
		}
		
		//have to write a validity check for sign in email 
		//password validity check not necessary because malformed password should not result in login 
		
		
			//code to alert user that they need to fill in the missing field, highlight and bring up keyboard and update bool values
			//submit the username and pw to the server for authentication
		if (passBool && nameBool){
			print("\nGot here")

			if let email = self.UNtxtField.text, let password = self.PWtxtField.text{
				Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
					if let error = error{
						self.signInError = true
						print("\(error.localizedDescription)\n\n")
						return
					}
					self.performSegue(withIdentifier: "SI2Home", sender: nil)

				})
			
			//if server responds with suthentication error, ask user to re-enter information 
			
			}
		}
		else {print("\nCHECKED HERE")
		//remove following line after we add the code
		//	self.performSegue(withIdentifier: "SI2SU", sender: self)
		}
	}


    override func viewDidLoad() {
        super.viewDidLoad()
		/*FBph.image = UIImage(named: "FBPlaceHolder")
		TWTph.image = UIImage(named: "TwitPlaceHolder")
		GOOGph.image = UIImage(named: "googPlaceHolder")
		orLine.image = UIImage(named: "OrLine")*/
		//SignInButt.setBackgroundImage(UIImage(named: "signInButton"), for: .normal)
		self.definesPresentationContext = true
		//UNtxtField.becomeFirstResponder()
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name:Notification.Name.UIKeyboardWillChangeFrame, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:Notification.Name.UIKeyboardWillChangeFrame, object: nil)
	/*	NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)*/

        // Do any additional setup after loading the view.
    }

	@objc func keyboardWillShow(_ notification:NSNotification){
		
		var userInfo = notification.userInfo ?? [:]
		let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		
		let adjustment = (keyboardFrame.height + 20)
		self.SIScroll.contentInset.bottom += adjustment
		self.SIScroll.scrollIndicatorInsets.bottom += adjustment
		//
		//self.automaticallyAdjustsScrollViewInsets
		
	}
	
	@objc func keyboardWillHide(_ notification:NSNotification){
		var userInfo = notification.userInfo ?? [:]
		let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
		let adjustment = -(keyboardFrame.height + 20)
		
		//let adjustment = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
		/*let mySubViews = self.view.subviews
		var rect: CGRect = CGRect.zero
		for view in mySubViews{
		rect = rect.union(view.frame)
		}*/
		self.SIScroll.contentInset.bottom += adjustment
		self.SIScroll.scrollIndicatorInsets.bottom += adjustment
	}
	
	@IBAction func hideKeyboard(_ sender: AnyObject) {
		PWtxtField.endEditing(true)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
		print("SHOULD PERFORM SEGUE?")
		if (self.signInError == true){
			return false
		}
		else{
			return true
		}
	}
	
	
}

