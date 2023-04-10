//
//  LeftMenuVC.swift
//  SleepWalkCoffee
//
//  Created by 황지현 on 2023/03/09.
//

import UIKit

class LeftMenuVC: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameLabel.text = "\(UserDefaults.currentUser?.name ?? "") 님!!!"
    }
    
    @IBAction func menuButtonPressed() {
        performSegue(withIdentifier: "GoToEventPopupVC", sender: self)
    }
    
    @IBAction func orderButtonPressed() {
        performSegue(withIdentifier: "GoToOrderVC", sender: self)
    }
    
    @IBAction func eventsButtonPressed() {
        performSegue(withIdentifier: "GoToEventsVC", sender: self)
    }
    
    @IBAction func recieptsButtonPressed() {
        performSegue(withIdentifier: "GoToReceiptsVC", sender: self)
    }
    
    @IBAction func profileButtonPressed() {
        performSegue(withIdentifier: "GoToProfileVC", sender: self)
    }
}
