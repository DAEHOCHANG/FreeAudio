//
//  HomeViewRingtoneDetailInfoViewController.swift
//  FreeAudio
//
//  Created by 장대호 on 2021/10/10.
//

import Foundation
import UIKit

class HomeViewRingtoneDetailInfoViewController : UIViewController {
    
    @IBOutlet weak var modalView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let bounds = UIScreen.main.bounds
        let deviceWidth = bounds.width
        modalView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        modalView.layer.cornerRadius = deviceWidth / 9.71209
    }
}
