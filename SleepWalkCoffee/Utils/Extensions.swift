//
//  Extensions.swift
//  SleepWalkCoffee
//
//  Created by 황지현 on 2023/03/25.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImageWithURL(url: String?, placeholder: UIImage? = nil) {
        self.image = placeholder
        if let url = url {
            if let urlImage = URL(string: url) {
                self.kf.indicatorType = .activity
                self.kf.setImage(
                    with: urlImage,
                    placeholder: placeholder,
                    options: [
                        .transition(.fade(0.7))
                    ]
                )
            }
        }
    }
}

extension StringProtocol {
    var hexaData: Data { .init(hexa) }
    var hexaBytes: [UInt8] { .init(hexa) }
    private var hexa: UnfoldSequence<UInt8, Index> {
        sequence(state: startIndex) { startIndex in
            guard startIndex < self.endIndex else { return nil }
            let endIndex = self.index(startIndex, offsetBy: 2, limitedBy: self.endIndex) ?? self.endIndex
            defer { startIndex = endIndex }
            return UInt8(self[startIndex..<endIndex], radix: 16)
        }
    }
    
    func validatePhoneNumber() -> Bool {
        if self.count != 11 {
            return false
        }
        let PHONE_REGEX = "^01(?:0|1|[6-9])(?:\\d{3}|\\d{4})\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = phoneTest.evaluate(with: self)
        return result
    }
}

extension UserDefaults {
    
    enum UserDefaultsKey: String {
        case userId
        case userPassword
        case currentCheckDate
    }
    
    static let aesKey = "2052582549271212117803095174500482155784833128744975647028929832"
    static let easIV = "41276545670569227382240455726846"
    static var currentUser: SleepUser?
    
    func isUserLoggedIn() -> Bool {
        if let _ = value(forKey: UserDefaultsKey.userId.rawValue) as? String,
            let rawPassword = value(forKey: UserDefaultsKey.userPassword.rawValue) as? String,
           let _ = UserDefaults.standard.decrypt(rawPassword) {
            return true
        }
        return false
    }
    
    func userId() -> String? {
        return value(forKey: UserDefaultsKey.userId.rawValue) as? String
    }
    
    func password() -> String? {
        if let rawPassword = value(forKey: UserDefaultsKey.userPassword.rawValue) as? String,
           let password = UserDefaults.standard.decrypt(rawPassword) {
            return password
        }
        return nil
    }
    
    func setCredentials(id: String, encryptedPassword: String) {
        setValue(id, forKey: UserDefaultsKey.userId.rawValue)
        setValue(encryptedPassword, forKey: UserDefaultsKey.userPassword.rawValue)
        synchronize()
    }
    
    func setCurrentCheckDate() {
        let now = Date().timeIntervalSince1970 / 86400
        setValue(now, forKey: UserDefaultsKey.currentCheckDate.rawValue)
        synchronize()
    }
    
    func shouldShowEventPopup() -> Bool {
        if let previous = value(forKey: UserDefaultsKey.currentCheckDate.rawValue) as? Double {
            let now = Int(Date().timeIntervalSince1970 / 86400)
            if Int(previous) == now {
                return false
            }
        }
        return true
    }
    
    func encrypt(_ stringValue: String) -> String? {
        do {
            if let digest = stringValue.data(using: .utf8) {
                let aes = try AES256(key: UserDefaults.aesKey.hexaData, iv: UserDefaults.easIV.hexaData)
                let encrypted = try aes.encrypt(digest)
                return encrypted.hexString
            }
            return nil
        } catch {
            return nil
        }
    }
    
    func decrypt(_ encrypted: String) -> String? {
        do {
            let encryptedData = encrypted.hexaData
            let aes = try AES256(key: UserDefaults.aesKey.hexaData, iv: UserDefaults.easIV.hexaData)
            let decrypted = try aes.decrypt(encryptedData)
            return String(decoding: decrypted, as: UTF8.self)
        } catch {
            return nil
        }
    }
    
    func removeAll() {
        self.dictionaryRepresentation().forEach { dic in
            let key = dic.key
            self.removeObject(forKey: key)
        }
        self.synchronize()
    }
}


struct SleepUser {
    let documentId: String?
    let id: String?
    let name: String?
    let phone: String?
    let password: String?
    init(documentId: String? = nil, id: String? = nil, name: String? = nil, phone: String? = nil, password: String? = nil) {
        self.documentId = documentId
        self.id = id
        self.name = name
        self.phone = phone
        self.password = password
    }
}

extension UIViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
           
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension Data {
    var hexString: String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

extension Int {
    
    func getTime() -> String {
        let timeformat = DateFormatter()
        timeformat.timeZone = .current
        timeformat.dateFormat = "yyyy.MM.dd"
        let stringTime = timeformat.string(from: Date(timeIntervalSince1970: TimeInterval(self)))
        return stringTime
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

    func pinToTop(ofView view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.topAnchor.constraint(equalTo: view.topAnchor),
        ])
    }
}
