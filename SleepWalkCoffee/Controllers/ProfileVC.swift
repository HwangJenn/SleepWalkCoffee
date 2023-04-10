//
//  ProfileVC.swift
//  SleepWalkCoffee
//
//  Created by 황지현 on 2023/02/09.
//

import UIKit
import FirebaseFirestore

class ProfileVC: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var otpField: UITextField!
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    
    private var documents: [QueryDocumentSnapshot]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.idField.text = UserDefaults.currentUser?.id
        self.nameField.text = UserDefaults.currentUser?.name
        self.phoneField.text = UserDefaults.currentUser?.phone
    }
    
    @IBAction func sendVerifyButtonPressed() {
        self.showAlert(message: "인증번호를 확인해주세요")
    }
    
    @IBAction func registerAccountButtonPressed() {
        if nameField.text?.count ?? 0 <= 0 {
            showAlert(message: "이름을 입력해주세요")
            return
        }
        phoneField.text = phoneField.text?.replacingOccurrences(of: "+82", with: "0")
        if phoneField.text?.validatePhoneNumber() == false {
            showAlert(message: "전화번호를 입력해주세요")
            return
        }
        if idField.text?.count ?? 0 < 6 || passwordField.text?.count ?? 0 < 6 || repeatPasswordField.text?.count ?? 0 < 6 {
            showAlert(message: "6자리이상 입력해주세요")
            return
        }
        if passwordField.text != repeatPasswordField.text {
            showAlert(message: "비밀번호가 일치하지 않습니다!")
            return
        }
        if idField.text == UserDefaults.currentUser?.id {
            updateUser()
        } else {
            getUsers()
        }
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
                        self.showAlert(message: "중복 ID가 있습니다")
                        return
                    }
                }
            }
        }
        updateUser()
    }
    
    private func updateUser() {
        if let id = idField.text, let name = nameField.text, let phone = phoneField.text, let passwrod = passwordField.text, let rawPassword = UserDefaults.standard.encrypt(passwrod) {
            Firestore.firestore().collection("users").document(UserDefaults.currentUser?.documentId ?? "").updateData([
                "id": id,
                "name": name,
                "password": rawPassword,
                "phone": phone
            ]) { error in
                if let error = error {
                    self.showAlert(message: error.localizedDescription)
                } else {
                    UserDefaults.currentUser = SleepUser(documentId: UserDefaults.currentUser?.documentId, id: id, name: name, phone: phone, password: rawPassword)
                    UserDefaults.standard.setCredentials(id: id, encryptedPassword: rawPassword)
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
}
