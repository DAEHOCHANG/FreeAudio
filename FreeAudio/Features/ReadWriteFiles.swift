//
//  ReadWriteFiles.swift
//  FreeAudio
//
//  Created by 장대호 on 2021/10/01.
//

import Foundation

func readAudioFile() {
    
}

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
