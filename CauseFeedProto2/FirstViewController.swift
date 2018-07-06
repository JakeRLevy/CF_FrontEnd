//
//  FirstViewController.swift
//  CauseFeedProto2
//
//  Created by Jacob Levy on 6/8/17.
//  Copyright © 2017 Jacob Levy. All rights reserved.
//
//THoughts, new table in the database with userID as key, stores the causes that user has passed on.   Download this only in
//the swipe page, along with user data, filter the causes downloaded (on each download) with this array/dict/whatever

import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import UIKit
import Koloda
private var numberOfCards: UInt = 10

class FirstViewController: UIViewController, KolodaViewDataSource, KolodaViewDelegate{
	//@IBOutlet weak var kolodaView: KolodaView!
	@IBOutlet weak var kolodaView: KolodaView!
	
	
//Array to store the downloaded causes to be swiped on
	/*fileprivate var causeData: [CauseModel] = {
		var causeArray: [CauseModel] = []
		
	
		}*/
	var SwipeAMT : Float = Float()
	let curUser = Auth.auth().currentUser
	let storage = Storage.storage() //Remains for Photo Storage
	fileprivate var photoLoadDone = false
	fileprivate var causeFeed: [causeDataObject] = []
	fileprivate var causeData: [CauseModel] = []  //remove
	fileprivate var dataSource: [UIImage] = []
	fileprivate var causeIMGDict : [String: UIImage] = [:]
	fileprivate var imgPathStr = "img/causes/"
	fileprivate var showEmptyLabel = false
	override func viewDidLoad() {
		super.viewDidLoad()
				// Do any additional setup after loading the view, typically from a nib.
		
	
	

		
	}
	override func viewWillAppear(_ animated: Bool) {
				for tabBarItem in (self.tabBarController?.tabBar.items!)!{
			tabBarItem.title = ""
			tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
			
		}
		
		if(self.kolodaView.isHidden){
			self.kolodaView.isHidden = false
		}
		
		if (!self.photoLoadDone && self.causeFeed.isEmpty){
			self.fillMyCauseFeed()
		
		}
	}
	
	func fillMyCauseFeed(){
		DjangoManager.fillCauseFeed(forUser: (curUser?.displayName)!) { (loadedCauseFeed, error)  ->() in
			if (error != nil){
				print("ERRROR FILLING FEED!!")
				print(error!.localizedDescription)
				//throw error!
				return
			}
			else{
				for cause in loadedCauseFeed!{
					self.causeFeed.append(cause)
					print("Adding Cause " + String(cause.causeID!))
				}
				self.showEmptyLabel = false
				self.fetchMyFeedPhotos()
			}
			if self.causeFeed.isEmpty{
				self.showEmptyLabel = true
				print("FEED EMPTY KOLODA DECK HAS BEEN HIDDEN")
			}
		}
	}
	
	

	
			func fetchMyFeedPhotos(){
				let storageRef = storage.reference()  //remove
				let imageGroup = DispatchGroup()
				
				let fetchXphotos = min(10, self.causeFeed.count)
				for cause in 0 ..< fetchXphotos {
					imageGroup.enter()
					print("Fetching image for ID: ", self.causeFeed[cause].getID(), " Title: ", self.causeFeed[cause].getTitle(), "Position: " + String(cause))
					let path: String = self.imgPathStr + String(self.causeFeed[cause].getID()) + ".jpg"
					print ("At the Path: " + path)
					let imgRef = self.storage.reference(withPath: path)
					imgRef.getData(maxSize: 2 * 1024 * 1024) { (data, error) in
						if let error = error{
							print("Sorry an error occurred downloading the img at " + path)
							print ("\(error.localizedDescription)")
						}
						else{
							let currentIMG =  UIImage(data: data!)!
							self.causeIMGDict[String(cause)] = currentIMG //for tracking the cause to the image
							print("Adding Image to Local Dictionary", String(cause))
						}
						imageGroup.leave()
						
					}
				}
				
				//Have to assign the Data Source here
				//this is only called after the entire group finishes
				//which means all 10 initial photos have downloaded
				//uses the cause-IMG Dict to ensure that images are added to the correct cause
				imageGroup.notify(queue: .main, execute: {
					for cause in 0 ..< fetchXphotos {
						let causeIMG = self.causeIMGDict[String(cause)]
						if (causeIMG != nil){
							self.dataSource.append(causeIMG!)
						}
						
					}
					print("Loading Swipe Callbacks Completed")
					self.photoLoadDone = true
					print("Testing.......")
					self.kolodaView.dataSource = self
					self.kolodaView.delegate = self
					
				})
			}
			

	
	func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
		print("Koloda Did Run Out of Cards Called")
		if(self.photoLoadDone && !causeFeed.isEmpty){
			self.photoLoadDone = false
			self.fetchMyFeedPhotos()
		}
		else if (causeFeed.isEmpty){
			self.fillMyCauseFeed()
		}
		
