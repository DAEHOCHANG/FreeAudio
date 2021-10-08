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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableSetting()
        tablesHeightSetting()
    }
    
    func tablesHeightSetting() {
        ringTunesTableViewHeightConstraint.constant = 280
        finderTableViewHeightConstraint.constant = 500
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
                return 1
            } else {
                return 10
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
                return "나의 아이폰"
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    
}
