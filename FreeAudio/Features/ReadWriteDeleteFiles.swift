//
//  ReadWriteFiles.swift
//  FreeAudio
//
//  Created by 장대호 on 2021/10/01.
//

import Foundation
import AVFoundation

/**
 나의 아이폰 디렉토리에 name(파일 형식자 포함) 이름의 파일을 AVAsset으로 가져옵니다.
 */
func readAudioFile(with name:String) -> AVAsset? {
    let fileManager = FileManager.default
    let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    let filePath = documentsURL.appendingPathComponent(name)
    if fileManager.fileExists(atPath: filePath.path) == false {
        return nil
    } else {
        return AVAsset(url: filePath)
    }
}

func readAudioFileURL(with name: String) -> URL? {
    let fileManager = FileManager.default
    let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    let filePath = documentsURL.appendingPathComponent(name)
    if fileManager.fileExists(atPath: filePath.path) == false {
        return nil
    } else {
        return filePath
    }
}

/**
 [수정]
 나의 아이폰 디렉토리에 name(파일 형식자 포함) 이름의 파일을 저장합니다.
 다만 AVAsset 도 와야할것 같은데 수정이 필요함
 */
func writeAudioFile(with name:String) {
    let fileManager = FileManager.default
    let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    let filePath = documentsURL.appendingPathComponent(name)
    let text = "Hello Test Folder"
    
    //fileWrite
    do {
        try text.write(to: filePath, atomically: false, encoding: .utf8)
    }catch let error as NSError {
        print("Error creating File : \(error.localizedDescription)")
    }
}

/**
 오디오 파일 삭제
 나의 아이폰 디렉토리에 name(파일 형식자 포함) 이름의 파일을 삭제합니다.
 */
func deleteAudioFile(with name:String) {
    let fileManager = FileManager.default
    let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    let filePath = documentsURL.appendingPathComponent(name)
    do {
        try fileManager.removeItem(atPath: filePath.path)
    } catch {
        print("Error deleting file : \(error)")
    }
}
