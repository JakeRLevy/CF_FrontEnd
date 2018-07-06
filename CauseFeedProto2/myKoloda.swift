//
//  myKoloda.swift
//  CauseFeedProto2
//
//  Created by Jacob Levy on 10/26/17.
//  Copyright © 2017 Jacob Levy. All rights reserved.
//
import Koloda
import UIKit
let defaultBottomOffset:CGFloat = 0
let defaultTopOffset:CGFloat = 20
let defaultHorizontalOffset:CGFloat = 10
let defaultHeightRatio:CGFloat = 1.25
//if we do a customized KolodaView we will need our own Koloda sub-class
class myKoloda: KolodaView {
	    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	override func  frameForCard(at index: Int) -> CGRect {
		return CGRect.zero
	}

}
