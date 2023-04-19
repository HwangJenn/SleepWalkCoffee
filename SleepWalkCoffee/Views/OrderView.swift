//
//  OrderView.swift
//  SleepWalkCoffee
//
//  Created by 황지현 on 2023/03/19.
//

import UIKit

class OrderView : UIView {
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 30
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)

        return view
    }()

  //  lazy var addCardButton = ActionButton(backgroundColor: UIColor.black, title: "신용 카드 결제", image: nil) //인앱?
    private lazy var headerView = HeaderView(title: "주문하기")

    var closeButton: UIButton {
        return headerView.closeButton
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor.white
        stackView.addArrangedSubview(headerView)
        stackView.addArrangedSubview(TableRowView(heading: "Total", title: "₩\(actualPrice)", subtitle:""))
       // stackView.addArrangedSubview(addCardButton)
        addSubview(stackView)
        stackView.pinToTop(ofView: self)
    }
}

