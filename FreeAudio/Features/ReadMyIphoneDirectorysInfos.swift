//
//  ReadMyIphoneDirectorysInfos.swift
//  FreeAudio
//
//  Created by 장대호 on 2021/10/01.
//

import Foundation

/**
 나의 아이폰 디렉토리에 있는 파일들의 이름배열을 반환합니다.
 */
func readMyIphoneDirectorysInfos() -> [String] {
    let fileManager = FileManager.default
    let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    do {
        let fileList = try fileManager.contentsOfDirectory(atPath: documentsURL.path)
        return fileList
    }catch let error as NSError {
        print("Error reading my iphone directory's infos error:\(error)")
    }
    return []
}
