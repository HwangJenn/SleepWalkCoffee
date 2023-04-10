//
//  LoginVC.swift
//  SleepWalkCoffee
//
//  Created by 황지현 on 2023/03/09.
//

import UIKit
import FirebaseFirestore

class LoginVC: UIViewController {

    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    private var documents: [QueryDocumentSnapshot]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonPressed() {
        if idField.text?.count ?? 0 >= 6 && passwordField.text?.count ?? 0 >= 6 {
            if documents != nil {
                login()
                return
            }
            Firestore.firestore().collection("users").getDocuments { querySnapshot, error in
                if let error = error {
                    self.showAlert(message: error.localizedDescription)
                } else {
                    if let documents = querySnapshot?.documents {
                        self.documents = documents
                    }
                    self.login()
                }
            }
        } else {
            self.showAlert(message: "6자리이상 입력해주세요.")
        }
    }
    
    private func login() {
        if let documents = documents {
            for document in documents {
                let userData = document.data()
                if let id = userData["id"] as? String,
                    let name = userData["name"] as? String,
                   let phone = userData["phone"] as? String,
                   let rawPassword = userData["password"] as? String, let password = UserDefaults.standard.decrypt(rawPassword) {
                    if id == self.idField.text && password == self.passwordField.text {
                        let user = SleepUser(documentId: document.documentID, id: id, name: name, phone: phone, password: rawPassword)
                        UserDefaults.currentUser = user
                        UserDefaults.standard.setCredentials(id: id, encryptedPassword: rawPassword)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let mainNC = storyboard.instantiateViewController(withIdentifier: "MainNC")
                        UIApplication.shared.windows.first?.rootViewController = mainNC
                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                        break
                    }
                }
            }
        }
        self.showAlert(message: "존재하지 않습니다")
    }
    
    @IBAction func kakaoButtonPressed() {
        self.showAlert(message: "Kakao Login")
    }
    @IBAction func NaverButtonPressed() {
        self.showAlert(message: "Naver Login")
    }
    
    @IBAction func registerButtonPressed() {
        self.performSegue(withIdentifier: "GoToRegisterVC", sender: self)
    }
}
