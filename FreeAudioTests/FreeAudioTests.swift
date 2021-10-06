//
//  FreeAudioTests.swift
//  FreeAudioTests
//
//  Created by 장대호 on 2021/09/30.
//

import XCTest
@testable import FreeAudio
import AVFoundation

class FreeAudioTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testFileWrite() throws {
        let filename = "testfile.txt"
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent(filename)
        writeAudioFile(with: filename) // test code only one line
        let ret = fileManager.fileExists(atPath: filePath.path)
        XCTAssertTrue(ret)
    }
    
    func testFileDelete() throws {
        let filename = "testfile.txt"
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent(filename)
        writeAudioFile(with: filename)
        deleteAudioFile(with: filename)
        let ret = fileManager.fileExists(atPath: filePath.path)
        XCTAssertFalse(ret)
    }
    func testFileRead() throws {
        let arr = readMyIphoneDirectorysInfos()
        for a in arr {
            let ret = readAudioFile(with: a)
            XCTAssertNotNil(ret)
        }
    }
    func testMyiphoneDirRead() throws {
        let minNumberOfTestFiles = 3
        let arr = readMyIphoneDirectorysInfos()
        print(arr)
        XCTAssert(arr.count >= minNumberOfTestFiles, "what the")
    }
    func testSplitAudioFile() throws {
        let arr = readMyIphoneDirectorysInfos()
        guard let asset = readAudioFile(with: arr[0]) else {XCTAssert(true, "뷁");return;}
        let dur = Double(asset.duration.value) / Double(asset.duration.timescale)
        trimAudioFile(file: asset, start: 0.0, end: dur/2, completionHandler: { [weak self] in
            let fileManager = FileManager()
            let url = URL(string: fileManager.temporaryDirectory.path + "/tmp.m4a")!
            let ret = fileManager.fileExists(atPath: fileManager.temporaryDirectory.path + "/tmp.m4a")
            XCTAssert(ret, "\(ret)")
            let tmpAudio = AVAsset(url: url)
        })
    }
}
