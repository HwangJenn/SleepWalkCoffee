//
//  StampVC.swift
//  SleepWalkCoffee
//
//  Created by 황지현 on 2023/02/10.
//

import UIKit

class StampVC: UIViewController {

    @IBOutlet weak var stampImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTap.numberOfTapsRequired = 2
        stampImageView.addGestureRecognizer(doubleTap)
    }
    
    @objc private func doubleTapped() {
        performSegue(withIdentifier: "GoToCouponsVC", sender: self)
    }
}
