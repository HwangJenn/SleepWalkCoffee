//
//  OrderViewController.swift
//  SleepWalkCoffee
//
//  Created by 황지현 on 2023/01/20.
//

import Accessibility
/* 인앱카드 결제부분 대신 결제 시스템 api, 카카오페이, 네이버페이 대체 예정.
import UIKit
import SquareInAppPaymentsSDK 후배한테 빌린 인앱 카드결제

protocol OrderViewControllerDelegate: AnyObject {
    func didRequestPayWithCard()
}

class OrderViewController : UIViewController {
    weak var delegate: OrderViewControllerDelegate?
    override func loadView() {
        let orderView = OrderView()
        self.view = orderView

        orderView.addCardButton.addTarget(self, action: #selector(didTapPayButton), for: .touchUpInside)
        orderView.closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapPayButton() {
        delegate?.didRequestPayWithCard()
    }
}

extension OrderViewController: HalfSheetPresentationControllerHeightProtocol {
    var halfsheetHeight: CGFloat {
        return (view as! OrderView).stackView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).height
    }
}

class OrderNavigationController : UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBarHidden(true, animated: false)
    }
}

extension OrderNavigationController: HalfSheetPresentationControllerHeightProtocol {
    var halfsheetHeight: CGFloat {
        return ((viewControllers.last as? HalfSheetPresentationControllerHeightProtocol)?.halfsheetHeight ?? 0.0) + navigationBar.bounds.height
    }
}
*/
