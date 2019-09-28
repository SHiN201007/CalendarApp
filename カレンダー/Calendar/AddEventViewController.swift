//
//  AddEventViewController.swift
//  カレンダー
//
//  Created by 松丸真 on 2019/09/28.
//  Copyright © 2019 松丸真. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class AddEventViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
  @IBOutlet weak var titleLabel: UITextField!
  @IBOutlet weak var contentText: UITextView!
  @IBOutlet weak var selectDayLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    selectDayLabel.text = selectDay
    
    titleLabel.delegate = self
    contentText.delegate = self
      // Do any additional setup after loading the view.
  }
  
  func setData() {
    if let user = Auth.auth().currentUser{//データが取得できなかったらスキップ。
      let db = Firestore.firestore().collection("users")
      db.document(user.uid).updateData([
        "selectDay": selectDay,
        "title": titleLabel.text ?? "nil",
        "content": contentText.text ?? "nil",
      ])
    }
  }
  
  // 追加ボタン
  @IBAction func addButton(_ sender: Any) {
    if titleLabel.text == "" || contentText.text == ""{ return } // textFieldが空の場合
    else {
      
      setData()
      dismiss(animated: true, completion: nil)
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    titleLabel.resignFirstResponder()
    return true
  }
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    titleLabel.resignFirstResponder()
    contentText.resignFirstResponder()
  }
}
