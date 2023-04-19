//
//  EventPopupVC.swift
//  SleepWalkCoffee
//
//  Created by 황지현 on 2023/03/11.
//

import UIKit
import FirebaseFirestore

class EventPopupVC: UIViewController {

    @IBOutlet weak var menuTableView: UITableView!
    private var menus = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTableView.dataSource = self
        Firestore.firestore().collection("events").getDocuments { querySnapshot, error in
            if let error = error {
                print("에러: \(error)")
            } else {
                if let documents = querySnapshot?.documents {
                    self.menus.removeAll()
                    for document in documents {
                        self.menus.append(document.data())
                    }
                    self.menuTableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func closeButtonPressed() {
        dismiss(animated: true)
    }
    
    @IBAction func dontShowTodayButtonPressed() {
        UserDefaults.standard.setCurrentCheckDate()
        dismiss(animated: true)
    }
}

extension EventPopupVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as? OrderCell {
            cell.order = menus[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}
