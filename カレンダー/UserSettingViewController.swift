//
//  UserSettingViewController.swift
//  カレンダー
//
//  Created by 松丸真 on 2019/09/28.
//  Copyright © 2019 松丸真. All rights reserved.
//

import UIKit

class UserSettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
  @IBAction func button(_ sender: Any) {
    // Calendar遷移
    let storyboard: UIStoryboard = UIStoryboard(name: "Calendar", bundle: nil)
    let nextView = storyboard.instantiateInitialViewController()
    nextView!.modalPresentationStyle = .fullScreen
    self.present(nextView!, animated: true, completion: nil)
  }

}
