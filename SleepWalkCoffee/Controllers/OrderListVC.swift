//
//  OrderListVC.swift
//  SleepWalkCoffee
//
//  Created by 황지현 on 2023/01/10.
//

import UIKit
import FirebaseFirestore
import SquareInAppPaymentsSDK

//카드 결제(후배한테 빌린것)
/* struct Constants {

    struct Square {
        static let SQUARE_LOCATION_ID: String = "L7AMX3MDWZZJQ"
        static let APPLICATION_ID: String  = "sandbox-sq0idb-4C0l4DAY0ntLcr7y-z62rw"
        static let ACCESS_TOKEN: String = "EAAAEOlLSlCSYQL88KVM6FU0VCmwYozJbNwv0cNwovFwdilrmSL5orSZmn9cb8MM"
        static let CHARGE_URL: String = "https://connect.squareupsandbox.com/v2/payments"
    }
} */

var orders = [[String: Any]]()
var actualPrice = 0

class OrderListVC: UIViewController {

    @IBOutlet weak var orderTableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var actualPriceLabel: UILabel!
    
    private var coupon: [String: Any]?
    private var total = 0
    private var discount = 0
    private var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderTableView.dataSource = self
        orderTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calculatePrices()
    }
    
    func calculatePrices() {
        total = 0
        discount = 0
        actualPrice = 0
        for order in orders {
            if let coffee = order["order"] as? [String: Any] {
                if let price = coffee["price"] as? String {
                    if let actualPrice = Int(price.replacingOccurrences(of: "₩", with: "")) {
                        total += actualPrice
                    }
                }
            }
            if let optionFour = order["OrderOptionFour"] as? OrderOptionFour {
                if optionFour == .addShot {
                    total += 500
                }
            }
        }
        if let coupon = coupon {
            if let couponPrice = coupon["price"] as? String {
                if let price = Int(couponPrice.replacingOccurrences(of: "₩", with: "")) {
                    discount = price
                }
            }
        }
        actualPrice = total - discount
        discountPriceLabel.text = "₩\(discount)"
        totalPriceLabel.text = "₩\(total)"
        actualPriceLabel.text = "₩\(actualPrice)"
        orderTableView.reloadData()
    }
        
    @IBAction func couponButtonPressed() {
        performSegue(withIdentifier: "GoToCouponsVC", sender: self)
    }
    
    @IBAction func orderButtonPressed() {
        let orderViewController = OrderViewController()
        orderViewController.delegate = self
        let nc = OrderNavigationController(rootViewController: orderViewController)
        nc.modalPresentationStyle = .custom
        nc.transitioningDelegate = self
        present(nc, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CouponsVC {
            vc.delegate = self
        } else if let vc = segue.destination as? OrderPreferenceVC {
            vc.index = selectedIndex
        }
    }
}

extension OrderListVC: OrderViewControllerDelegate {
    func didRequestPayWithCard() {
        dismiss(animated: true) {
            let vc = self.makeCardEntryViewController()
            vc.delegate = self
            let nc = UINavigationController(rootViewController: vc)
            self.present(nc, animated: true, completion: nil)
        }
    }

