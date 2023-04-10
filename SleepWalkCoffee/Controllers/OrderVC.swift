//
//  OrderVC.swift
//  SleepWalkCoffee
//
//  Created by 황지현 on 2023/02/10.
//

import UIKit
import FirebaseFirestore

class OrderVC: UIViewController {

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var coffeeTableView: UITableView!
    @IBOutlet weak var beverageTableView: UITableView!
    @IBOutlet weak var beverageStackView: UIStackView!
    
    private var coffees = [[String: Any]]()
    private var beverages = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coffeeTableView.dataSource = self
        coffeeTableView.delegate = self
        beverageTableView.dataSource = self
        beverageTableView.delegate = self
        
        Firestore.firestore().collection("coffees").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                if let documents = querySnapshot?.documents {
                    self.coffees.removeAll()
                    for document in documents {
                        self.coffees.append(document.data())
                    }
                    self.coffeeTableView.reloadData()
                }
            }
        }
        Firestore.firestore().collection("beverages").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                if let documents = querySnapshot?.documents {
                    self.beverages.removeAll()
                    for document in documents {
                        self.beverages.append(document.data())
                    }
                    self.beverageTableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func cartButtonPressed() {
        performSegue(withIdentifier: "GoToOrderListVC", sender: self)
    }
    
    @IBAction func segmentControlChanged(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0 {
            mainScrollView.scrollRectToVisible(coffeeTableView.frame, animated: true)
        } else {
            mainScrollView.scrollRectToVisible(beverageStackView.frame, animated: true)
        }
    }
}

extension OrderVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == coffeeTableView {
            return coffees.count
        } else if tableView == beverageTableView {
            return beverages.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == coffeeTableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as? OrderCell {
                cell.order = coffees[indexPath.row]
                return cell
            }
        } else if tableView == beverageTableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as? OrderCell {
                cell.order = beverages[indexPath.row]
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension OrderVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var order = [String: Any]()
        if tableView == coffeeTableView {
            order["order"] = coffees[indexPath.row]
        } else {
            order["order"] = beverages[indexPath.row]
        }
        order["OrderOptionOne"] = OrderOptionOne.ice
        order["OrderOptionTwo"] = OrderOptionTwo.moreIce
        order["OrderOptionThree"] = OrderOptionThree.moreWater
        order["OrderOptionFour"] = OrderOptionFour.addShot
        order["OrderOptionFive"] = OrderOptionFive.siropX
        orders.append(order)
        performSegue(withIdentifier: "GoToOrderListVC", sender: self)
    }
}

enum OrderOptionOne: String {
    case ice = "ICE"
    case hot = "HOT"
}

enum OrderOptionTwo: String {
    case moreIce = "얼음많이"
    case iceCube = "얼음보통"
    case lessIce = "얼음적게"
}

enum OrderOptionThree: String {
    case moreWater = "물 많이"
    case waterCube = "물 보통"
    case lessWater = "물 적게"
}

enum OrderOptionFour: String {
    case addShot = "샷추가(+500)"
    case noShot = "안함"
}

enum OrderOptionFive: String {
    case siropX = "시럽X"
    case heizlnot = "헤이즐넛"
    case vanilla = "바닐라"
}

