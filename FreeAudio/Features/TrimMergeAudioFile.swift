//
//  SplitMergeAudioFile.swift
//  FreeAudio
//
//  Created by 장대호 on 2021/10/05.
//

import Foundation
import AVFoundation


func trimAudioFile(file:AVAsset,start:Double,end:Double, completionHandler:@escaping () -> Void)  {
    guard let exporter = AVAssetExportSession(asset: file, presetName: AVAssetExportPresetAppleM4A) else {return}
    let startCMTime = CMTimeMakeWithSeconds(start, preferredTimescale: Int32(NSEC_PER_SEC))
    let endCMTime = CMTimeMakeWithSeconds(end, preferredTimescale: Int32(NSEC_PER_SEC))
 
    exporter.outputFileType =  AVFileType.m4a
    exporter.timeRange = CMTimeRangeFromTimeToTime(start: startCMTime, end: endCMTime)

    let documentsURL = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    let filePath = documentsURL.appendingPathComponent("test.m4a")
    exporter.outputURL = filePath
    exporter.exportAsynchronously {
        completionHandler()
        switch exporter.status {
        case AVAssetExportSession.Status.failed:
            print("Export failed.")
        default:
            print("Export complete.")
        }
    }
}

/**
 originalFile에 will mergedFile 을 합칠것이며 시간은 start ~ end 에 넣어줄것
 start, end는 음수일수 있다. 이떄는 원곡 파일보다 앞서 시작한다는 의미
 예를들어 -10 ~ 5에 넣게된다면 만들어지는 오디오 파일의 길이는 +10초가 될것임
 0~5는 기존 오디오와 곂처서 나오게 될 것이다.
 다만 end 가 originalFile의 시작지점(0.0)보다 작다면 end는 0.0으로 고정이 될 것이다.
 */
func MergeAudioFile(originalFile:AVAsset,will mergedFile:AVAsset, start:Double,end:Double) {
    return 
}
