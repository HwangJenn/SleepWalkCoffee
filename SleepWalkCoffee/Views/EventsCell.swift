//
//  EventsCell.swift
//  SleepWalkCoffee
//
//  Created by 황지현 on 2023/01/09.
//

import UIKit
import FirebaseFirestore

class EventsCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var event: [String: Any]! {
        didSet {
            nameLabel.text = event["name"] as? String
            timeLabel.text = ""
            if let time = event["time"] as? Timestamp {
                timeLabel.text = Int(time.seconds).getTime()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

