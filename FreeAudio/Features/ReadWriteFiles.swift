//
//  ReadWriteFiles.swift
//  FreeAudio
//
//  Created by 장대호 on 2021/10/01.
//

import Foundation

func readFile() {
    
}

func writeFile(with name:String) {
    let fileManager = FileManager.default
    let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    let directoryURL = documentsURL.appendingPathComponent("FreeAudio")
    let filePath = directoryURL.appendingPathComponent(name)
    let text = "Hello Test Folder"
    
    // if directory it not exists
    if fileManager.fileExists(atPath: directoryURL.path) == false {
        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: false, attributes: nil)
        } catch {
            print("make directory Error erorr :\(error)")
            return
        }
    }
    
    //fileWrite
    do {
        try text.write(to: filePath, atomically: false, encoding: .utf8)
    }catch let error as NSError {
        print("Error creating File : \(error.localizedDescription)")
    }
}

func deleteFile(with name:String) {
    let fileManager = FileManager.default
    let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    let directoryURL = documentsURL.appendingPathComponent("FreeAudio")
    let filePath = directoryURL.appendingPathComponent(name)
    if fileManager.fileExists(atPath: directoryURL.path) == false {
        return
    }
    do {
        try fileManager.removeItem(atPath: filePath.path)
    } catch {
        print("Error deleting file : \(error)")
    }
}
