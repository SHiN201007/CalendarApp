//
//  RegisterViewController.swift
//  カレンダー
//
//  Created by 松丸真 on 2019/09/28.
//  Copyright © 2019 松丸真. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class RegisterViewController: UIViewController, UITextFieldDelegate {
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var acceptButton: UIButton!
  
  override func viewDidLoad() {
      super.viewDidLoad()
    emailTextField.delegate = self
    passwordTextField.delegate = self
  }
  
  @IBAction func acceptButton(_ sender: Any) {
    register()
  }
  
  func register() {
    Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
      if error != nil {
        print("登録できませんでした")
      }
      else {
        print("登録できました")
        self.setdata()
        //        Loginへ遷移
        self.dismiss(animated: true, completion: nil)
      }
    }
  }
  
  // セットデータベース
  private func setdata(){
    if let user = Auth.auth().currentUser{//データが取得できなかったらスキップ。
      let db = Firestore.firestore().collection("users")
      db.document(user.uid).setData([
        "userID": user.uid,
        "selectDay": "",
        "title": "",
        "content": "",
      ])
    }
  }
  
}
