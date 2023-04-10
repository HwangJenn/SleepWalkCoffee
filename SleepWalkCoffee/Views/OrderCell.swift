//
//  OrderCell.swift
//  SleepWalkCoffee
//
//  Created by 황지현 on 2023/03/23.
//

import UIKit
import Kingfisher

class OrderCell: UITableViewCell {

    @IBOutlet weak var orderImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var order: [String: Any]! {
        didSet {
            nameLabel?.text = order["name"] as? String
            priceLabel?.text = order["price"] as? String
            orderImageView?.setImageWithURL(url: order["image"] as? String, placeholder: UIImage(named: "coffee_4"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
