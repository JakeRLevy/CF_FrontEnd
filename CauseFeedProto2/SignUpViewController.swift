//
//  SignUpViewController.swift
//  CauseFeedProto2
//
//  Created by Jacob Levy on 6/24/17.
//  Copyright © 2017 Jacob Levy. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate,UITextViewDelegate, UIGestureRecognizerDelegate {
	weak var signIn: SignInViewController!

	@IBOutlet weak var SignUpButton: UIButton!
	@IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?

	/*Text Field Outlets*/
	@IBOutlet var SuScroll: MyScroll!
	
	@IBOutlet weak var FName: UITextField!
	@IBOutlet weak var Email: UITextField!
	@IBOutlet weak var UName: UITextField!
	@IBOutlet weak var Password: UITextField!
	@IBOutlet weak var ConfirmPass: UITextField!
	
	/*Error Message TextView Outlets*/
	@IBOutlet weak var NameError: UILabel!
	@IBOutlet weak var EmailError: UILabel!
	@IBOutlet weak var UNameError: UILabel!
	@IBOutlet weak var PassError: UILabel!
	@IBOutlet weak var ConfirmError: UILabel!
	//var allFieldsFilled: Bool!
	
	
	/*The List of possible Errors that may occur */
	enum errorList: Error{
		case passTooShort
		case passNotConfirmed
		case passNotMatchRegex
		case emailTooLong
		case emailTooShort
		case emailMatchRegex
		case userNameRegex
		case nameMatch
		case nameTooShort
		case nameTooLong
	}

	/*UIGesture tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBack:)];
	[view addGestureRecognizer:tap];
	[view setUserInteractionEnabled:YES];*/
    override func viewDidLoad() {
        super.viewDidLoad()
	
		//FName.becomeFirstResponder()
		/*NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.textFieldShouldEndEditing(_:)), name: NSNotification.Name(textFieldShouldEndEditing(<#T##textField: UITextField##UITextField#>)), object: <#T##Any?#>)*/
		
		/*SuScroll.addSubview(FName)
		SuScroll.addSubview(Email)
		SuScroll.addSubview(UName)
		SuScroll.addSubview(Password)
		SuScroll.addSubview(ConfirmPass)*/
	//	self.view.addSubview(SuScroll)
		//FName.becomeFirstResponder()
		FName.delegate = self
		Email.delegate = self
		UName.delegate = self
		Password.delegate = self
		ConfirmPass.delegate = self
		NameError.isHidden = true
		PassError.isHidden = true
		UNameError.isHidden = true
		EmailError.isHidden = true
		ConfirmError.isHidden = true
		FName.tag = 1
		Email.tag = 2
		UName.tag = 3
		Password.tag = 4
		ConfirmPass.tag = 5
		//SignUpButton.tag = 6
		
		FName.nextField = Email
		Email.nextField = UName
		UName.nextField = Password
		Password.nextField = ConfirmPass
		ConfirmPass.nextField = nil
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
	

		
		
		
		
		//SuScroll.areAllFields(filled: false)
		
	/*	if (FName.isSelected == true){
		
			NameError.isHidden = false
			self.view.addSubview(NameError)
		
		}*/
	}
	
	    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
	}
	//Valid usernames may have letters, numbers and symbols _-&$@# 5 or more times
	@IBAction func hideKeyboard(_ sender: AnyObject) {
	FName.endEditing(true)
	}
	@objc func keyboardWillShow(_ notification:NSNotification){
		
		var userInfo = notification.userInfo ?? [:]
		let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		
		let adjustment = (keyboardFrame.height + 20)
		self.SuScroll.contentInset.bottom += adjustment
		self.SuScroll.scrollIndicatorInsets.bottom += adjustment
	//	self.SuScroll.automaticallyAdjustsScrollViewInsets

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
		self.SuScroll.contentInset.bottom += adjustment
		self.SuScroll.scrollIndicatorInsets.bottom += adjustment
	}
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		hideKeyboard(textField)
		textField.nextField?.becomeFirstResponder()
		if (textField.nextField == nil){
			print("NEXTFIELD ERROR")
			textField.resignFirstResponder()
		}
		print("\(String(describing: textField.accessibilityIdentifier)) is no longer First Responder")
		return true
	}

	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		//textField.becomeFirstResponder()
		print ("\(String(describing: textField.accessibilityIdentifier)) is the new first responder")
		return true
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for txt in self.view.subviews{
			if NSObject.isKind(of: UITextField.self) && txt.isFirstResponder{
				hideKeyboard(txt)
				//txt.resignFirstResponder()
			}
		}
	}

	deinit {
	NotificationCenter.default.removeObserver(self)
	}
	
	func isValidUserName(_ providedUserName: String) throws ->Bool{
		guard (providedUserName.characters.count >= 5) else{
			print ("Line 161")
			throw errorList.nameTooShort
		}
		guard (providedUserName.characters.count <= 30) else{
			print ("Line 165")
			throw errorList.nameTooLong
		}
		let uNameRegex =  "^[a-zA-Z0-9-_&$@#]{5,30}$"
		let uNameTest = NSPredicate(format: "SELF MATCHES %@",  uNameRegex)
		
		guard (uNameTest.evaluate(with: providedUserName)) else{
			throw errorList.userNameRegex
			
		}
		
		return (true)
		
	}
	/*Validates the First and Last Names to make sure they only use
	Unicode Characters and specific punctuation symbols . ' -  */
	func isNameValid (_ providedName: String) throws -> Bool{
		guard (providedName.characters.count > 1) else {
			throw errorList.nameTooShort
		}
		guard (providedName.characters.count <= 30) else {
			throw errorList.nameTooLong
		}
		let nameRegex =  "^([\\p{L}\\p{M}\\s A-Za-z.'-]{5,60})$"
		let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
		
		guard (nameTest.evaluate(with: providedName)) else{
			throw errorList.nameMatch
		}
		
		return true
	}
	func isEmailValid(_ providedEmail: String) throws ->Bool {
	
		//verify that the email string is no longer than 254 chars (max allowed by SMTP)
		//saves process time
		guard (providedEmail.characters.count >= 8)else{
			throw errorList.emailTooShort
		}
		guard (providedEmail.characters.count <= 254) else{
			throw errorList.emailTooLong
			//addresses can't be greater than 254 in length
		}
		
		//let range = NSMakeRange(0, providedEmail.characters.count)
		//regular expression that should match >=99% of emails adapted from:http://www.regular-expressions.info/email.html
		let emailRegex = "^[-a-zA-Z0-9._%+']{1,64}@([-.a-zA-Z0-9]{1,63}\\.){1,125}[a-zA-Z]{2,63}$"
			let emailTest =  NSPredicate(format: "SELF MATCHES %@", emailRegex)
		
		guard (emailTest.evaluate(with: providedEmail)) else{
			
			print("Email Doesn't Match REGEX")

			throw errorList.emailMatchRegex
		}
		print("Checked EMAIL")
		
		return (emailTest.evaluate(with: providedEmail))
	}
	/*checks that password string is
	- At least 8 characters in length
	- Has at least 1 special character
	- Has at least 1 alpha character
	- Has at least 1 Cap letter
	- Has at least 1 number */
	func isPasswordValid(_ providedPassword:String) throws -> Bool{
		
		//saves process time
		guard (providedPassword.characters.count >= 8) else {
			print("LINE 241")
			throw errorList.passTooShort
		}
		let passwordRegex =  "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$"
		let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
		let result = passwordTest.evaluate(with: passwordRegex)
		guard(result) else{
			print("LINE 248")
			print("Result: \(result)")
			throw errorList.passNotMatchRegex
		}
		return (passwordTest.evaluate(with: passwordRegex))
	}
	/*Checks passwords to see if they match exactly
	Leading and trailing White space is trimmed off the string for security*/
	func doPasswordsMatch(_ password:String, confirm: String) throws -> Bool{
		
		guard (password.stringTrimFrontandBackWhiteSpace() == confirm.stringTrimFrontandBackWhiteSpace()) else{
			throw errorList.passNotConfirmed
		}
		return (password.stringTrimFrontandBackWhiteSpace() == confirm.stringTrimFrontandBackWhiteSpace())
	}

	
	func showLabel(label: UILabel){
		if (label.isHidden == true){
			label.isHidden = false
		}
		
	}
	func hideLabel(label: UILabel){
		if (label.isHidden == false){
			label.isHidden = true
		}
	}

