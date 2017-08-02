//
//  MyScroll.swift
//  CauseFeedProto2
//
//  Created by Jacob Levy on 7/25/17.
//  Copyright © 2017 Jacob Levy. All rights reserved.
//
/*
import UIKit
import ObjectiveC
private let kCalculatedContentPadding: CGFloat = 10
private let kMinimumScrollOffsetPadding: CGFloat = 20

let _UIKeyboardFrameEndUserInfoKey = (UIKeyboardFrameEndUserInfoKey != nil ? UIKeyboardFrameEndUserInfoKey : "UIKeyboardBoundsUserInfoKey")
class viewState: NSObject{
	var keyBoardVisible: Bool = false
	var priorPagingEnabled: Bool = false
	var ignoringNotifications: Bool = false
	var keyboardAnimeInProgress: Bool = false
	var priorInsets: UIEdgeInsets = UIEdgeInsets()
	var priorScrollIndicatorInsets: UIEdgeInsets = UIEdgeInsets()
	var keyboardRect: CGRect = CGRect()
	var priorContentSize: CGSize = CGSize()
	
	
	/*
	// Only override draw() if you perform custom drawing.
	// An empty implementation adversely affects performance during animation.
	override func draw(_ rect: CGRect) {
	// Drawing code
	}
	*/
	
}
*/
//var StateKeyHandle: UInt8 = 0
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
	
	
	/*override func sizeThatFits(_ size: CGSize) -> CGSize {
		self.contentSize = self.CalculateSizefromSubviews()
		return self.contentSize
	}
	
	func CalculateSizefromSubviews()->Void{
	var userInfo = notification.userInfo ?? [:]
	let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
	
	let adjustment = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
	let mySubViews = self.view.subviews
	var rect: CGRect = CGRect.zero
	for view in mySubViews{
	rect = rect.union(view.frame)
		}
	}*/

}
extension String{
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
}
/*
	var currentState:viewState{
		get{
			return objc_getAssociatedObject(self, &StateKeyHandle) as? viewState ?? viewState()
		}
		set{
			objc_setAssociatedObject(self, &StateKeyHandle, newValue,.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
	func setup(){
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(tpka_keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
		/*NotificationCenter.default.addObserver(self, selector: #selector(scrollToActiveTextField), name: NSNotification.Name.UITextViewTextDidBeginEditing, object: self)
		NotificationCenter.default.addObserver(self, selector: #selector(scrollToActiveTextField, name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: self)*/
		
	}
	
	override init(frame: CGRect) {
	//	do{
		super.init(frame: frame)
/*		} catch{
			print("WEIRD FRIGGIN ERROR")
		}*/
		setup()
	}
	override func awakeFromNib() {
		super.awakeFromNib()
		setup()
	}
	required init?(coder aDecoder: NSCoder) {
		//do {
			super.init(coder: aDecoder)
		/*}catch{
		fatalError("init(coder:) has not been implemented")
		}*/
			setup()
	}
	deinit {
		//NotificationCenter.default.removeObserver(self)
		print("\n DEINITIALIZER CALLED")
	}/*
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		resignFirstResponder()
	}*/
	//  Converted with Swiftify v1.0.6414 - https://objectivec2swift.com/
	func updateContentInset() {
		let state: viewState = self.currentState
		if (state.keyBoardVisible){
			contentInset = self.contentInsetForKeyboard()
		}
	}

	func setFrame(frame: CGRect)-> Void{
		super.frame = frame
		self.updateContentInset()
	}
	//  Converted with Swiftify v1.0.6414 - https://objectivec2swift.com/
	override var contentSize: CGSize{
		
		set{
		super.contentSize = self.contentSize
		self.updateContentInset()
		}
		get{
		return CGSize(width: self.contentSize.width, height: self.contentSize.height)/**/
		}
	}
	
	override func sizeToFit() {
		self.contentSize = self.CalculateSizefromSubviews()
	}
	//  Converted with Swiftify v1.0.6414 - https://objectivec2swift.com/
	func tpKeyboardAvoiding_findNextInputViewafter(priorView: UIView, beneathView view: UIView) -> UIView? {
		var candidate: UIView? = nil
		tpKeyboardAvoiding_findNextInputViewafter(priorView, beneathView: view, bestCandidate: candidate)
		return candidate!
	}

	func tpKeyboardAvoiding_initializeView(_ view: UIView) {
		if (view is UITextField) && (view as? UITextField)?.returnKeyType == UIReturnKeyType.default && (!(view is UITextFieldDelegate || (view as? UITextField)?.delegate() == (self as? UITextFieldDelegate)) {
			(view as? UITextField)?.delegate = (self as? UITextFieldDelegate)
			let otherView: UIView? = tpKeyboardAvoiding_findNextInputView(after: view, beneathView: self)
			if otherView != nil {
				(view as? UITextField)?.returnKeyType = UIReturnKeyNext
			}
			else {
				(view as? UITextField)?.returnKeyType = UIReturnKeyDone
			}
		}
	}
	
	//  Converted with Swiftify v1.0.6414 - https://objectivec2swift.com/
	func assignTextDelegateforViewsBeneath(view: UIView) {
		for childView: UIView in view.subviews {
			if (childView is UITextField) || (childView is UITextView) {
				tpKeyboardAvoiding_initializeView(childView)
			}
			else {
				tpKeyboardAvoiding_assignTextDelegate(forViewsBeneathView: childView)
			}
		}
	}

	override func willMove(toSuperview newSuperview: UIView?) {
		super.willMove(toSuperview: newSuperview)
		/*69-70
		will */
	}
	
	
	func CalculateSizefromSubviews()-> CGSize{
		let wasShowingScrollIndicator = self.showsVerticalScrollIndicator
		let wasShowingHorizScrollIndicator = self.showsHorizontalScrollIndicator
		
		self.showsHorizontalScrollIndicator = false
		self.showsVerticalScrollIndicator = false
		
		var rect: CGRect = CGRect .zero
		for view in self.subviews{
			rect = rect.union(view.frame)
		}
		rect.size.height += 10
		
		self.showsHorizontalScrollIndicator = wasShowingHorizScrollIndicator
		
		self.showsVerticalScrollIndicator = wasShowingScrollIndicator
		
		return rect.size
		
	}
	
	@objc func keyboardViewAppear(animationID: String, context: UnsafeMutableRawPointer){
		self.currentState.keyboardAnimeInProgress = true
	}
	
	@objc func keyboardViewDisappear(animationID: String, finished: Bool, context: UnsafeMutableRawPointer){
		if (finished){
			self.currentState.keyboardAnimeInProgress = false
		}
	}
	
	func contentInsetForKeyboard()-> UIEdgeInsets{
		let myState = self.currentState
		
		var newInset = self.contentInset
		let keyRect = myState.keyboardRect
		newInset.bottom = keyRect.size.height - max((keyRect.maxY), self.bounds.maxY)
		return newInset
	}
	func tpKeyboardAvoiding_findFirstResponderBeneathView(_ view: UIView) -> UIView? {
		// Search recursively for first responder
		for childView: UIView in view.subviews {
			if childView.responds(to: #selector(getter: self.isFirstResponder)) && childView.isFirstResponder {
				return childView
			}
			let result: UIView? = tpKeyboardAvoiding_findFirstResponderBeneathView(childView)
			if result != nil {
				return result!
			}
		}
		return nil
	}
	
	
	func tpKeyboardAvoiding_idealOffset(for view: UIView, withViewingAreaHeight viewAreaHeight: CGFloat) -> CGFloat {
		let contentSize: CGSize = self.contentSize
		var offset: CGFloat = 0.0
		let subviewRect: CGRect = view.convert(view.bounds, to: self)
		var padding: CGFloat = 0.0
		let centerViewInViewableArea: (() -> Void)? = {() -> Void in
			// Attempt to center the subview in the visible space
			padding = (viewAreaHeight - subviewRect.size.height) / 2
			// But if that means there will be less than kMinimumScrollOffsetPadding
			// pixels above the view, then substitute kMinimumScrollOffsetPadding
			if padding < kMinimumScrollOffsetPadding {
				padding = kMinimumScrollOffsetPadding
			}
			// Ideal offset places the subview rectangle origin "padding" points from the top of the scrollview.
			// If there is a top contentInset, also compensate for this so that subviewRect will not be placed under
			// things like navigation bars.
			offset = subviewRect.origin.y - padding - self.contentInset.top
		}
		// If possible, center the caret in the visible space. Otherwise, center the entire view in the visible space.
		if view is UITextInput {
			let textInput: UITextInput? = (view as? UITextInput)
			let caretPosition: UITextPosition? = textInput?.selectedTextRange?.start
			if caretPosition != nil {
				let caretRect: CGRect? = self.convert((textInput?.caretRect(for: caretPosition!))!, from: textInput as? UIView)
				// Attempt to center the cursor in the visible space
				// pixels above the view, then substitute kMinimumScrollOffsetPadding
				padding = (viewAreaHeight - (caretRect?.size.height)!) / 2
				// But if that means there will be less than kMinimumScrollOffsetPadding
				// pixels above the view, then substitute kMinimumScrollOffsetPadding
				if padding < kMinimumScrollOffsetPadding {
					padding = kMinimumScrollOffsetPadding
				}
				// Ideal offset places the subview rectangle origin "padding" points from the top of the scrollview.
				// If there is a top contentInset, also compensate for this so that subviewRect will not be placed under
				// things like navigation bars.
				offset = (caretRect?.origin.y)! - padding - contentInset.top
			}
			else {
				centerViewInViewableArea!()
			}
		}
		else {
			centerViewInViewableArea!()
		}
		// Constrain the new contentOffset so we can't scroll past the bottom. Note that we don't take the bottom
		// inset into account, as this is manipulated to make space for the keyboard.
		let maxOffset: CGFloat = contentSize.height - viewAreaHeight - self.contentInset.top
		
		if (offset > maxOffset) {
			offset = maxOffset
		}
		// Constrain the new contentOffset so we can't scroll past the top, taking contentInsets into account
		if (offset < -self.contentInset.top) {
			offset = -self.contentInset.top
		}
		return offset
	}

	func keyboardWillShow(notification:NSNotification) -> Void {
		var priorInset: UIEdgeInsets
		
		var userInfo = notification.userInfo!
		var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
		keyboardFrame = self.convert(keyboardFrame, from: nil)
		if (keyboardFrame.isEmpty){
			return
		}
		let thisState:viewState = self.currentState
		if (thisState.ignoringNotifications){
			return
		}
		thisState.keyboardRect = keyboardFrame
		
		if (!thisState.keyBoardVisible){
			thisState.priorInsets = self.contentInset
			thisState.priorScrollIndicatorInsets = self.scrollIndicatorInsets
			thisState.priorPagingEnabled = self.isPagingEnabled
		}
		thisState.keyBoardVisible = true
		self.isPagingEnabled = false
		
	//	if (self is UIScrollView){
			thisState.priorContentSize = self.contentSize
			
			if(self.contentSize.equalTo(CGSize .zero)){
				
				self.contentSize  = CalculateSizefromSubviews()
			
			}
		//}
		let delay = DispatchTime.now() + Double((Int64)(0.01 * Double(NSEC_PER_SEC)))
	//	DispatchQueue.main.asyncAfter(deadline: (delay.rawValue /NSEC_PER_SEC), execute: {() -> Void in
		DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: (delay.rawValue/NSEC_PER_SEC))) {
			// Shrink view's inset by the keyboard's height, and scroll to show the text field/view being edited
			UIView.beginAnimations(nil, context: nil)
			UIView.setAnimationDelegate(self)
		//	let rawPointer = UnsafeMutableRawPointer
			UIView.setAnimationWillStart(#selector(self.keyboardViewAppear))
			
			
				UIView.setAnimationDidStop(#selector(self.keyboardViewDisappear))
			let rawAnimationCurveValue = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).uintValue

			UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: Int(rawAnimationCurveValue))!)
			UIView.setAnimationDuration(userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval)
			
			self.contentInset = self.contentInsetForKeyboard()
			
			/**/
	let myFirst: UIView? = self.tpKeyboardAvoiding_findFirstResponderBeneathView(self)

			//might need to remove this block
			if(!(myFirst!.isFirstResponder)){
				return
			}
			//
			
			if (myFirst?.isFirstResponder)!{
				
				var viewableHeight = self.bounds.size.height - self.contentInset.top - self.contentInset.bottom
			/**/	self.setContentOffset( CGPoint.init(x: self.contentOffset.x, y: self.tpKeyboardAvoiding_idealOffset(for: myFirst!, withViewingAreaHeight: viewableHeight)) , animated: false)
				
				
			}
			self.scrollIndicatorInsets = self.contentInset
			self.layoutIfNeeded()
			
			
			UIView.commitAnimations()
			
				
			
			
	/*	var contentInset:UIEdgeInsets = self.contentInset
		contentInset.bottom = keyboardFrame.size.height
		self.contentInset = contentInset*/
		
		}
		
	}//  Converted with Swiftify v1.0.6414 - https://objectivec2swift.com/
	func tpka_keyboardWillHide(_ notification: Notification) {
		let userInfo = notification.userInfo!
		
		let keyboardRect = self.convert(notification.userInfo?[_UIKeyboardFrameEndUserInfoKey] as? CGRect ?? CGRect.zero, from: nil)
		if (keyboardRect.isEmpty && !(self.currentState.keyboardAnimeInProgress) ){
			return
		}
		let state: viewState? = self.currentState
		
		if (state?.ignoringNotifications)! {
			return
		}
		if !(state?.keyBoardVisible)! {
			return
		}
		
		state?.keyboardRect = CGRect.zero
		state?.keyBoardVisible = false
		// Restore dimensions to prior size
		UIView.beginAnimations(nil, context: nil)
		UIView.setAnimationCurve(userInfo[UIKeyboardAnimationCurveUserInfoKey] as! UIViewAnimationCurve )
		
		UIView.setAnimationDuration(userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval)
		
		
			self.contentSize = (state?.priorContentSize)!
		
		self.contentInset = (state?.priorInsets)!
		self.scrollIndicatorInsets = (state?.priorScrollIndicatorInsets)!
		
		self.isPagingEnabled = (state?.priorPagingEnabled)!
		
		self.layoutIfNeeded()
		UIView.commitAnimations()
	}
/*
	func keyboardWillHide(notification:NSNotification){
		let contentInset:UIEdgeInsets = UIEdgeInsets.zero
		self.contentInset = contentInset
	}
	func*/
	
}*/
