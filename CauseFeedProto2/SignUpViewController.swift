//
//  SignUpViewController.swift
//  CauseFeedProto2
//
//  Created by Jacob Levy on 6/24/17.
//  Copyright © 2017 Jacob Levy. All rights reserved.
//
import FirebaseAuth
import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate,UITextViewDelegate, UIGestureRecognizerDelegate {
//	weak var signIn: SignInViewController!

	@IBOutlet weak var SignUpButton: UIButton!
	@IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?

	/*Text Field Outlets*/
	@IBOutlet var SuScroll: MyScroll!
	
	@IBOutlet weak var FName: UITextField!
	@IBOutlet weak var Email: UITextField!
	@IBOutlet weak var UName: UITextField!
	@IBOutlet weak var Password: UITextField!
	@IBOutlet weak var ConfirmPass: UITextField!
	var selectedField: UITextField = UITextField()
	
	var signUpRequestSuccessful = false;
	/*Error Message TextView Outlets*/
	@IBOutlet weak var NameError: UILabel!
	@IBOutlet weak var EmailError: UILabel!
	@IBOutlet weak var UNameError: UILabel!
	@IBOutlet weak var PassError: UILabel!
	@IBOutlet weak var ConfirmError: UILabel!
	var message: String = ""
	//flag indicating ALL fields are filled correctly
	var allFieldsFilled: Bool = false
	//flag for checking individual text fields for correctness
	
	var matchCheck = false
	var nameCheck = false
	var emailCheck = false
	var uNameCheck = false
	var PwordCheck = false
	
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
		//NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name:NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)

		
		
		
		
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
		
		let adjustment = (keyboardFrame.height +
			5 )
		
		self.SuScroll.contentInset.bottom += adjustment
		self.SuScroll.scrollIndicatorInsets.bottom += adjustment
	//	self.SuScroll.automaticallyAdjustsScrollViewInsets

	}
	

	@objc func keyboardWillHide(_ notification:NSNotification){
		var userInfo = notification.userInfo ?? [:]
		let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
		let adjustment = -(keyboardFrame.height + 5)

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
func textFieldDidEndEditing( _ textField:
	UITextField)  {
	print("SHOULD END EDITING CALLED")

	let currentText = textField.text
	var result = false
	
	let trimmedText = currentText?.stringTrimFrontandBackWhiteSpace()
	
	if (textField.tag == 1){
		do {
			result = try isNameValid(trimmedText!)
			print("Checked FNAME with result: \(result)")
			if (result){
				self.nameCheck = true
				print("Set namecheck")
			}
			//return result

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
			
			print("Some Error with Name Validation, Result -> \(result)")
		}
	}
	else if (textField.tag == 2){
		do{
			print("Checked EMAIL")
			result = try isEmailValid(trimmedText!)
			
			if (result){
				self.emailCheck = true
				print("Email Check is \(result)")
			}
		} catch errorList.emailTooShort{
			EmailError.isHidden = false//Display Error
		} catch errorList.emailTooLong{
			EmailError.isHidden = false//Display Error
		} catch errorList.emailMatchRegex{
			EmailError.isHidden = false
		} catch {
			//display an UNKNOWN ERROR alert
				print("Some Error with Email Validation, Result -> \(result)")
		}
	}
	else if (textField.tag == 3){
		do{
			print("Checked UName")
			result = try isValidUserName(trimmedText!)
			if (result){
				self.uNameCheck = true
			}
		} catch errorList.nameTooShort{
			UNameError.isHidden = false
		} catch errorList.nameTooLong{
			UNameError.isHidden = false
		} catch errorList.userNameRegex {
			UNameError.isHidden = false
		} catch {
			//display unknown error alert
			
			print("Some Error with UserName Validation, Result -> \(result)")

		}
	}
	
	else if (textField.tag == 4){
		do{
			print("Checked Password")
			result = try isPasswordValid(trimmedText!)
			if (result){
				self.PwordCheck = true
			}
		} catch errorList.passTooShort{
			PassError.isHidden = false
		} catch errorList.passNotMatchRegex{
			PassError.isHidden = false
		} catch {
			//UNKNOWN ERROR
			print("Some Error with Password Validation, Result -> \(result)")

		}
	}
	
	else if (textField.tag == 5){
		
		let original = Password.text?.stringTrimFrontandBackWhiteSpace()
		
		if (original == nil){
			print ("Error LINE 354")
		}
			do{
				result = try doPasswordsMatch(original!, confirm: trimmedText!)
				if (result){
					self.matchCheck = true
					print("RESULT MATCH ->: \(result)")
				}
		
			}
			 catch errorList.passNotConfirmed{
				ConfirmError.isHidden = false
				//self.view.addSubview(ConfirmError)
				//UNKNOWN ERROR
			}	catch{
				print("Some Error with Confirmation Validation, Result -> \(result)")

		}
		}
	//legacy code
		//return result
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		selectedField = textField
		if (textField.tag == 1){
			if (!NameError.isHidden){
				NameError.isHidden = true
			}
		}
		if (textField.tag == 2){
			if (!EmailError.isHidden){
				EmailError.isHidden = true
			}
		}
		if (textField.tag == 3){
			if (!UNameError.isHidden){
			UNameError.isHidden = true
			}
		}
		if (textField.tag == 4) {
			if (!PassError.isHidden){
			PassError.isHidden = true
			}
		}
	
		if (textField.tag == 5){
			if (!ConfirmError.isHidden){
			ConfirmError.isHidden = true
			}
		}
		
	}
	
	
	@IBAction func DidPressSignUp(_ sender: UIButton) {
		//self.SignUpButton.becomeFirstResponder()
		for view in self.view.subviews as [UIView]{
			if let textField = view as? UITextField{
				if (textField.isFirstResponder){
					self.resignFirstResponder()
					self.textFieldDidEndEditing(textField)
					self.SignUpButton.becomeFirstResponder()
				}
			}
		}
		let original = Password.text?.stringTrimFrontandBackWhiteSpace()
		let confirm  = ConfirmPass.text?.stringTrimFrontandBackWhiteSpace()
		
		//For some reason Did end editing is not called on the currently selected textfield no matter what i try so i will
		//have to add a check for all fields in this method.   Added a currently selected field value so we can loop and 
		//look for the currently selected field and check based on that. for now, only checking if passwords match cause that is the most likely last fields interacted with
		do{
			let result: Bool = try doPasswordsMatch(original!, confirm: confirm!)
			if (result){
				self.matchCheck = true
			}
		} catch{
			print("TESTYTESTYESY")
		}
		message = ""
 		if (self.nameCheck && self.PwordCheck && self.uNameCheck && self.matchCheck && self.emailCheck)
		{
			let email  = self.Email.text!
			let password  = self.Password.text!
			let userName = self.UName.text!
			let FullName = self.FName.text!
			//let Confirm = self.ConfirmPass.text

	
			self.allFieldsFilled = true
			
			RestAPIManager.makeUserPostRequest(email: email, password: password, FullName: FullName, userName: userName) { (data, response, error) in
				guard error == nil else{
					print ("Error: \(String(describing: error?.localizedDescription))")
					return
				}
				
				guard let data = data else{
					print("Data is missing")
					return
				}
				
				
					let status = response  as? HTTPURLResponse
					print ("Status: \(String(describing: status))")
				if status?.statusCode == 201{
					self.signInUser(withEmail: email, password: password, completion: { (user, error) in
						if let error = error{
						print("Sign Up Page Sign In Error -> \(String(describing: error.localizedDescription))")
						/*	 self.message = "\(String(describing: error.localizedDescription))"
							let SignInalert = UIAlertController(title: "Error!", message: self.message, preferredStyle: .alert)
							let dismiss = UIAlertAction(title: "Dismiss", style: .destructive, handler: { (action) -> Void in })
							SignInalert.addAction(dismiss)
							self.present(SignInalert, animated: true, completion: nil)*/
							return
							
						}
							self.signUpRequestSuccessful = true
							self.performSegue(withIdentifier: "SU2First", sender: nil)
						
					})
				
				}
				
				do{
					let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
					print ("Result -> \(String(describing: result))")
					//handle result and determine when  segue is allowable by setting boolean flag
					//self.performSegue(withIdentifier: "SU2First", sender: nil)

				} catch let error{
					print ("ERROR -> \(String(describing: error.localizedDescription))")
				}
				
				
			}
				
		}
		
		
		else {
	//if the field text is missing we do not want both errors to occur
			// so if we fail, Either text is MISSING or Something wrong was entered
			if (!self.Email.hasText){
				self.message += "Email Missing"
			}
			else if (!self.emailCheck && (self.selectedField != Email)){
				self.message += "Something Wrong with Email"
				self.Email.isHighlighted = true
			}
			if (!self.Password.hasText){
				self.message += "\nPassword Missing"
			}
			else{
				if (!self.PwordCheck && (self.selectedField != Password))  {
					self.message += "\nSomething wrong with Password"
				}
				if (!self.matchCheck && (self.selectedField != ConfirmPass)) {
					self.message += "\nSomething went wrong confirming Password"

				}
			}
			if (!UName.hasText){
				self.message += "\nUserName Missing"
			}
			else if (!self.uNameCheck && (self.selectedField != UName)){
				self.message += "\nSomething wrong with User Name"
			}
			if(!FName.hasText){
				self.message += "\nName Missing"
			}
			else if(!self.nameCheck && (self.selectedField != FName)){
				self.message += "\nSomething is wrong with the Entered Name"
			}
			if (!ConfirmPass.hasText){
				self.message += "\nPassword Confirmation Missing"
			}
			
			let alert = UIAlertController(title: "Missing Field!", message: message, preferredStyle: .alert)
			let dismiss = UIAlertAction(title: "Dismiss", style: .destructive, handler: { (action) -> Void in })
			alert.addAction(dismiss)
			present(alert, animated: true, completion: nil)
		}
		
		
		
		/*{
		"email" : "<email>",
		"name": "<name>",
		"username": "<username>",
		"password" : "<password>"
		}*/
	}
	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
		print("SHOULD PERFORM SEGUE?")
		if ( identifier == "SU2First" && (!self.allFieldsFilled  || !self.signUpRequestSuccessful)){
			print("SignUp Success: \(self.signUpRequestSuccessful)")
			return false
		}
		else{
			return true
		}
	}
	
	func signInUser(withEmail: String, password: String, completion: @escaping (_ user: User?, _ error: Error?) ->  ()) {
		Auth.auth().signIn(withEmail: withEmail, password: password, completion: { (user, error) in
			guard error == nil else{
				
				return
			}
			
			completion(user, error)
			
			
		})
	}
	
	
}

