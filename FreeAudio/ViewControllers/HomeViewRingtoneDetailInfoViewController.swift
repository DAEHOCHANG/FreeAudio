//
//  HomeViewRingtoneDetailInfoViewController.swift
//  FreeAudio
//
//  Created by 장대호 on 2021/10/10.
//

import Foundation
import UIKit
import AVFoundation

class HomeViewRingtoneDetailInfoViewController : UIViewController {
    
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var audioFileNameLabel: UILabel!
    @IBOutlet weak var playStopButton: UIStackView!
    var audioFileName: String = ""
    var audioAvasset: AVAsset?
    var isPlaying: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let bounds = UIScreen.main.bounds
        let deviceWidth = bounds.width
        modalView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        modalView.layer.cornerRadius = deviceWidth / 9.71209
        audioFileNameLabel.text = audioFileName
    }
    @IBAction func shareButtonAction(_ sender: Any) {
        
        
    }
    @IBAction func deleteButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "정말 삭제하시겠습니까?", message: "한번 삭제하면 되돌리지 못합니다.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel,handler:  nil)
        let delete = UIAlertAction(title: "삭제", style: .destructive, handler: deleteAction(action:))
        alert.addAction(cancel)
        alert.addAction(delete)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func makeRingtoneButtonAction(_ sender: Any) {
    }
    @IBAction func editButtonAction(_ sender: Any) {
    }
    
    func deleteAction(action:UIAlertAction) {
        //deleteAudioFile(with: audioFileName)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func playButtonAction(_ sender: UIButton) {
        isPlaying.toggle()
        if isPlaying == true {
            sender.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
}
