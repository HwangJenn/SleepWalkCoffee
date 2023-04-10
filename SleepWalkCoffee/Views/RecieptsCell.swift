//
//  RecieptsCell.swift
//  SleepWalkCoffee
//
//  Created by 황지현 on 2023/02/18.
//

import UIKit
import FirebaseFirestore

class RecieptsCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var receipt: [String: Any]! {
        didSet {
            nameLabel.text = receipt["name"] as? String
            timeLabel.text = ""
            if let time = receipt["time"] as? Timestamp {
                timeLabel.text = Int(time.seconds).getTime()
            }
            priceLabel.text = receipt["price"] as? String
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

