  //
//  XfadeSegue.swift
//  CauseFeedProto2
//
//  Created by Jacob Levy on 6/24/17.
//  Copyright © 2017 Jacob Levy. All rights reserved.
//

import UIKit
//Custom Segue Animation for SignIN/SignUp Container View
//Purpose: Provide a wipe-animation segue to change from signin to sign up container views
class XfadeSegue: UIStoryboardSegue {

	
	override init(identifier: String?, source: UIViewController, destination: UIViewController) {
		var myID: String
		if identifier == nil {
			myID = ""
		} else {
			myID = identifier!
		}
		super.init(identifier: myID, source: source, destination: destination)
	}
	
	override func perform() {
		let sourceVC = self.source
		let destinationVC = self.destination 
		let masterVC = source.parent!
		destinationVC.view.frame = sourceVC.view.frame//not necessary?

		masterVC.addChildViewController(destinationVC)
	
		//sourceVC.definesPresentationContext = true
		
		destinationVC.view.transform = CGAffineTransform(translationX: -sourceVC.view.frame.size.width, y: 0)
		masterVC.transition(from: sourceVC, to: destinationVC, duration: 1.0, options: [.curveEaseInOut, ], animations: {
			destinationVC.view.transform = CGAffineTransform(translationX: 0, y: 0)
		}, completion: nil)
		
	}
}
