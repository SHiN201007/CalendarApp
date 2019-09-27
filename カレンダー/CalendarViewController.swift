//
//  CalendarViewController.swift
//  カレンダー
//
//  Created by 松丸真 on 2019/09/28.
//  Copyright © 2019 松丸真. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class CalendarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
  @IBAction func logoutButton(_ sender: Any) {
    try? Auth.auth().signOut()
    UserDefaults.standard.removeObject(forKey: "login")
    // login遷移
    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let nextView = storyboard.instantiateInitialViewController()
    nextView!.modalPresentationStyle = .fullScreen
    self.present(nextView!, animated: true, completion: nil)
  }
  
}
