//
//  DaysViewCell.swift
//  CauseFeedProto2
//
//  Created by Jacob Levy on 8/17/17.
//  Copyright © 2017 Jacob Levy. All rights reserved.
//

import UIKit

class DaysViewCell: UICollectionViewCell {
	var textLabel: UILabel!
	
	override init(frame: CGRect){
		super.init(frame: frame)
		/*self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: 50, height: 44)*/
		textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
		textLabel.font = UIFont.systemFont(ofSize: 13.0)
		textLabel.textAlignment = .center
		textLabel.numberOfLines = 0
		textLabel.adjustsFontSizeToFitWidth = true
		textLabel.minimumScaleFactor = 0.1
		contentView.addSubview(textLabel)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		print ("Called aDecoder from Days Cell")
	}
	
}

