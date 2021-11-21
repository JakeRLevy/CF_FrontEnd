//
//  MyScroll.swift
//  CauseFeedProto2
//
//  Created by Jacob Levy on 7/25/17.
//  Copyright © 2017 Jacob Levy. All rights reserved.
//

import UIKit
import Foundation
class MyScroll: UIScrollView {
	//private var allFieldsFilled:Bool

	
 private var allFieldsFilled:Bool {
		get{
			let myTextViews = self.subviews.filter{$0 is UITextView}
			for _childView:UIView in myTextViews{
				if (!(_childView as! UITextView).hasText){
				return false
				}
				
			}
			return true
		}
		set{
		self.allFieldsFilled = newValue
		}
	
	}
	override init(frame: CGRect) {
		
		super.init(frame: frame)
	}
	required init?(coder aDecoder: NSCoder) {
		print("RAN aDecoder")
		super.init(coder: aDecoder)
	}
	
	
	

	
}
//Extension to String Class to help sanitize inputs from users
//uses a regex to determine if there is leading or trailing whitespace
//and trims any it finds
extension String{
	func stringTrimFrontandBackWhiteSpace()-> String{
		let frontBackWspace = "(?:^\\s+)|(?:\\s+$)"
		let testRegEx =  try? NSRegularExpression(pattern: frontBackWspace, options: .caseInsensitive)
		if (testRegEx == nil){
			print("error!")
			return self
		}
		
		let range = NSMakeRange(0, self.count)
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
}
