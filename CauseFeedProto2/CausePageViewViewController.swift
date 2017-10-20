//
//  CausePageViewViewController.swift
//  CauseFeedProto2
//
//  Created by Jacob Levy on 10/18/17.
//  Copyright © 2017 Jacob Levy. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class CausePageViewViewController: UIViewController {

	@IBOutlet weak var ContributorPic: UIImageView!
	@IBOutlet weak var ContributorName: UILabel!
	@IBOutlet weak var ContributorLoc: UILabel!
	@IBOutlet weak var CauseOrg: UILabel!
	@IBOutlet weak var CauseLoc: UILabel!
	@IBOutlet weak var CauseIMG: UIImageView!
	@IBOutlet weak var displayTitle: UILabel!
	@IBOutlet weak var displayPercent: UILabel!
	@IBOutlet weak var DisplayRaised: UILabel!
	@IBOutlet weak var displayBackers: UILabel!
	@IBOutlet weak var displayDays: UILabel!
	@IBOutlet weak var displayProgress: UIProgressView!
	@IBOutlet weak var displayDescr: UILabel!

	let storage = Storage.storage()
	var percent: Float = Float()
	var causeKey: String = ""
	var currentTitle: String = ""
	var currentDescription: String = ""
	var goal: Float = Float()
	var raised: Float = Float()
	override func viewWillAppear(_ animated: Bool) {
		let storageRef = storage.reference()
		let imgRef = storageRef.child("imgs").child("causes")
		displayDescr.lineBreakMode = NSLineBreakMode.byWordWrapping
		displayDescr.numberOfLines = 0
		
		displayTitle.text = currentTitle
		displayDescr.text = currentDescription
		DisplayRaised.text = "$\(raised)"
	 percent  = raised/goal * 100
		displayPercent.text = String(format: "%.2f", percent) + "%"
		
		
	}
    override func viewDidLoad() {
        super.viewDidLoad()
		print("\(self.causeKey)")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	private func downloadPhotofor(causeKey: String, completion: @escaping (_ error: Error?) -> ()){
		let storageRef = storage.reference()
		let imgRef = storageRef.child("imgs").child("causes")

		let localRef = imgRef.child("causes").child(causeKey).child(causeKey + ".jpg")
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
