//
//  myOverlayView.swift
//  CauseFeedProto2
//
//  Created by Jacob Levy on 11/9/17.
//  Copyright © 2017 Jacob Levy. All rights reserved.
//

import UIKit
import Koloda



private let overlayRightImageName = "final_like_overlay"
private let overlayLeftImageName = "final_skip_overlay"

class myOverlayView: OverlayView {

	@IBOutlet lazy var overlayIMG2: UIImageView! = {
		[unowned self] in
		
		var imageView = UIImageView(frame: self.bounds) as UIImageView
		self.addSubview(imageView)
		
		return imageView
		}()

	/*@IBOutlet weak var overlayIMG: UIImageView! = {
		[unowned self] in
		
		var imageView  = UIImageView(frame: self.bounds)
		self.addSubview(imageView)
		return imageView
	}()*/
	
	override var overlayState: SwipeResultDirection?{
		didSet{
			switch overlayState{
			case .left?:
				overlayIMG2?.image = UIImage(named: overlayLeftImageName)
			case .right?:
				overlayIMG2?.image = UIImage(named: overlayRightImageName)
			default:
				overlayIMG2?.image = nil
				
			}
		}
	}
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

