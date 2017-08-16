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
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
