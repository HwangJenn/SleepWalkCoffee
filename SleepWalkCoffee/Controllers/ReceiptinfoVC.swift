//
//  ReceiptinfoVC.swift
//  SleepWalkCoffee
//
//  Created by 황지현 on 2023/02/14.
//

import UIKit
import FirebaseFirestore

class ReceiptInfoVC: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var branchLabel: UILabel!
    
    var receipt: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = receipt?["name"] as? String
        timeLabel.text = ""
        if let time = receipt?["time"] as? Timestamp {
            timeLabel.text = Int(time.seconds).getTime()
        }
        priceLabel.text = receipt?["price"] as? String
    }
}