		koloda.reloadData()
	}
	//need to read their reload API
	//func reloadData
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	///Return the number of items (views) in the KolodaView.
	func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
		print ("X#X#X#X#X#X#X#X#X#X#X NUMBER OF CARDS CALLED X#X#X#X#X#X#X#X#X#X#X")
		print ("Current Koloda Index: ", self.kolodaView.currentCardIndex)
		print("\(dataSource.count)")
		if(!showEmptyLabel){
			return dataSource.count
		} else{
			return 1
		}
	}
	//Return a view to be displayed at the specified index in the KolodaView.
	func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
		print ("X#X#X#X#X#X#X#X#X#X#X view for Card At INDEX \(index) CALLED X#X#X#X#X#X#X#X#X#X#X")
		print ("Current Koloda Index: ", self.kolodaView.currentCardIndex)
		if (!self.showEmptyLabel){
		return UIImageView(image: dataSource[Int(index)])
		}
		else{
			return UIImageView(image: UIImage(named: "EmptyFeedLabel"))
		}
	}
	@IBAction func rightButtonTap(_ sender: Any) {
		kolodaView?.swipe(.right)

	}
	@IBAction func leftButtonTap(_ sender: Any) {
		
		kolodaView?.swipe(.left)
		
	}
	override func viewWillDisappear(_ animated: Bool) {
	
		
	}
	//Return a view for card overlay at the specified index. For setting custom overlay action on swiping
	//(left/right), you should override didSet of overlayState property in OverlayView. (See Example)
	func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView?{
		return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
	}
	//Allow management of the swipe animation duration
	func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed{
		
		
		return DragSpeed.moderate
	}
	
	//METHODS THAT NEED TO BE IMPLEMENTED
	
	//func koloda(_ koloda: KolodaView, shouldSwipeCardAt index: Int, in direction: SwipeResultDirection) -> Bool
	//should be implemented to allow passes on causes but no donation swipe if the user has no money returns false
	//need to pull data from user's account and make DB calls to update when swipe right occurs
	
	//Return the allowed directions for a given card, defaults to [.left, .right]
	func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection]{
		if (!causeFeed.isEmpty){
			return [SwipeResultDirection.left, SwipeResultDirection.bottomLeft, SwipeResultDirection.topLeft, SwipeResultDirection.right, SwipeResultDirection.bottomRight, SwipeResultDirection.topRight]
		}
		else{
			return [SwipeResultDirection.bottomRight]
		}
	}
	//Don't think this needs to be overriden
	
	
	//This method is called whenever the KolodaView swipes card. It is called regardless of whether the card was swiped programatically or through user interaction.
	func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection){
		//print("ID: " + String(self.causeFeed[0].getID()) + "Title: " + self.causeFeed[0].getTitle() + "Position in Data Source" + String(index))
		
		if (direction == .right || direction == .bottomRight || direction == .topRight){
			print("Right Swipe")
			if(!causeFeed.isEmpty){
			rightSwipe(forCardWith: self.causeFeed[0].getID())
		
			}
			
		}
		else{
			print("Left Swipe")
			if(!causeFeed.isEmpty){
			leftSwipe(forCardWith: self.causeFeed[0].getID())
			}
		}
		if (!causeFeed.isEmpty){
		causeFeed.remove(at: 0)
		} else if (causeFeed.isEmpty){
			kolodaView.revertAction()
		}
	}
	
	func rightSwipe(forCardWith ID: Int){
		
		DjangoManager.makeADonation(forUser: (self.curUser?.displayName)!, andCause: ID , withAmt: self.SwipeAMT) { (error, response) in
			guard error == nil else{
				print("Some error came back")
				print((error?.localizedDescription)!)
				return
			}
				print(response)
		}
	}
	
	func leftSwipe(forCardWith ID: Int){
		DjangoManager.skipThis(forUser: (self.curUser?.displayName)!, andCause: ID) { (error, response) in
			guard error == nil else{
				print((error?.localizedDescription)!)
				return
			}
			print(response)
		}
		}

}
	//actually updates the data when the cards have been swiped
	
	//This method is called when the KolodaView has no cards to display.
	//func kolodaDidRunOutOfCards(_ koloda: KolodaView){}
	//When cards run out, any causes that have been passed on get pushed back, DISCUSS
	
	
	//////////////////////////
	//MAY NEED TO IMPLEMENT?
	//This method is fired on reload, when any cards are displayed. If you return YES from the method or don't implement it, the koloda will apply appear animation
	//func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool
	//
	//
	//This method is fired on koloda's layout and after swiping. If you return YES from the method or don't implement it, the koloda will transparentize next card below front card.
	
	//func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool
	
	
	//This method is called whenever the KolodaView recognizes card dragging event.
	//func koloda(_ koloda: KolodaView, draggedCardWithPercentage finishPercentage: CGFloat, in direction: SwipeResultDirection)
	//
	
	//Return the percentage of the distance between the center of the card and the edge at the drag direction that needs to be dragged in order to trigger a swipe. The default behavior (or returning NIL) will set this threshold to half of the distance
	

	//func kolodaSwipeThresholdRatioMargin(_ koloda: KolodaView) -> CGFloat?

	
	//This method is fired after resetting the card.
	

	
	///////////////////////////////////////////////////////////////////////////////
	//UNIMPLEMENTED PROTOCOL (Delegate) METHODS

	//Perform action when card is tapped
	/*
	func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
	UIApplication.shared.openURL(URL(string: "https://yalantis.com/")!)
	}
	*/
	