    private func didChargeSuccessfully() {
        // Let user know that the charge was successful
        let alert = UIAlertController(title: "주문이 완료되었습니다.",
                                      message: "주문이 완료되었습니다.",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension OrderListVC: SQIPCardEntryViewControllerDelegate {
    func cardEntryViewController(_ cardEntryViewController: SQIPCardEntryViewController, didCompleteWith status: SQIPCardEntryCompletionStatus) {
        dismiss(animated: true) {
            switch status {
            case .canceled:
                self.orderButtonPressed()
                break
            case .success:
                self.didChargeSuccessfully()
            }
        }
    }

    func cardEntryViewController(_ cardEntryViewController: SQIPCardEntryViewController, didObtain cardDetails: SQIPCardDetails, completionHandler: @escaping (Error?) -> Void) {
        ChargeApi.processPayment(amount: actualPrice,  nonce: cardDetails.nonce) { transactionID, errorDescription in
            if let errorDescription = errorDescription {
                self.showAlert(message: errorDescription)
                let error = NSError(domain: "com.example.supercookie", code: 0, userInfo:[NSLocalizedDescriptionKey : errorDescription])
                return completionHandler(error)
            }
            if transactionID == "success" {
                self.makeOrderAndReceipt()
            }
            return completionHandler(nil)
        }
    }
    
    func makeOrderAndReceipt() {
        
        let user = UserDefaults.currentUser
        let userId = user?.id ?? ""
        let userName = user?.name ?? ""
        let phone = user?.phone ?? ""
        let isCouponUsed = coupon == nil ? false : true
        for order in orders {
            let coffee = order["order"] as? [String: Any]
            let name = coffee?["name"] as? String ?? ""
            let price = coffee?["price"] as? String ?? ""
            let branch = coffee?["branch"] as? String ?? ""
            let discount = coffee?["discount"] as? String ?? ""
            let image = coffee?["image"] as? String ?? ""
            let time = Timestamp(date: Date())
            let optionOne = order["OrderOptionOne"] as? OrderOptionOne ?? OrderOptionOne.ice
            let optionTwo = order["OrderOptionTwo"] as? OrderOptionTwo ?? OrderOptionTwo.moreIce
            let optionThree = order["OrderOptionThree"] as? OrderOptionThree ?? OrderOptionThree.moreWater
            let optionFour = order["OrderOptionFour"] as? OrderOptionFour ?? OrderOptionFour.addShot
            let optionFive = order["OrderOptionFive"] as? OrderOptionFive ?? OrderOptionFive.siropX
            Firestore.firestore().collection("receipts").addDocument(data: [
                "userId": userId,
                "userName": userName,
                "phone": phone,
                "isCouponUsed": isCouponUsed,
                "name": name,
                "price": price,
                "discount": discount,
                "image": image,
                "time": time,
                "OrderOptionOne": optionOne.rawValue,
                "OrderOptionTwo": optionTwo.rawValue,
                "OrderOptionThree": optionThree.rawValue,
                "OrderOptionFour": optionFour.rawValue,
                "OrderOptionFive": optionFive.rawValue
            ]) { error in
                if let error = error {
                    self.showAlert(message: error.localizedDescription)
                }
            }
            Firestore.firestore().collection("orders").addDocument(data: [
                "userId": userId,
                "userName": userName,
                "phone": phone,
                "isCouponUsed": isCouponUsed,
                "name": name,
                "price": price,
                "discount": discount,
                "image": image,
                "time": time,
                "OrderOptionOne": optionOne.rawValue,
                "OrderOptionTwo": optionTwo.rawValue,
                "OrderOptionThree": optionThree.rawValue,
                "OrderOptionFour": optionFour.rawValue,
                "OrderOptionFive": optionFive.rawValue
            ]) { error in
                if let error = error {
                    self.showAlert(message: error.localizedDescription)
                }
            }
        }
        if let coupon = coupon, let documentId = coupon["documentId"] as? String {
            Firestore.firestore().collection("coupons").document(documentId).delete()
        }
        dismiss(animated: true)
        navigationController?.popToRootViewController(animated: true)
        orders.removeAll()
    }
}

/*인앱 결제
class ChargeApi {
    static public func processPayment(amount: Int, nonce: String, completion: @escaping (String?, String?) -> Void) {
        let url = URL(string: Constants.Square.CHARGE_URL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let json = ["source_id": nonce, "idempotency_key": UUID().uuidString, "autocomplete": true, "amount_money": ["amount": amount, "currency": "USD"]] as [String : Any]
        let httpBody = try? JSONSerialization.data(withJSONObject: json, options: [])
        request.addValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(Constants.Square.ACCESS_TOKEN)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = httpBody
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error as NSError? {
                if error.domain == NSURLErrorDomain {
                    DispatchQueue.main.async {
                        completion("", "Could not contact host")
                    }
                } else {
                    DispatchQueue.main.async {
                        completion("", "Something went wrong")
                    }
                }
            } else if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    print("RESPONSE: ", json)
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                        DispatchQueue.main.async {
                            completion("success", nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion("", json["errorMessage"] as? String)
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion("", "Failure")
                    }
                }
            }
        }.resume()
    }
} 인앱결제 */


extension OrderListVC {
    /* func makeCardEntryViewController() -> SQIPCardEntryViewController {
        let theme = SQIPTheme()
        theme.errorColor = .red
        theme.tintColor = UIColor.black
        theme.keyboardAppearance = .dark
        theme.saveButtonTitle = "Pay"
        return SQIPCardEntryViewController(theme: theme)
    } */
}

extension OrderListVC: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSheetPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension OrderListVC: CouponsVCDelegate {
    
    func didSelectCoupon(coupon: [String : Any]) {
        self.coupon = coupon
        calculatePrices()
    }
}

extension OrderListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as? OrderCell {
            var options = ""
            let order = orders[indexPath.row]
            let coffee = order["order"] as? [String: Any]
            cell.order = coffee
            if let optionOne = order["OrderOptionOne"] as? OrderOptionOne {
                options = optionOne.rawValue
            }
            if let optionTwo = order["OrderOptionTwo"] as? OrderOptionTwo {
                options = options + "/" + optionTwo.rawValue
            }
            if let optionThree = order["OrderOptionThree"] as? OrderOptionThree {
                options = options + "/" + optionThree.rawValue
            }
            if let optionFour = order["OrderOptionFour"] as? OrderOptionFour {
                options = options + "/" + optionFour.rawValue
            }
            if let optionFive = order["OrderOptionFive"] as? OrderOptionFive {
                options = options + "/" + optionFive.rawValue
            }
            cell.priceLabel.text = options
            return cell
        }
        return UITableViewCell()
    }
}

extension OrderListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "GoToOrderPreferenceVC", sender: self)
    }
}