//need to move this logic to the signup button
func textFieldShouldEndEditing( _ textField:
	UITextField) -> Bool {
	print("SHOULD END EDITING CALLED")

	let currentText = textField.text
	var result = false
	
	let trimmedText = currentText?.stringTrimFrontandBackWhiteSpace()
	
	if (textField.tag == 1){
		do {
			result = try isNameValid(trimmedText!)
			print("Checked FNAME with result: \(result)")

			return result

		} catch errorList.nameTooShort {
			NameError.isHidden = false
			print("Name Too Short")
			self.view.addSubview(NameError)
		} catch errorList.nameMatch {
			NameError.isHidden = false
		} catch errorList.nameTooLong {
			NameError.isHidden = false
		} catch {
			//display an UNKNOWN ERROR alert
			print("ERROR LINE 266")
		}
	}
	else if (textField.tag == 2){
		do{
			print("Checked EMAIL")
			result = try isEmailValid(trimmedText!)
		} catch errorList.emailTooShort{
			EmailError.isHidden = false//Display Error
		} catch errorList.emailTooLong{
			EmailError.isHidden = false//Display Error
		} catch errorList.emailMatchRegex{
			EmailError.isHidden = false
		} catch {
			//display an UNKNOWN ERROR alert
		}
	}
	else if (textField.tag == 3){
		do{
			print("Checked UName")
			result = try isValidUserName(trimmedText!)
		} catch errorList.nameTooShort{
			UNameError.isHidden = false
		} catch errorList.nameTooLong{
			UNameError.isHidden = false
		} catch errorList.userNameRegex {
			UNameError.isHidden = false
		} catch {
			//display unknown error alert
		}
	}
	
	else if (textField.tag == 4){
		do{
			print("Checked Password")
			result = try isPasswordValid(trimmedText!)
		} catch errorList.passTooShort{
			PassError.isHidden = false
		} catch errorList.passNotMatchRegex{
			PassError.isHidden = false
		} catch {
			//UNKNOWN ERROR
		}
	}
	
	else if (textField.tag == 5){
		let original = Password.text?.stringTrimFrontandBackWhiteSpace()
		
		if (original == nil){
			print ("Error LINE 354")
		}
			do{
				result = try doPasswordsMatch(original!, confirm: trimmedText!)
			}
			 catch errorList.passNotConfirmed{
				ConfirmError.isHidden = false
				//self.view.addSubview(ConfirmError)
				//UNKNOWN ERROR
			}	catch{
				
		}
		}
	
		return result
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		if (textField.tag == 1){
			NameError.isHidden = true
		}
		if (textField.tag == 2){
			EmailError.isHidden = true
		}
		if (textField.tag == 3){
			UNameError.isHidden = true
		}
		if (textField.tag == 4) {
			PassError.isHidden = true
		}
	
		if (textField.tag == 5){
			ConfirmError.isHidden = true
		}
		
	}
	
	
	@IBAction func DidPressSignUp(_ sender: UIButton) {
	/*	let trimmedFname = FName.text!.stringTrimFrontandBackWhiteSpace()
		var result  =  true
		var nameResult: Bool
		do {
			nameResult = try isNameValid(trimmedFname)
			print ("NAME CHECKING")
		} catch errorList.nameTooShort{
			NameError.isHidden = false
			nameResult = false
		} catch errorList.nameTooLong {
			NameError.isHidden = false
			nameResult = false
		} catch {
			//display an UNKNOWN ERROR alert
			nameResult = false
		}
	
		if (nameResult == false){
			result = false
		}
		
		if (result == true){
			self.performSegue(withIdentifier: "SU2First", sender: self)

		
		
		
		}*/
		
	}
	
}


