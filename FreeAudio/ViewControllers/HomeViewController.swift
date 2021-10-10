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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableSetting()
        tablesHeightSetting()
        barButtonItemSetting()
    }
    func barButtonItemSetting() {
        let prevBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.right"), style: .plain, target: self, action: #selector(prevButtonAction(sender:)))
        let deleteBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteButtonAction(sender:)))
        let shareBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonAction(sender:)))
        let exportRingtoneBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "alarm"), style: .plain, target: self, action: #selector(exportRingtoneButtonAction(sender:)))
        prevBarItems = [prevBarButtonItem,exportRingtoneBarButtonItem,shareBarButtonItem,deleteBarButtonItem]
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
*/
extension HomeViewController {
    @IBAction func editButtonAction(sender:UIBarButtonItem) {
        changeBarButtonItems()
    }
    @objc func prevButtonAction(sender:UIBarButtonItem) {
        changeBarButtonItems()
    }
    @objc func deleteButtonAction(sender:UIBarButtonItem) {
        print("delete")
    }
    @objc func shareButtonAction(sender:UIBarButtonItem) {
        print("shareButton")
    }
    @objc func exportRingtoneButtonAction(sender:UIBarButtonItem) {
        print("exportRingtone")
    }
    
    func changeBarButtonItems() {
        guard let tmp = self.navigationController?.navigationBar.items?[0].rightBarButtonItems else {return}
        //self.navigationController?.navigationItem.setRightBarButtonItems(prevBarItems, animated: true)
        self.navigationController?.navigationBar.topItem?.setRightBarButtonItems(prevBarItems, animated: true)
        //self.navigationController?.navigationBar.items?[0].rightBarButtonItems = prevBarItems
        prevBarItems = tmp
    }
}


//tableView Delegate, Datasource
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
    
    //셀 클릭하는 순간 모달뷰가 나와야함
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewRingtoneDetailInfoViewController")
        vc?.modalPresentationStyle = .pageSheet
        present(vc!, animated: true, completion: {})
    }
}
