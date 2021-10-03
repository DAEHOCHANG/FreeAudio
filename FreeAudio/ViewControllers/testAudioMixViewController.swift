//
//  testAudioMixViewController.swift
//  FreeAudio
//
//  Created by 장대호 on 2021/10/03.
//

import Foundation
import UIKit
class testAudioMixViewController: UIViewController {

    @IBOutlet weak var musicName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let getList = readMyIphoneDirectorysInfos()
        if getList.count > 0 {
            musicName.text = getList[0]
        }
    }
}
