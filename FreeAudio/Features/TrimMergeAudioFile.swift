//
//  SplitMergeAudioFile.swift
//  FreeAudio
//
//  Created by 장대호 on 2021/10/05.
//

import Foundation
import AVFoundation
/*
 다듬는것과 합치는것은 tmp directory에 저장하는 것이 맞음
 그럼이제 tmp 에 저장된 파일을 나의 iphone으로 저장하는 함수도 필요함
 */

//저장하는것은 좋은데 파일명 작명도 중요함.
//또한 redo undo 가 실행 될 것임으로 stack의 형태로 저장될 수 있게끔 하면 좋을듯
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
func MergeAudioFile(originalAsset:AVAsset,will mergedAsset:AVAsset, start:Double,completionHandler:@escaping () -> Void) {
    let mixComposition = AVMutableComposition()
    let startCMTime = CMTimeMakeWithSeconds(start, preferredTimescale: Int32(NSEC_PER_SEC))
    
    guard let originalTrack = mixComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) else {print("Error making Original Track");return}
    guard let mergedlTrack = mixComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) else {print("Error making Merged Track");return}
    do {
        try originalTrack.insertTimeRange(
            CMTimeRangeMake(start: .zero, duration: originalAsset.duration),
            of: originalAsset.tracks(withMediaType: .audio)[0],
            at: .zero)
        
        try mergedlTrack.insertTimeRange(
            CMTimeRangeMake(start: .zero, duration: mergedAsset.duration),
            of: mergedAsset.tracks(withMediaType: .audio)[0],
            at: startCMTime)
    } catch {
        print("Error inserting time to original track")
        return
    }
    
    
    guard let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetAppleM4A) else {return}
    exporter.outputFileType =  AVFileType.m4a
    exporter.timeRange = CMTimeRangeFromTimeToTime(start: .zero, end: mixComposition.duration)
    let documentsURL = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    let filePath = documentsURL.appendingPathComponent("testt.m4a")
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
