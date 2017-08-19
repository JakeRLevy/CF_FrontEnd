//
//  BasicTableRow.swift
//  CauseFeedProto2
//
//  Created by Jacob Levy on 8/15/17.
//  Copyright © 2017 Jacob Levy. All rights reserved.
//

import UIKit

class BasicTableRow: UITableViewCell {

	@IBOutlet weak var Causes: UILabel!
	@IBOutlet weak var Goal: UILabel!
	@IBOutlet weak var Raised: UILabel!
	@IBOutlet weak var Days: UILabel!
	@IBOutlet weak var Support: UILabel!
	
	/*init (frame: CGRect, title: String){
		super.init(style: UITableViewCellStyle.default, reuseIdentifier: "Basic")
		Causes = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: self.frame.height - 10))
		Goal = UILabel(frame: CGRect(x: 120, y: 0, width: 50, height: self.frame.height - 10))
		Raised = UILabel(frame: CGRect(x: 170, y: 0, width: 50, height: self.frame.height - 10))
		Days = UILabel(frame: CGRect(x: 220, y: 0, width: 40, height: <#T##CGFloat#>)
	}*/
 
	override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
