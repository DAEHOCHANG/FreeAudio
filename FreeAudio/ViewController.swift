//
//  ViewController.swift
//  FreeAudio
//
//  Created by 장대호 on 2021/09/30.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .blue
        
    }

    override func viewDidAppear(_ animated: Bool) {
        let vc = UIStoryboard(name: "testStoryBoard", bundle: nil).instantiateViewController(withIdentifier: "testView")
        present(vc, animated: true, completion: nil)
    }
}

