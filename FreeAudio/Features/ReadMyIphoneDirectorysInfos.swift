//
//  ReadMyIphoneDirectorysInfos.swift
//  FreeAudio
//
//  Created by 장대호 on 2021/10/01.
//

import Foundation

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
