//
//  FreeAudioTests.swift
//  FreeAudioTests
//
//  Created by 장대호 on 2021/09/30.
//

import XCTest
@testable import FreeAudio

class FreeAudioTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
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
        let directoryURL = documentsURL.appendingPathComponent("FreeAudio")
        let filePath = directoryURL.appendingPathComponent(filename)
        writeFile(with: filename) // test code only one line
        let ret = fileManager.fileExists(atPath: filePath.path)
        XCTAssertTrue(ret)
    }
    func testFileDelete() throws {
        let filename = "testfile.txt"
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let directoryURL = documentsURL.appendingPathComponent("FreeAudio")
        let filePath = directoryURL.appendingPathComponent(filename)
        writeFile(with: filename)
        deleteFile(with: filename)
        let ret = fileManager.fileExists(atPath: filePath.path)
        XCTAssertFalse(ret)
    }
    func testFileRead() throws {
        
    }
}
