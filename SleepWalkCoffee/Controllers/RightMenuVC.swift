//
//  RightMenuVC.swift
//  SleepWalkCoffee
//
//  Created by 황지현 on 2023/02/10.
//

import UIKit
import FirebaseFirestore

class RightMenuVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var notifications = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        Firestore.firestore().collection("Alarm").getDocuments { querySnapshot, error in
            if let error = error {
                print("에러: \(error)")
            } else {
                self.notifications.removeAll()
                for document in querySnapshot!.documents {
                    self.notifications.append(document.data())
                }
                self.tableView.reloadData()
            }
        }
    }
}

extension RightMenuVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as? NotificationCell {
            cell.notificationLabel.text = notifications[indexPath.row]["body"] as? String
            return cell
        }
        return UITableViewCell()
    }
}

