//
//  RegisterVC.swift
//  SleepWalkCoffee
//
//  Created by 황지현 on 2023/02/15.
//

import UIKit
import FirebaseFirestore
import Accessibility

class RegisterVC: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var otpField: UITextField!
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    private var documents: [QueryDocumentSnapshot]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sendVerifyButtonPressed() {
        showAlert(message: "인증번호를 확인해주세요")
    }
    
    @IBAction func registerAccountButtonPressed() {
        if nameField.text?.count ?? 0 <= 0 {
            self.showAlert(message: "이름을 입력해주세요")
            return
        }
        phoneField.text = phoneField.text?.replacingOccurrences(of: "+82", with: "0")
        if phoneField.text?.validatePhoneNumber() == false {
            self.showAlert(message: "올바른 전화번호를 입력해주세요")
            return
        }
        if idField.text?.count ?? 0 < 6 || passwordField.text?.count ?? 0 < 6 {
            self.showAlert(message: "6자리이상 입력해주세요")
            return
        }
        getUsers()
    }
    
    private func getUsers() {
        if documents != nil {
            validateUser()
            return
        }
        Firestore.firestore().collection("users").getDocuments { querySnapshot, error in
            if let error = error {
                self.showAlert(message: error.localizedDescription)
            } else {
                if let documents = querySnapshot?.documents {
                    self.documents = documents
                }
                self.validateUser()
            }
        }
    }
    
    private func validateUser() {
        if let documents = documents {
            for document in documents {
                let userData = document.data()
                if let id = userData["id"] as? String {
                    if id == idField.text {
                        showAlert(message: "중복 ID가 있습니다.")
                        return
                    }
                }
            }
        }
        createAccount()
    }
    
    private func createAccount() {
        if let id = idField.text, let name = nameField.text, let phone = phoneField.text, let passwrod = passwordField.text, let rawPassword = UserDefaults.standard.encrypt(passwrod) {
            Firestore.firestore().collection("users").addDocument(data: [
                "id": id,
                "name": name,
                "password": rawPassword,
                "phone": phone
            ]) { error in
                if let error = error {
                    self.showAlert(message: error.localizedDescription)
                } else {
                    UserDefaults.standard.setCredentials(id: id, encryptedPassword: rawPassword)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainNC = storyboard.instantiateViewController(withIdentifier: "MainNC")
                    UIApplication.shared.windows.first?.rootViewController = mainNC
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                }
            }
        }
    }
}
