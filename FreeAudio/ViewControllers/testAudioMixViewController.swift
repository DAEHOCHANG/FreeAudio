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
        print(getList[0])
        
        let item = AVPlayerItem(asset: audioAsset)
        player.replaceCurrentItem(with: item)
        player.play()
        trimAudioFile(file: audioAsset, start: 0, end: 30, completionHandler: {})
    }
    @IBAction func tgewa(_ sender: UIButton) {
        let fileManager = FileManager()
        let url = URL(string: fileManager.temporaryDirectory.path + "/tmp.wav")!
        let ret = fileManager.fileExists(atPath: fileManager.temporaryDirectory.path + "/tmp.wav")
        print(ret)
        let tmpAudio = AVAsset(url: url)
        print(tmpAudio.duration)
    }
}
