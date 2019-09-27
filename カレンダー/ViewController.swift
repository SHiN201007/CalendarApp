//
//  ViewController.swift
//  カレンダー
//
//  Created by 松丸真 on 2019/09/28.
//  Copyright © 2019 松丸真. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class ViewController: UIViewController, UITextFieldDelegate {
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var registerButton: UIButton!
  
  override func viewDidLoad() {
      super.viewDidLoad()
    emailTextField.delegate = self
    passwordTextField.delegate = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    //もしLoginしているなら
    if let _ = UserDefaults.standard.object(forKey: "login") as? String{
      // 遷移
      let storyboard: UIStoryboard = UIStoryboard(name: "Calendar", bundle: nil)
      let nextView = storyboard.instantiateInitialViewController()
      nextView!.modalPresentationStyle = .fullScreen
      self.present(nextView!, animated: true, completion: nil)
    }
  }
    
  @IBAction func loginButton(_ sender: Any) {
    login()
  }
  
  @IBAction func registerButton(_ sender: Any) {
    // Register遷移
    let storyboard: UIStoryboard = UIStoryboard(name: "Register", bundle: nil)
    let nextView = storyboard.instantiateInitialViewController()
    nextView!.modalPresentationStyle = .fullScreen
    self.present(nextView!, animated: true, completion: nil)
  }
  
  func login() {
    Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
      if error != nil {
        print("ログインできませんでした")
      }
      else {
        print("ログインできました")
        
        //UserDefaultsに値を登録
        UserDefaults.standard.set(self.emailTextField.text, forKey: "login")
        
        // 遷移
        let storyboard: UIStoryboard = UIStoryboard(name: "UserSetting", bundle: nil)
        let nextView = storyboard.instantiateInitialViewController()
        nextView!.modalPresentationStyle = .fullScreen
        self.present(nextView!, animated: true, completion: nil)
      }
    }
  }

}
