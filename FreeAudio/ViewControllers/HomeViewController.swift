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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableSetting()
        tablesHeightSetting()
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
