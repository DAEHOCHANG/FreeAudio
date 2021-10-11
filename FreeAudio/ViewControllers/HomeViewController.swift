//
//  ViewController.swift
//  FreeAudio
//
//  Created by 장대호 on 2021/09/30.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var ringTunesTableView: UITableView!
    @IBOutlet weak var ringTunesTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var finderTableView: UITableView!
    @IBOutlet weak var finderTableViewHeightConstraint: NSLayoutConstraint!
    var curDir = readMyIphoneDirectorysInfos()
    var prevBarItems:[UIBarButtonItem] = []
    var multipleSelectMode:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableSetting()
        tablesHeightSetting()
        barButtonItemSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        curDir = readMyIphoneDirectorysInfos()
    }
    
    func barButtonItemSetting() {
        let prevBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.right"), style: .plain, target: self, action: #selector(prevButtonAction(sender:)))
        let deleteBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteButtonAction(sender:)))
        let shareBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonAction(sender:)))
        let exportRingtoneBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "alarm"), style: .plain, target: self, action: #selector(exportRingtoneButtonAction(sender:)))
        prevBarItems = [prevBarButtonItem,exportRingtoneBarButtonItem,deleteBarButtonItem,shareBarButtonItem]
    }
    
    func tablesHeightSetting() {
        let numberOfFilesInCurDir = curDir.count
        
        ringTunesTableViewHeightConstraint.constant = 150
        finderTableViewHeightConstraint.constant =
        CGFloat(50 + 50 * (numberOfFilesInCurDir))
    }
    
    func tableSetting() {
        ringTunesTableView.delegate = self
        ringTunesTableView.dataSource = self
        
        finderTableView.delegate = self
        finderTableView.dataSource = self
        
        finderTableView.rowHeight = UITableView.automaticDimension
        ringTunesTableView.rowHeight = UITableView.automaticDimension
        
        ringTunesTableView.isScrollEnabled = false
        finderTableView.isScrollEnabled = false
    }
    
}

/*NavigationBar item button action
 편집 누를시 다른 바 버튼들을 넣어줘야 하고 -> 버튼(혹은 슬라이드가 될련지) 을 통해 원상태로 돌아와야함
 그러한 이유로 다음과 같은 생각을 했음
 1. 클래스 자체에 두종류의 rigthBarButtonItems를 저장해두었다가 교체해주는 방식
 2. 이전 rigthBarButtonItems 만을 저장해 두었다가 "편집"버튼과 "->" 버튼을 눌러 교체해가는 방식
 2번 선택 완료
*/
extension HomeViewController {
    @IBAction func editButtonAction(sender:UIBarButtonItem) {
        changeBarButtonItems()
        finderTableView.allowsMultipleSelection = true
        multipleSelectMode = true
    }
    @objc func prevButtonAction(sender:UIBarButtonItem) {
        changeBarButtonItems()
        finderTableView.allowsMultipleSelection = false
        multipleSelectMode = false
    }
    @objc func deleteButtonAction(sender:UIBarButtonItem) {
        if finderTableView.indexPathsForSelectedRows == nil ||
            finderTableView.indexPathsForSelectedRows == [] { return }
        let alert = UIAlertController(title: "정말 삭제하시겠습니까?", message: "한번 삭제하면 되돌리지 못합니다.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let delete = UIAlertAction(title: "삭제", style: .destructive, handler: deleteAction(action:))
        alert.addAction(cancel)
        alert.addAction(delete)
        present(alert, animated: true, completion: nil)
    }
    @objc func shareButtonAction(sender:UIBarButtonItem) {
        guard let willSharedFileIndexs = finderTableView.indexPathsForSelectedRows else {return}
        var urls:[URL] = []
        for indexPath in willSharedFileIndexs {
            guard let fileURL = readAudioFileURL(with: curDir[indexPath.row]) else {return}
            urls.append(fileURL)
        }

        let acVc = UIActivityViewController(activityItems: urls, applicationActivities: nil)
        acVc.popoverPresentationController?.sourceView = self.view
        self.present(acVc, animated: true, completion: nil)
    }
    @objc func exportRingtoneButtonAction(sender:UIBarButtonItem) {
        let alert = UIAlertController(title: "준비중인 기능입니다.", message: "감사합니다..", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let delete = UIAlertAction(title: "확인", style: .destructive, handler: nil)
        alert.addAction(cancel)
        alert.addAction(delete)
        present(alert, animated: true, completion: nil)
    }
    
    func changeBarButtonItems() {
        guard let tmp = self.navigationController?.navigationBar.items?[0].rightBarButtonItems else {return}
        self.navigationController?.navigationBar.topItem?.setRightBarButtonItems(prevBarItems, animated: true)
        prevBarItems = tmp
    }
    func deleteAction(action:UIAlertAction) {
        let willDeleteIndexs = finderTableView.indexPathsForSelectedRows!
        for indexPath in willDeleteIndexs {
            //deleteAudioFile(with: curDir[indexPath.row])
            curDir[indexPath.row] = ""
        }
        curDir = curDir.filter { $0 != "" }
        finderTableView.deleteRows(at: willDeleteIndexs, with: .fade)
    }
}




//tableView Delegate, Datasource 테이블뷰 와 관련된것들
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number:Int = {
            if tableView == ringTunesTableView {
                return 2
            } else {
                return curDir.count
            }
        }()
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let text: String = {
            if tableView == ringTunesTableView {
                return "벨소리"
            } else {
                return curDir[indexPath.row]
            }
        }()
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = text
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = text
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UITableViewHeaderFooterView()
        let font = UIFont.systemFont(ofSize: 25)
        let text: String = {
            if tableView == ringTunesTableView {
                return "벨소리"
            } else {
                return "나의 아이폰"
            }
        }()
        
        if #available(iOS 14.0, *) {
            var content = header.defaultContentConfiguration()
            content.text = text
            content.textProperties.font = font
            header.contentConfiguration = content
        } else {
            header.textLabel?.text = text
            header.textLabel?.font = font
        }
        return header
    }
    
    //섹션 헤더 크기
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    //셀 크기
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    /*
     모드에 따라 다른 액션취해야함
     1. 셀 클릭하는 순간 모달뷰가 나와야함
     2. 여러개를 선택 할 수 있으며 드래그도 가능
        2.1 드래그를 멈추고 다시 드래그시 추가되는 형태
     2.2 드래그를 시작한 셀의 상태에 따라 드래그가 다르게. 선택안된거면 드래그시 선택만, 이미 선택된거라면 드래그시 선택 해제만
     2.2 1,2,3,4,5 중 2,3,4 가 선택되어있고 1에서 드래그를 할 시 1만 추가 되게끔(무조건 토글이 아님)
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if multipleSelectMode == false {
            tableView.deselectRow(at: indexPath, animated: false)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewRingtoneDetailInfoViewController") as? HomeViewRingtoneDetailInfoViewController
            vc?.modalPresentationStyle = .pageSheet
            vc?.audioFileName = curDir[indexPath.row]
            vc?.audioAvasset = readAudioFile(with: curDir[indexPath.row])
            present(vc!, animated: true, completion: {})
        } else {
            
        }
    }
    

}
