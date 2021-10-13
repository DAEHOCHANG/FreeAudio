//
//  WaveFormAudioView.swift
//  FreeAudio
//
//  Created by 장대호 on 2021/10/12.
//

import Foundation
import UIKit
import AVFoundation
import Accelerate
class WaveFormAudioView:UIView {
    var asset: AVAsset? {
        didSet {
            viewDraw()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    init(audioAvasset:AVAsset) {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.asset = audioAvasset
        viewDraw()
    }
    
    private func viewDraw() {
        guard let asset = self.asset else {return}
        guard let assetReader = try? AVAssetReader(asset: asset) else {return}
        let track = asset.tracks[0]
        let settings :[String:Any] = [
            AVFormatIDKey: kAudioFormatLinearPCM,
            AVLinearPCMBitDepthKey : 16,
            AVLinearPCMIsBigEndianKey : false,
            AVLinearPCMIsFloatKey : false,
            AVLinearPCMIsNonInterleaved : false,
        ] as [String : Any]
        let output = AVAssetReaderTrackOutput(track: track, outputSettings:settings)
        assetReader.add(output)
        
        let formatDesc = track.formatDescriptions
        for anyTmp in formatDesc {
            let item:CMAudioFormatDescription = anyTmp as! CMAudioFormatDescription
            if let fmtDesc = CMAudioFormatDescriptionGetStreamBasicDescription(item) {
                //fmtDesc.pointee
            }
        }
        
    }
}


