//
//  FreeAudioModelTEsts.swift
//  FreeAudioTests
//
//  Created by 장대호 on 2021/10/07.
//

import Foundation
import XCTest
@testable import FreeAudio
class FreeAudioModelTests: XCTestCase {
    let manager  = AudioEditManager()
    
    func test1and2() throws {
        manager.command(of: .trim)
        let frame = manager.getCurrentFrame()
        XCTAssertNil(frame)
    }
    
    
    func test3() throws {
        manager.appendNewFrame(audioFileName: "1stFrame")
        manager.appendNewFrame(audioFileName: "2stFrame")
        manager.appendNewFrame(audioFileName: "3stFrame")
        manager.command(of: .trim)
        manager.command(of: .changeTrimTimeRange)
        manager.command(of: .changeTrimTimeRange)
        manager.command(of: .changeTrimTimeRange)
        manager.command(of: .changeTrimTimeRange)
        manager.command(of: .changeTrimTimeRange)
        manager.command(of: .changeMergeTimeRange)
        manager.command(of: .merge)
        var offset = manager.debugOffset()
        var frame = manager.debugFrame()
        var ftop = manager.debugFrameTop()
        
        
        XCTAssert(offset == 6, "bbb:\(offset)")
        manager.undo()
        manager.undo()
        
        
        for _ in 0...20 { manager.undo() }
        offset = manager.debugOffset()
        frame = manager.debugFrame()
        ftop = manager.debugFrameTop()
        XCTAssert(offset == -1, "ㅠㅠㅠ")
        XCTAssert(frame == -1, "ㅠㅠㅠㄹ")
        XCTAssert(ftop == 3, "ㅠㅠㅠㄹ")
        manager.appendNewFrame(audioFileName: "4stFrame")
        offset = manager.debugOffset()
        frame = manager.debugFrame()
        ftop = manager.debugFrameTop()
        XCTAssert(offset == -1, "ㅠㅠㅠ")
        XCTAssert(frame == 0, "ㅠㅠㅠㄹ")
        XCTAssert(ftop == 1, "ㅠㅠㅠㄹ")
    }
    
    func test4() throws {
        manager.appendNewFrame(audioFileName: "1stFrame")
        manager.undo()
        let frame = manager.getCurrentFrame()
        XCTAssertNil(frame)
    }
}


/*
 1. 아무것도 없을때 명령어를 넣는거
 2. 아무것도 없을 때 프레임얻는 명령
 3. 다 추가하고 끝까지 undo 한 뒤 새로운 명령 추가
    이 떄는 하나의 프레임에 하나의 오프셋만 있는걸 기대하는거임
 4. 맨 초기로도 갈 수 있어야함
 */