/*TrimFrontandBackWhiteSpace
Purpose: Extends the string class with a function that uses regexes to trim only the leading and trailing whitespace of a string.  Primarily used to prepare user submitted strings for analysis.
Because
Adapted from code found at https://www.raywenderlich.com/86205/nsregularexpression-swift-tutorial

Author: Jake Levy */
/*extension String{
	func stringTrimFrontandBackWhiteSpace()-> String{
		let frontBackWspace = "(?:^\\s+)|(?:\\s+$)"
		let testRegEx =  try? NSRegularExpression(pattern: frontBackWspace, options: .caseInsensitive)
		if (testRegEx == nil){
			print("error!")
			return self
		}

		let range = NSMakeRange(0, self.characters.count)
		let trimmedString = testRegEx?.stringByReplacingMatches(in: self, options: .reportProgress, range: range, withTemplate: "")
		return trimmedString!

	}

}
//Taken from https://stackoverflow.com/questions/27028617/using-next-as-a-return-key
	private var kAssociationKeyNextField: UInt8 = 0
extension UITextField {
	@IBOutlet var nextField: UITextField? {
		get {
			return objc_getAssociatedObject(self, &kAssociationKeyNextField) as? UITextField
		}
		set(newField) {
			objc_setAssociatedObject(self, &kAssociationKeyNextField, newField, .OBJC_ASSOCIATION_RETAIN)
		}
	}
}*/
