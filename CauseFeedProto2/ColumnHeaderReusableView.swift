//
//  ColumnHeaderReusableView.swift
//  CauseFeedProto2
//
//  Created by Jacob Levy on 12/10/17.
//  Copyright © 2017 Jacob Levy. All rights reserved.
//

import UIKit

class ColumnHeaderReusableView: UICollectionReusableView {
	private var cause: CauseHeader!
	private var goal: GoalHeader!
	private var raised: RaisedHeader!
	private var days: DaysHeader!
	private var support: SupportHeader!
	
	override init(frame: CGRect){
		super.init(frame: frame)
		cause = CauseHeader(frame: frame)
		self.addSubview(cause)
		goal = GoalHeader(frame:frame)
		self.addSubview(goal)
		raised = RaisedHeader(frame:frame)
		self.addSubview(raised)
		days = DaysHeader(frame: frame)
		self.addSubview(days)
		support = SupportHeader(frame: frame)
		self.addSubview(support)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

        
}

class CauseHeader: UIView{
	
	var headerLabel: UILabel!
	override init(frame: CGRect){
		super.init(frame: frame)
		headerLabel = UILabel(frame: CGRect(x:0 , y: 0, width: self.frame.width/3 , height: self.frame.height))
		headerLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
		headerLabel.textAlignment = .center
		headerLabel.text = "Cause Name"
		headerLabel.layer.borderColor = UIColor.black.cgColor

		headerLabel.layer.borderWidth = 1
		
		self.addSubview(headerLabel)

	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		print("A Decoder from Cause header Called")
	}
	
}
class GoalHeader: UIView{
	var headerLabel: UILabel!
	override init(frame: CGRect){
		super.init(frame: frame)
		headerLabel = UILabel(frame: CGRect(x:self.frame.width/3 - 1, y: 0, width: self.frame.width/6, height: self.frame.height))
		headerLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
		headerLabel.textAlignment = .center
		headerLabel.text = "Goal"
		headerLabel.layer.borderColor = UIColor.black.cgColor
		headerLabel.layer.borderWidth = 1
		self.addSubview(headerLabel)
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		print("A Decoder from Goal header Called")
	}
}
class RaisedHeader: UIView{
	var headerLabel: UILabel!
	override init(frame: CGRect){
		super.init(frame: frame)
		headerLabel = UILabel(frame: CGRect(x:self.frame.width/2 - 2 , y: 0, width: self.frame.width/6, height: self.frame.height))
		headerLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
		headerLabel.textAlignment = .center
		headerLabel.text = "$\nRaised"
		headerLabel.numberOfLines = 2
		headerLabel.adjustsFontSizeToFitWidth = true
		headerLabel.minimumScaleFactor = 0.1
		headerLabel.layer.borderColor = UIColor.black.cgColor
		headerLabel.layer.borderWidth = 1

		self.addSubview(headerLabel)
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		print("A Decoder from Raised header Called")
	}
}
class DaysHeader: UIView{
	var headerLabel: UILabel!
	override init(frame: CGRect){
		super.init(frame: frame)
		headerLabel = UILabel(frame: CGRect(x:self.frame.width * 2/3 - 3 , y: 0, width: self.frame.width/6, height: self.frame.height))
		headerLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
		headerLabel.textAlignment = .center
		headerLabel.text = "Time\nLeft"
		headerLabel.numberOfLines = 2
		headerLabel.adjustsFontSizeToFitWidth = true
		headerLabel.minimumScaleFactor = 0.1
		headerLabel.layer.borderColor = UIColor.black.cgColor
		headerLabel.layer.borderWidth = 1

		self.addSubview(headerLabel)
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		print("A Decoder from Days header Called")
	}
}
class SupportHeader: UIView{
	var headerLabel: UILabel!
	override init(frame: CGRect){
		super.init(frame: frame)
		headerLabel = UILabel(frame: CGRect(x:self.frame.width * 5/6 - 4, y: 0, width: self.frame.width/6 + 3, height: self.frame.height))
		headerLabel.font = UIFont.boldSystemFont(ofSize: 14.5)
		headerLabel.textAlignment = .center
		headerLabel.text = "My\nSupport"
		headerLabel.numberOfLines = 2
	
		headerLabel.adjustsFontSizeToFitWidth = true
		headerLabel.minimumScaleFactor = 0.1
		headerLabel.layer.borderColor = UIColor.black.cgColor
		headerLabel.layer.borderWidth = 1

		self.addSubview(headerLabel)
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		print("A Decoder from Support header Called")
	}
}

