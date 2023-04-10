//
//  MainVC.swift
//  SleepWalkCoffee
//
//  Created by 황지현 on 2023/01/01.
//

import UIKit
import SideMenu
import FirebaseFirestore

class MainVC: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    private var shouldShowPopup = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = ""
        getUser()
    }
    
    private func getUser() {
        Firestore.firestore().collection("users").getDocuments { querySnapshot, error in
            if let error = error {
                self.showAlert(message: error.localizedDescription)
            } else {
                if let documents = querySnapshot?.documents {
                    for document in documents {
                        let userData = document.data()
                        print("USER DATA: ", document.documentID)
                        if let id = userData["id"] as? String,
                            let name = userData["name"] as? String,
                           let phone = userData["phone"] as? String,
                           let rawPassword = userData["password"] as? String, let password = UserDefaults.standard.decrypt(rawPassword) {
                            if let userId = UserDefaults.standard.userId(), let userPassword = UserDefaults.standard.password() {
                                if userId == id && userPassword == password {
                                    let user = SleepUser(documentId: document.documentID, id: id, name: name, phone: phone, password: rawPassword)
                                    print("CURRENT USER: ", user)
                                    UserDefaults.currentUser = user
                                    self.nameLabel.text = "반갑습니다!!! \(name) 님!!!"
                                    self.setupSideMenu()
                                    self.updateMenus()
                                    break
                                }
                            }
                        }
                    }
                }
                if UserDefaults.currentUser == nil {
                    UserDefaults.standard.removeAll()
                    let storyboard = UIStoryboard(name: "Login", bundle: nil)
                    let LoginNC = storyboard.instantiateViewController(withIdentifier: "LoginNC")
                    UIApplication.shared.windows.first?.rootViewController = LoginNC
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                }
            }
            self.setupSideMenu()
            self.updateMenus()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldShowPopup && UserDefaults.standard.shouldShowEventPopup() {
            shouldShowPopup = false
            performSegue(withIdentifier: "GoToEventPopupVC", sender: self)
        }
        self.nameLabel.text = "반갑습니다!!! \(UserDefaults.currentUser?.name ?? "") 님!!!"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sideMenuNavigationController = segue.destination as? SideMenuNavigationController else { return }
        sideMenuNavigationController.settings = makeSettings()
    }
    
    private func updateMenus() {
        let settings = makeSettings()
        SideMenuManager.default.leftMenuNavigationController?.settings = settings
        SideMenuManager.default.rightMenuNavigationController?.settings = settings
    }
    
    private func setupSideMenu() {
        SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNC") as? SideMenuNavigationController
        SideMenuManager.default.rightMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "RightMenuNC") as? SideMenuNavigationController
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
    }
    
    private func makeSettings() -> SideMenuSettings {
        let presentationStyle = SideMenuPresentationStyle.menuSlideIn
        presentationStyle.onTopShadowOpacity = 0.08
        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.menuWidth = view.frame.width * 0.8
        settings.blurEffectStyle = .regular
        return settings
    }
    
    @IBAction func orderButtonPressed() {
        performSegue(withIdentifier: "GoToOrderVC", sender: self)
    }
    
    @IBAction func stampButtonPressed() {
        performSegue(withIdentifier: "GoToStampVC", sender: self)
    }
    
    @IBAction func eventsButtonPressed() {
        performSegue(withIdentifier: "GoToEventsVC", sender: self)
    }
    
    @IBAction func receiptsButtonPressed() {
        performSegue(withIdentifier: "GoToReceiptsVC", sender: self)
    }
}
