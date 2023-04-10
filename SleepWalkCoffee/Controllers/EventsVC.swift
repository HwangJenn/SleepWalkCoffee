//
//  EventsVC.swift
//  SleepWalkCoffee
//
//  Created by 황지현 on 2023/02/09.
//

import UIKit
import FirebaseFirestore

class EventsVC: UIViewController {

    @IBOutlet weak var eventTableView: UITableView!
    
    private var events = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTableView.dataSource = self
        eventTableView.delegate = self
        Firestore.firestore().collection("events").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                if let documents = querySnapshot?.documents {
                    self.events.removeAll()
                    for document in documents {
                        self.events.append(document.data())
                    }
                }
                self.eventTableView.reloadData()
            }
        }
    }
}

extension EventsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "EventsCell", for: indexPath) as? EventsCell {
            cell.event = events[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}

extension EventsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
