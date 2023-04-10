//
//  OrderPreferenceVC.swift
//  SleepWalkCoffee
//
//  Created by 황지현 on 2023/02/20.
//

import UIKit

class OrderPreferenceVC: UIViewController {

    @IBOutlet weak var coffeeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var segnmentOne: UISegmentedControl!
    @IBOutlet weak var segnmentTwo: UISegmentedControl!
    @IBOutlet weak var segnmentThree: UISegmentedControl!
    @IBOutlet weak var segnmentFour: UISegmentedControl!
    @IBOutlet weak var segnmentFive: UISegmentedControl!
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if index < orders.count {
            let order = orders[index]["order"] as? [String: Any]
            nameLabel?.text = order?["name"] as? String
            priceLabel?.text = order?["price"] as? String
            coffeeImageView?.setImageWithURL(url: order?["image"] as? String, placeholder: UIImage(named: "coffee_4"))
            
            if let optionOne = orders[index]["OrderOptionOne"] as? OrderOptionOne {
                segnmentOne.selectedSegmentIndex = optionOne == .ice ? 0 : 1
            }
            if let optionTwo = orders[index]["OrderOptionTwo"] as? OrderOptionTwo {
                if optionTwo == .moreIce {
                    segnmentTwo.selectedSegmentIndex = 0
                } else if optionTwo == .iceCube {
                    segnmentTwo.selectedSegmentIndex = 1
                } else {
                    segnmentTwo.selectedSegmentIndex = 2
                }
            }
            if let optionThree = orders[index]["OrderOptionThree"] as? OrderOptionThree {
                if optionThree == .moreWater {
                    segnmentThree.selectedSegmentIndex = 0
                } else if optionThree == .waterCube {
                    segnmentThree.selectedSegmentIndex = 1
                } else {
                    segnmentThree.selectedSegmentIndex = 2
                }
            }
            if let optionFour = orders[index]["OrderOptionFour"] as? OrderOptionFour {
                segnmentFour.selectedSegmentIndex = optionFour == .addShot ? 0 : 1
            }
            if let optionFive = orders[index]["OrderOptionFive"] as? OrderOptionFive {
                if optionFive == .siropX {
                    segnmentFive.selectedSegmentIndex = 0
                } else if optionFive == .heizlnot {
                    segnmentFive.selectedSegmentIndex = 1
                } else {
                    segnmentFive.selectedSegmentIndex = 2
                }
            }
        }
    }
    
    @IBAction func cartButtonPressed(_ sender: Any) {
        if index < orders.count {
            if segnmentOne.selectedSegmentIndex == 0 {
                orders[index]["OrderOptionOne"] = OrderOptionOne.ice
            } else {
                orders[index]["OrderOptionOne"] = OrderOptionOne.hot
            }
            if segnmentTwo.selectedSegmentIndex == 0 {
                orders[index]["OrderOptionTwo"] = OrderOptionTwo.moreIce
            } else if segnmentTwo.selectedSegmentIndex == 1 {
                orders[index]["OrderOptionTwo"] = OrderOptionTwo.iceCube
            } else {
                orders[index]["OrderOptionTwo"] = OrderOptionTwo.lessIce
            }
            if segnmentThree.selectedSegmentIndex == 0 {
                orders[index]["OrderOptionThree"] = OrderOptionThree.moreWater
            } else if segnmentThree.selectedSegmentIndex == 1 {
                orders[index]["OrderOptionThree"] = OrderOptionThree.waterCube
            } else {
                orders[index]["OrderOptionThree"] = OrderOptionThree.lessWater
            }
            if segnmentFour.selectedSegmentIndex == 0 {
                orders[index]["OrderOptionFour"] = OrderOptionFour.addShot
            } else {
                orders[index]["OrderOptionFour"] = OrderOptionFour.noShot
            }
            if segnmentFive.selectedSegmentIndex == 0 {
                orders[index]["OrderOptionFive"] = OrderOptionFive.siropX
            } else if segnmentFive.selectedSegmentIndex == 1 {
                orders[index]["OrderOptionFive"] = OrderOptionFive.heizlnot
            } else {
                orders[index]["OrderOptionFive"] = OrderOptionFive.vanilla
            }
        }
        navigationController?.popViewController(animated: true)
    }
}

