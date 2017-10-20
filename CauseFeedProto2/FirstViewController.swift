//
//  FirstViewController.swift
//  CauseFeedProto2
//
//  Created by Jacob Levy on 6/8/17.
//  Copyright © 2017 Jacob Levy. All rights reserved.
//

import UIKit
import Koloda

class FirstViewController: UIViewController, KolodaViewDataSource, KolodaViewDelegate{
	@IBOutlet weak var kolodaView: KolodaView!
	
	//Array to store the downloaded causes to be swiped on
	var data: [CauseModel] = []
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
				// Do any additional setup after loading the view, typically from a nib.
		
		kolodaView?.dataSource = self
		kolodaView?.delegate = self
		
	}
	override func viewWillAppear(_ animated: Bool) {
		/*self.tabBarController?.tabBar.tintColor = myGreenBG
		self.tabBarController?.tabBar.backgroundColor = myGreenBG*/
		for tabBarItem in (self.tabBarController?.tabBar.items!)!{
			tabBarItem.title = ""
			tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
			
		}
		
		
		
	}
	func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
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
		
			return data.count
	}
	//Return a view to be displayed at the specified index in the KolodaView.
	func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
		let causeView = UIView()
		
		return causeView
		
	}
	//Return a view for card overlay at the specified index. For setting custom overlay action on swiping
	//(left/right), you should override didSet of overlayState property in OverlayView. (See Example)
	func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView?{
		let coverView: OverlayView? = OverlayView()
		
		//do stuff to cover the view
		return coverView
	}
	//Allow management of the swipe animation duration
	func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed{
		
		
		return DragSpeed.moderate
	}
	
	//Return the allowed directions for a given card, defaults to [.left, .right]
	//func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection]


	
}

