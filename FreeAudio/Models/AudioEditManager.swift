//
//  AudioEditManager.swift
//  FreeAudio
//
//  Created by 장대호 on 2021/10/07.
//

import Foundation
import AVFoundation

/*
 redo undo에서 가장 중요하게 볼것은 파일이 바뀌었는지와 명령어 redo/undo와의 구분인것 같다.
 단순 명령어(다듬기 영역 취소같은)들은 파일이 바뀌지 않았음으로 작업이 엄청 간단 할 것이다.
 허나 파일이 바뀐다면 쉽지않을것이다.
 A파일을 작업하다 B파일을 열게되면 다듬는 영역을 포함해 많은것들이 초기값으로 바뀌게 될 것이고
 B작업에서 undo를 하게되면 바뀌기 전값을 가져와 뷰를 수정해야한다는 점이다.
 즉 파일만 교체해주는것이 아닌 다른 상태들도 가져와야한다는것.
 그러면 스택을 크게 파일단위로 보고 그 안에서 명령어 단위로 보면 될 것이다.
 A File     .....   B File  ......      C File
 top: trim 0,4      top: ~~~            top: ~~ (redo할게 없다면 현재 상황)
 ..
 0 : 뭔가의 작업       0: ~~~              0: ~~~~
 
 위와같은 상태에서 현재 상태는 CFile 의 top이라 해보자 여기서 undo를 하게되면
 명령어 하나하나들을 취소해 나아가다 0의 시점에서 undo 를 하게된다면
 B파일 top의 상태를 들고오면 된다는 것이다!.
 redo의 경우면 top인 경우 다음 파일의 0의 상태를 불러오면 되는것.
 
 이렇게되면 중요한 문제가 있다.
 B파일로 간 뒤 (혹은 C top에서 몇번 undo한 경우) 새로운 명령어를 넣으면 redo할 친구들은 사라져야 한다는점
 (이것을 트리처럼 만들어서 왔다갔다 할수 있게끔 해주면 좋긴 할건데 당장은 어려움)
 그래서 명령어를 받을 때 현재 명령어 (혹은 파일) 이 가장 최근 작업 바로 다음이 아니라면 현재 상태 이후 상태들을 지울 필요가 있다.(메모리 관리를위해)
 */

/*
 명령어 스택
 frameNumber 의 프레임에 offset 이 현재 작업 하는 장소임
 */
class AudioEditManager {
    private var frameTop: Int = 0
    private var offset: Int = -1
    private var frameNumber: Int = -1
    private var frames: [AudioEditingFrame] = []
    func redo() {
        let curFrameTop = frames[frameNumber].top
        if curFrameTop == offset + 1 {
            if frameNumber + 1 < frameTop {
                frameNumber += 1
                offset = -1
            }
        } else {
            offset += 1
        }
    }
    func undo() {
        if offset - 1 <= 0 {
            if frameNumber >= 0 {
                frameNumber -= 1
                if frameNumber >= 0 { offset = frames[frameNumber].top - 1 }
                else { offset = -1 }
            } 
        } else {
            offset -= 1
        }
    }
    func clearCurToLast() {
        //현재 프레임의 오프셋에서 새로운 동작이 발동했음으로
        //현재 프레임보다 높은 값들을 싹다 지우고, frameTop갱신
        //현재 프레임의 top도 변경해주어야 함 현재 오프셋 + 1로
        
        if frameNumber+1 < frameTop {
            frames.removeSubrange(frameNumber+1..<frameTop)
            frameTop = frameNumber + 1
        }
        if frameNumber > 0 && offset+1 >= 0 {
            frames[frameNumber].clearToLast(at: offset+1)
        }
    }
    func command(of working :AudioEditCommand) {
        //이전 명령어 확인해야함
        //다듬기 시간변경 은 이전에 다듬기 시간 변경 혹은 다듬기 명령어야함
        //같은 이유로 merge 시간변경도 이전게 merge시간 변경 혹은 merge가 나와야함
        //merge 와 trim 은 갑자기 나와도 상관이 없음
        
        if frameNumber < 0 {return}
        clearCurToLast()
        frames[frameNumber].command(of: working)
        offset = frames[frameNumber].top - 1
    }
    func appendNewFrame(audioFileName:String) {
        clearCurToLast()
        let newFrame = AudioEditingFrame(initialAudioFileName: audioFileName)
        frames.append(newFrame)
        offset = -1
        frameTop += 1
        frameNumber += 1
    }
    func getCurrentFrame() -> AudioEditingFrame? {
        if frames.count <= 0 {return nil}
        if frameNumber < 0 {return nil}
        return self.frames[frameNumber]
    }
}
extension AudioEditManager {
    func debugOffset() -> Int { return offset }
    func debugFrame() -> Int { return frameNumber }
    func debugArr() -> [AudioEditingFrame] { return frames }
    func debugFrameTop() -> Int { return frameTop }
}


/**
 현재 편집중인 파일(or Asset)       : 만들어진 순간을 제외하고는 항상 있음                  (String)
 추가(merged)될 파일(or Asset)   : 없을 수 있음                                                      (String)
 현재 상태                                    : 다듬기 / 다른 오디오 추가 / 기본상태                    (enum)
 확대 기록                                    : 다듬기나 오디오를 추가 할 때 확대 할 수 있음        ([extensionRecord])
 */
typealias TimeRange = (start:Double, end: Double)
struct AudioEditingFrame {
    private var _top:Int = 0
    var top:Int {return _top}
    let curAudioFileName:String
    var mergedAudioFileName:String?
    private var commands:[AudioEditCommand] = []
    fileprivate init(initialAudioFileName:String) {
        self.curAudioFileName = initialAudioFileName
    }
}

extension AudioEditingFrame {
    mutating func command(of working :AudioEditCommand) {
        let commandType = working.editType
        if case .changeTrimTimeRange = commandType {
            guard let lastWork = commands.last?.editType else {return}
            if !(lastWork == .trim || lastWork == .changeTrimTimeRange) {return}
        }
        if case .changeMergeTimeRange = commandType {
            guard let lastWork = commands.last?.editType else {return}
            if !(lastWork == .merge || lastWork == .changeMergeTimeRange) {return}
        }
        _top += 1
        self.commands.append(working)
    }
    //at is 0 ~ top-1
    mutating func clearToLast(at:Int) {
        if at >= _top {return}
        self.commands.removeSubrange(at..<_top)
        _top = at
    }
}

struct AudioEditCommand {
    var editType: AudioEditType
    var timeRange: TimeRange?
    init? (editType:AudioEditType,_ timeRange:TimeRange? = nil) {
        if editType == .trim || editType == .merge {
            if timeRange != nil {return nil}
        } else {
            if timeRange == nil {return nil}
        }
        self.editType = editType
        self.timeRange = timeRange
    }
}
//다듬는 영역 수정 명령어
//합치는 영역 수정 명령어
//다듬기 클릭하는 명령어
//합치기 클릭하는 명령어
enum AudioEditType {
    case trim
    case merge
    case changeTrimTimeRange
    case changeMergeTimeRange
    case normal
}

