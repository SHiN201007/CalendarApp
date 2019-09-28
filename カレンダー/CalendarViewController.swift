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
import FSCalendar
import CalculateCalendarLogic

var selectDay:String = "" // global変数 

class CalendarViewController: UIViewController, FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance{
  @IBOutlet weak var calendar: FSCalendar!
  @IBOutlet weak var dayLabel: UILabel!
  @IBOutlet weak var eventLabel: UILabel!
  @IBOutlet weak var addButton: UIButton!
  @IBOutlet weak var textView: UITextView!
  
  var eventTextField:UITextField?
  var titles:String?
  var days:String?
  var contents:String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    weekdays()

    dayLabel.text = getToday(format:"MM月dd日")
    // デリゲートの設定
    self.calendar.dataSource = self
    self.calendar.delegate = self
  }
  
  // 曜日日本語化
  func weekdays() {
    self.calendar.calendarWeekdayView.weekdayLabels[0].text = "日"
    self.calendar.calendarWeekdayView.weekdayLabels[1].text = "月"
    self.calendar.calendarWeekdayView.weekdayLabels[2].text = "火"
    self.calendar.calendarWeekdayView.weekdayLabels[3].text = "水"
    self.calendar.calendarWeekdayView.weekdayLabels[4].text = "木"
    self.calendar.calendarWeekdayView.weekdayLabels[5].text = "金"
    self.calendar.calendarWeekdayView.weekdayLabels[6].text = "土"
  }
  
  fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
  fileprivate lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()

  // 祝日判定を行い結果を返すメソッド(True:祝日)
  func judgeHoliday(_ date : Date) -> Bool {
    //祝日判定用のカレンダークラスのインスタンス
    let tmpCalendar = Calendar(identifier: .gregorian)

    // 祝日判定を行う日にちの年、月、日を取得
    let year = tmpCalendar.component(.year, from: date)
    let month = tmpCalendar.component(.month, from: date)
    let day = tmpCalendar.component(.day, from: date)

    // CalculateCalendarLogic()：祝日判定のインスタンスの生成
    let holiday = CalculateCalendarLogic()

    return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
  }
  // date型 -> 年月日をIntで取得
  func getDay(_ date:Date) -> (Int,Int,Int){
    let tmpCalendar = Calendar(identifier: .gregorian)
    let year = tmpCalendar.component(.year, from: date)
    let month = tmpCalendar.component(.month, from: date)
    let day = tmpCalendar.component(.day, from: date)
    return (year,month,day)
  }

  //曜日判定(日曜日:1 〜 土曜日:7)
  func getWeekIdx(_ date: Date) -> Int{
    let tmpCalendar = Calendar(identifier: .gregorian)
    return tmpCalendar.component(.weekday, from: date)
  }

  // 土日や祝日の日の文字色を変える
  func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
    //祝日判定をする（祝日は赤色で表示する）
    if self.judgeHoliday(date){
        return UIColor.red
    }

    //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
    let weekday = self.getWeekIdx(date)
    if weekday == 1 {   //日曜日
        return UIColor.red
    }
    else if weekday == 7 {  //土曜日
        return UIColor.blue
    }

    return nil
  }
  
  // カレンダーをタップしたとき
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    getData() // 取得したデータ
    
    let tmpDate = Calendar(identifier: .gregorian)
    let month = tmpDate.component(.month, from: date)
    let day = tmpDate.component(.day, from: date)
    selectDay = "\(month)月\(day)日"
    print(selectDay)
    // データがある日の場合
    if days == selectDay {
      if titles != "" {
        eventLabel.text = titles
        eventLabel.textColor = .darkGray
        textView.text = contents
        textView.textColor = .darkGray
      }
    }else {
      // 予定がない場合
      eventLabel.text = "スケジュールはありません"
      eventLabel.textColor = .lightGray
      textView.text = ""
    }
    
    dayLabel.text = "\(selectDay)"
  }
  
  // 今日の日付を取得
  func getToday(format:String = "yyyy/MM/dd HH:mm:ss") -> String{
    let now = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: now as Date)
  }
  
  // firebaseからデータを取得
  func getData() {
    let user = Auth.auth().currentUser
    let db = Firestore.firestore().collection("users")
    
    db.document(user?.uid ?? "a").getDocument() { [weak self] snapshot, error in//ここで一旦が処理が飛んで、最後に以下が処理される
      guard let self = self else { return }
      guard Auth.auth().currentUser != nil else { return }
      
      if error != nil {return}
      guard let snapshot = snapshot, snapshot.exists,
        let data = snapshot.data() else {return}
      
      let title:String = data["title"] as! String
      self.titles = title
      let day:String = data["selectDay"] as! String
      self.days = day
      let content:String = data["content"] as! String
      self.contents = content
      print(self.titles ?? "nil", self.days ?? "nil", self.contents ?? "nil")
    }
  }
  
  @IBAction func addButton(_ sender: Any) {
    // AddEvent遷移
    let storyboard: UIStoryboard = UIStoryboard(name: "AddEvent", bundle: nil)
    let nextView = storyboard.instantiateInitialViewController()
    nextView!.modalPresentationStyle = .fullScreen
    self.present(nextView!, animated: true, completion: nil)
  }
  
  // ログアウト
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

