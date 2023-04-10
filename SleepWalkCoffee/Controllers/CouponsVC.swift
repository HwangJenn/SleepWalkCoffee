//
//  CouponsVC.swift
//  SleepWalkCoffee
//
//  Created by 황지현 on 2023/02/10.
//

import UIKit
import FirebaseFirestore

protocol CouponsVCDelegate: AnyObject {
    func didSelectCoupon(coupon: [String: Any])
}

class CouponsVC: UIViewController {

    @IBOutlet weak var couponsCollectionView: UICollectionView!
    @IBOutlet weak var couponCountLabel: UILabel!
    
    private var coupons = [[String: Any]]()
    weak var delegate: CouponsVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        couponsCollectionView.dataSource = self
        couponsCollectionView.delegate = self
        Firestore.firestore().collection("coupons").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                if let documents = querySnapshot?.documents {
                    self.coupons.removeAll()
                    for document in documents {
                        if let userId = UserDefaults.currentUser?.id {
                            if document.data()["userId"] as? String == userId {
                                var couponData = document.data()
                                couponData["documentId"] = document.documentID
                                self.coupons.append(couponData)
                            }
                        }
                    }
                }
                self.couponCountLabel.text = "현재 \(self.coupons.count)개의 쿠폰이 있습니다."
                self.couponsCollectionView.reloadData()
            }
        }
    }
    
    @IBAction func homeButtonPressed() {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension CouponsVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coupons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CouponCell", for: indexPath)
        return cell
    }
}

extension CouponsVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if delegate != nil {
            delegate?.didSelectCoupon(coupon: coupons[indexPath.item])
            navigationController?.popViewController(animated: true)
        }
    }
}

extension CouponsVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.width - 48) / 2
        let height = width / 106 * 68
        return CGSize(width: width, height: height)
    }
}
