//
//  testAudioMixViewController.swift
//  FreeAudio
//
//  Created by 장대호 on 2021/10/03.
//

import Foundation
import UIKit
import AVFoundation
class testAudioMixViewController: UIViewController {

    @IBOutlet weak var musicName: UILabel!
    let getList = readMyIphoneDirectorysInfos()
    let player = AVPlayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //무음모드일때 소리 안나는거 해결해줄거임
        try! AVAudioSession.sharedInstance().setCategory(.playback)
        // Do any additional setup after loading the view.
        tmp_func()
        
    }
    func tmp_func() {
        if getList.isEmpty == true { return }
        let audioAsset = readAudioFile(with: getList[0])!
        
        
        let item = AVPlayerItem(asset: audioAsset)
        player.replaceCurrentItem(with: item)
        player.play()
        
    }
    @IBAction func tgewa(_ sender: UIButton) {
        let jumpTime = CMTimeMakeWithSeconds(0.0, preferredTimescale: Int32(NSEC_PER_SEC))
        player.seek(to: jumpTime)
    }
}
