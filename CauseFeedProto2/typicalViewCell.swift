//
//  typicalViewCell.swift
//Used for cause cells

//  CauseFeedProto2
//
//  Created by Jacob Levy on 8/15/17.
//  Copyright © 2017 Jacob Levy. All rights reserved.
//

import UIKit

class typicalViewCell: UICollectionViewCell {
	var textLabel: UILabel!
	
	
	 override init(frame: CGRect){
		super.init(frame: frame)
	/*	self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: , height: 44)*/
		textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
		textLabel.font = UIFont.systemFont(ofSize: 12.0)
		textLabel.textAlignment = .center
		contentView.addSubview(textLabel)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		print ("Called aDecoder from Cell")
	}
	/*
	required init?(coder aDecoder: NSCoder) {
		super.i
	print ("Called aDecoder in Cell")
	}
	*/
}
