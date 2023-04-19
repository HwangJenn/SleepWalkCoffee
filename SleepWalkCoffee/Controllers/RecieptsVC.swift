//
//  RecieptsVC.swift
//  SleepWalkCoffee
//
//  Created by 황지현 on 2023/01/29.
//

import UIKit
import FirebaseFirestore

class RecieptsVC: UIViewController {

    @IBOutlet weak var recieptTableView: UITableView!
    private var reciepts = [[String: Any]]()
    private var receipt: [String: Any]?
    override func viewDidLoad() {
        super.viewDidLoad()
        recieptTableView.dataSource = self
        recieptTableView.delegate = self
        Firestore.firestore().collection("receipts").getDocuments { querySnapshot, error in
            if let error = error {
                print("에러: \(error)")
            } else {
                if let documents = querySnapshot?.documents {
                    self.reciepts.removeAll()
                    for document in documents {
                        let id = document.data()["userId"] as? String
                        if id == UserDefaults.currentUser?.id {
                            self.reciepts.append(document.data())
                        }
                    }
                }
                self.recieptTableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ReceiptInfoVC {
            vc.receipt = receipt
        }
    }
}

extension RecieptsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reciepts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RecieptsCell", for: indexPath) as? RecieptsCell {
            cell.receipt = reciepts[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}

extension RecieptsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        receipt = reciepts[indexPath.row]
        self.performSegue(withIdentifier: "GoToReceiptInfoVC", sender: self)
    }
}
